import 'package:drift/drift.dart';
import 'package:rchat/src/domain/entities/chat_thread.dart';
import 'package:rchat/src/data/datasources/local/database.dart' as db;

/// Extension to map between database ChatThread and domain ChatThread
extension DatabaseChatThreadMapper on db.ChatThread {
  /// Convert from database entity to domain entity
  ChatThread toDomain() {
    return ChatThread(
      threadId: threadId,
      name: name,
      lastMessageTimestamp: DateTime.fromMillisecondsSinceEpoch(lastMessageTimestamp),
      unreadCount: unreadCount,
    );
  }
}

/// Extension to map from domain ChatThread to database ChatThreadsCompanion
extension DomainChatThreadMapper on ChatThread {
  /// Convert from domain entity to database companion for inserts/updates
  db.ChatThreadsCompanion toCompanion() {
    return db.ChatThreadsCompanion.insert(
      threadId: threadId,
      name: name != null ? Value(name) : const Value(null),
      lastMessageTimestamp: lastMessageTimestamp.millisecondsSinceEpoch,
      unreadCount: Value(unreadCount),
    );
  }
}
