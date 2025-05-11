# RCHAT Database Specification

## Overview
RCHAT uses Drift, a reactive persistence library built on top of SQLite, for local data storage. This document outlines the database schema, queries, and migration strategy.

## Tables

### ChatThread
Represents a conversation thread.

```dart
CREATE TABLE chat_threads (
    thread_id TEXT NOT NULL PRIMARY KEY,
    name TEXT,
    last_message_timestamp INTEGER NOT NULL,
    unread_count INTEGER NOT NULL DEFAULT 0
);
```

### Message
Represents an individual message within a thread.

```dart
CREATE TABLE messages (
    message_id TEXT NOT NULL PRIMARY KEY,
    thread_id TEXT NOT NULL REFERENCES chat_threads(thread_id),
    sender_id TEXT NOT NULL,
    content TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'saved',
    message_type TEXT NOT NULL DEFAULT 'text',
    local_file_path TEXT
);
```

### Indexes

```dart
CREATE INDEX idx_messages_thread_timestamp ON messages (thread_id, timestamp DESC);
```

### Full-Text Search
Using SQLite's FTS5 extension for message content search.

```dart
CREATE VIRTUAL TABLE messages_fts USING fts5(
    message_id UNINDEXED,
    content,
    tokenize = 'porter unicode61'
);
```

Triggers to keep FTS in sync:

```dart
CREATE TRIGGER messages_ai AFTER INSERT ON messages BEGIN
  INSERT INTO messages_fts (rowid, message_id, content)
  VALUES (new.rowid, new.message_id, new.content);
END;

CREATE TRIGGER messages_ad AFTER DELETE ON messages BEGIN
  DELETE FROM messages_fts WHERE rowid = old.rowid;
END;

CREATE TRIGGER messages_au AFTER UPDATE ON messages BEGIN
  UPDATE messages_fts SET content = new.content WHERE rowid = old.rowid;
END;
```

## Key Queries

### Thread Operations
1. Get all threads (paginated, sorted by most recent message):
```dart
SELECT * FROM chat_threads
ORDER BY last_message_timestamp DESC
LIMIT :limit OFFSET :offset;
```

2. Get thread by ID:
```dart
SELECT * FROM chat_threads
WHERE thread_id = :threadId;
```

3. Create new thread:
```dart
INSERT INTO chat_threads (thread_id, name, last_message_timestamp, unread_count)
VALUES (:threadId, :name, :timestamp, 0);
```

4. Update thread last message timestamp:
```dart
UPDATE chat_threads
SET last_message_timestamp = :timestamp
WHERE thread_id = :threadId;
```

### Message Operations
1. Get messages by thread ID (paginated, reverse chronological):
```dart
SELECT * FROM messages
WHERE thread_id = :threadId
ORDER BY timestamp DESC
LIMIT :limit OFFSET :offset;
```

2. Add new message:
```dart
INSERT INTO messages (
    message_id,
    thread_id,
    sender_id,
    content,
    timestamp,
    status,
    message_type,
    local_file_path
) VALUES (
    :messageId,
    :threadId,
    :senderId,
    :content,
    :timestamp,
    :status,
    :messageType,
    :localFilePath
);
```

3. Search messages:
```dart
SELECT m.* FROM messages m
INNER JOIN messages_fts fts ON m.message_id = fts.message_id
WHERE fts.content MATCH :searchTerm
ORDER BY m.timestamp DESC;
```

## Database Encryption
Using SQLCipher integration (sqlcipher_flutter_libs) to encrypt the database:

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'rchat.db'));
    
    // This is where we initialize SQLCipher with an encryption key
    return NativeDatabase.createInBackground(file, 
      setup: (rawDb) {
        // The encryption key should be securely derived from user input or securely stored
        rawDb.execute('PRAGMA key = "encryption_key_here";');
      }
    );
  });
}
```

## Migration Strategy
We'll use Drift's versioned migration system to handle schema changes:

```dart
@DriftDatabase(tables: [ChatThreads, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Example future migration
          // await m.addColumn(messages, messages.someNewColumn);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // Initialize with default data if needed
        }
      },
    );
  }
}
```

## Data Access Layer Design
The database will be encapsulated behind a repository interface, following Clean Architecture principles:

```dart
// Domain layer (interface)
abstract class IMessageRepository {
  Future<List<Message>> getMessagesForThread(String threadId, {int limit, int offset});
  Future<void> saveMessage(Message message);
  Future<List<Message>> searchMessages(String query);
  // Other methods...
}

// Data layer (implementation)
class MessageRepository implements IMessageRepository {
  final AppDatabase _database;
  
  MessageRepository(this._database);
  
  @override
  Future<List<Message>> getMessagesForThread(
    String threadId, {int limit = 20, int offset = 0}) async {
    // Implementation using Drift
  }
  
  // Other method implementations...
}
```
