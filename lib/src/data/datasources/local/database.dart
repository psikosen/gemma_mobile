import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/security/security_service.dart';

// This will give compile errors until you run the code generator
part 'database.g.dart';

// Table definitions
class ChatThreads extends Table {
  TextColumn get threadId => text()();
  TextColumn get name => text().nullable()();
  IntColumn get lastMessageTimestamp => integer()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {threadId};
}

class Messages extends Table {
  TextColumn get messageId => text()();
  TextColumn get threadId => text().references(ChatThreads, #threadId)();
  TextColumn get senderId => text()();
  TextColumn get content => text()();
  IntColumn get timestamp => integer()();
  TextColumn get status => text().withDefault(const Constant('saved'))();
  TextColumn get messageType => text().withDefault(const Constant('text'))();
  TextColumn get localFilePath => text().nullable()();

  @override
  Set<Column> get primaryKey => {messageId};
  
  @override
  List<Index> get indexes => [
    Index(
      'idx_messages_thread_timestamp', 
      'thread_id, timestamp',
    ),
  ];
}

@DriftDatabase(tables: [ChatThreads, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnectionSync());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Setup FTS5 virtual table for messages
        await customStatement('''
          CREATE VIRTUAL TABLE IF NOT EXISTS messages_fts USING fts5(
            message_id UNINDEXED,
            content,
            tokenize = 'porter unicode61'
          )
        ''');
        
        // Create triggers to keep FTS table in sync with the messages table
        await customStatement('''
          CREATE TRIGGER messages_ai AFTER INSERT ON messages BEGIN
            INSERT INTO messages_fts(rowid, message_id, content)
            VALUES (new.rowid, new.message_id, new.content);
          END;
        ''');
        
        await customStatement('''
          CREATE TRIGGER messages_ad AFTER DELETE ON messages BEGIN
            DELETE FROM messages_fts WHERE rowid = old.rowid;
          END;
        ''');
        
        await customStatement('''
          CREATE TRIGGER messages_au AFTER UPDATE ON messages BEGIN
            UPDATE messages_fts
            SET content = new.content
            WHERE rowid = old.rowid;
          END;
        ''');
      },
      onUpgrade: (m, oldVersion, newVersion) async {
        // Future migrations will go here
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
        
        if (details.wasCreated) {
          // Any initialization when database is created
        }
      },
    );
  }
  
  // Chat Threads queries
  Future<List<ChatThread>> getAllChatThreads({int limit = 20, int offset = 0}) {
    return (select(chatThreads)
      ..orderBy([(t) => OrderingTerm.desc(t.lastMessageTimestamp)])
      ..limit(limit, offset: offset))
      .get();
  }
  
  Future<ChatThread?> getChatThreadById(String threadId) {
    return (select(chatThreads)..where((t) => t.threadId.equals(threadId)))
      .getSingleOrNull();
  }
  
  Future<void> insertChatThread(ChatThreadsCompanion thread) {
    return into(chatThreads).insert(thread);
  }
  
  Future<void> updateChatThreadLastTimestamp(String threadId, int timestamp) {
    return (update(chatThreads)..where((t) => t.threadId.equals(threadId)))
      .write(ChatThreadsCompanion(lastMessageTimestamp: Value(timestamp)));
  }
  
  Future<void> updateChatThreadUnreadCount(String threadId, int count) {
    return (update(chatThreads)..where((t) => t.threadId.equals(threadId)))
      .write(ChatThreadsCompanion(unreadCount: Value(count)));
  }
  
  Future<void> deleteChatThreadById(String threadId) {
    return transaction(() async {
      // First delete all messages in the thread
      await (delete(messages)..where((m) => m.threadId.equals(threadId))).go();
      // Then delete the thread itself
      await (delete(chatThreads)..where((t) => t.threadId.equals(threadId))).go();
    });
  }
  
  // Messages queries
  Future<List<Message>> getMessagesForThread(String threadId, {int limit = 20, int offset = 0}) {
    return (select(messages)
      ..where((m) => m.threadId.equals(threadId))
      ..orderBy([(m) => OrderingTerm.desc(m.timestamp)])
      ..limit(limit, offset: offset))
      .get();
  }
  
  Future<Message?> getMessageById(String messageId) {
    return (select(messages)..where((m) => m.messageId.equals(messageId)))
      .getSingleOrNull();
  }
  
  Future<void> insertMessage(MessagesCompanion message) {
    return transaction(() async {
      // Insert the message
      await into(messages).insert(message);
      
      // Update the thread's last message timestamp
      await updateChatThreadLastTimestamp(
        message.threadId.value, 
        message.timestamp.value
      );
    });
  }
  
  Future<void> updateMessageStatus(String messageId, String status) {
    return (update(messages)..where((m) => m.messageId.equals(messageId)))
      .write(MessagesCompanion(status: Value(status)));
  }
  
  Future<void> deleteMessageById(String messageId) {
    return (delete(messages)..where((m) => m.messageId.equals(messageId))).go();
  }
  
  // Full-text search
  Future<List<Message>> searchMessages(String query) async {
    final results = await customSelect(
      '''
      SELECT m.* FROM messages m
      INNER JOIN messages_fts fts ON m.message_id = fts.message_id
      WHERE fts.content MATCH ?
      ORDER BY m.timestamp DESC
      ''',
      variables: [Variable(query)],
      readsFrom: {messages},
    ).get();
    
    // Convert the raw results to Message objects by first getting all messages
    final messageIds = results.map((row) => row.read<String>('message_id')).toList();
    if (messageIds.isEmpty) {
      return [];
    }
    
    // Use a normal select to get the messages with these IDs
    return (select(messages)..where((m) => m.messageId.isIn(messageIds))).get();
  }
}

// First create a synchronous version for the main database connection
QueryExecutor _openConnectionSync() {
  // Create a database in the documents directory
  final dbFolder = Directory.systemTemp;
  final file = File(p.join(dbFolder.path, 'rchat.db'));
  
  return NativeDatabase(file);
}

// Keep the async version for background operations or initialization
Future<QueryExecutor> _openConnectionAsync() async {
  // Make sure the necessary libraries are loaded for SQLite to work on all platforms
  await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  
  // Get the application documents directory for storing the database
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'rchat.db'));
  
  // Try to get encryption key from security service
  String? encryptionKey;
  try {
    final securityService = sl.get<SecurityService>();
    encryptionKey = await securityService.getDatabaseEncryptionKey();
  } catch (e) {
    // SecurityService might not be initialized yet
    encryptionKey = null;
  }
  
  // If encryption key is available, use encrypted database
  if (encryptionKey != null && encryptionKey.isNotEmpty) {
    return NativeDatabase.createInBackground(file, 
      setup: (rawDb) {
        rawDb.execute('PRAGMA key = "$encryptionKey";');
      }
    );
  }
  
  // Otherwise use unencrypted database
  return NativeDatabase(file);
}
