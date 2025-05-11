import '../../domain/entities/message.dart';
import '../../domain/repositories/i_message_repository.dart';
import '../datasources/local/database.dart' as db;
import '../models/message_model.dart';

class MessageRepositoryImpl implements IMessageRepository {
  final db.AppDatabase _database;

  MessageRepositoryImpl(this._database);

  @override
  Future<List<Message>> getMessagesForThread(String threadId, {int limit = 20, int offset = 0}) async {
    final messagesFromDb = await _database.getMessagesForThread(
      threadId, 
      limit: limit,
      offset: offset,
    );
    
    return messagesFromDb.map((messageData) => messageData.toDomain()).toList();
  }

  @override
  Future<void> saveMessage(Message message) async {
    await _database.insertMessage(message.toCompanion());
  }

  @override
  Future<List<Message>> searchMessages(String query) async {
    final messagesFromDb = await _database.searchMessages(query);
    
    return messagesFromDb.map((messageData) => messageData.toDomain()).toList();
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _database.deleteMessageById(messageId);
  }

  @override
  Future<Message?> getMessageById(String messageId) async {
    final messageData = await _database.getMessageById(messageId);
    
    return messageData?.toDomain();
  }

  @override
  Future<void> updateMessageStatus(String messageId, String status) async {
    await _database.updateMessageStatus(messageId, status);
  }
}
