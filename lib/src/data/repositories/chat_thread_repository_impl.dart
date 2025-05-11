import 'package:drift/drift.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/repositories/i_chat_thread_repository.dart';
import '../datasources/local/database.dart' as db;
import '../models/chat_thread_model.dart';

class ChatThreadRepositoryImpl implements IChatThreadRepository {
  final db.AppDatabase _database;

  ChatThreadRepositoryImpl(this._database);

  @override
  Future<List<ChatThread>> getChatThreads({int limit = 20, int offset = 0}) async {
    final threadsFromDb = await _database.getAllChatThreads(
      limit: limit,
      offset: offset,
    );
    
    return threadsFromDb.map((threadData) => threadData.toDomain()).toList();
  }

  @override
  Future<ChatThread?> getChatThreadById(String threadId) async {
    final threadData = await _database.getChatThreadById(threadId);
    
    return threadData?.toDomain();
  }

  @override
  Future<void> createChatThread(ChatThread chatThread) async {
    await _database.insertChatThread(chatThread.toCompanion());
  }

  @override
  Future<void> updateChatThread(ChatThread chatThread) async {
    await _database.updateData(chatThread.toCompanion());
  }

  @override
  Future<void> deleteChatThread(String threadId) async {
    await _database.deleteChatThreadById(threadId);
  }

  @override
  Future<void> updateUnreadCount(String threadId, int unreadCount) async {
    await _database.updateChatThreadUnreadCount(threadId, unreadCount);
  }
}

extension on db.AppDatabase {
  // Helper method to update a chat thread in the database
  Future<void> updateData(db.ChatThreadsCompanion threadCompanion) async {
    final threadId = threadCompanion.threadId.value;
    
    // Use simpler update pattern with individual update statements
    // This avoids issues with the customUpdate method
    if (threadCompanion.name.present) {
      await (update(chatThreads)
        ..where((t) => t.threadId.equals(threadId)))
        .write(db.ChatThreadsCompanion(name: threadCompanion.name));
    }
    
    if (threadCompanion.lastMessageTimestamp.present) {
      await (update(chatThreads)
        ..where((t) => t.threadId.equals(threadId)))
        .write(db.ChatThreadsCompanion(lastMessageTimestamp: threadCompanion.lastMessageTimestamp));
    }
    
    if (threadCompanion.unreadCount.present) {
      await (update(chatThreads)
        ..where((t) => t.threadId.equals(threadId)))
        .write(db.ChatThreadsCompanion(unreadCount: threadCompanion.unreadCount));
    }
  }
}
