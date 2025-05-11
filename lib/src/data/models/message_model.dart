import 'package:drift/drift.dart';
import 'package:rchat/src/domain/entities/message.dart';
import 'package:rchat/src/data/datasources/local/database.dart' as db;

/// Extension to map from database Message to domain Message
extension DatabaseMessageMapper on db.Message {
  /// Convert from database entity to domain entity
  Message toDomain() {
    return Message(
      messageId: messageId,
      threadId: threadId,
      senderId: senderId,
      content: content,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      status: status,
      messageType: messageType,
      localFilePath: localFilePath,
    );
  }
}

/// Extension to map from domain Message to database MessagesCompanion
extension DomainMessageMapper on Message {
  /// Convert from domain entity to database companion for inserts/updates
  db.MessagesCompanion toCompanion() {
    return db.MessagesCompanion.insert(
      messageId: messageId,
      threadId: threadId,
      senderId: senderId,
      content: content,
      timestamp: timestamp.millisecondsSinceEpoch,
      status: Value(status),
      messageType: Value(messageType),
      localFilePath: localFilePath != null ? Value(localFilePath) : const Value(null),
    );
  }
}
