import '../entities/message.dart';

abstract class IMessageRepository {
  /// Retrieves messages for a given thread, ordered by timestamp in descending order
  Future<List<Message>> getMessagesForThread(String threadId, {int limit = 20, int offset = 0});
  
  /// Saves a new message
  Future<void> saveMessage(Message message);
  
  /// Searches for messages with the given query
  Future<List<Message>> searchMessages(String query);
  
  /// Deletes a message by ID
  Future<void> deleteMessage(String messageId);
  
  /// Gets a single message by ID
  Future<Message?> getMessageById(String messageId);
  
  /// Updates the status of a message
  Future<void> updateMessageStatus(String messageId, String status);
}
