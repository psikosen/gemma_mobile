import '../entities/chat_thread.dart';

abstract class IChatThreadRepository {
  /// Gets all chat threads, ordered by last message timestamp in descending order
  Future<List<ChatThread>> getChatThreads({int limit = 20, int offset = 0});
  
  /// Gets a chat thread by ID
  Future<ChatThread?> getChatThreadById(String threadId);
  
  /// Creates a new chat thread
  Future<void> createChatThread(ChatThread chatThread);
  
  /// Updates a chat thread's last message timestamp and other fields
  Future<void> updateChatThread(ChatThread chatThread);
  
  /// Deletes a chat thread and all its messages
  Future<void> deleteChatThread(String threadId);
  
  /// Updates the unread count for a thread
  Future<void> updateUnreadCount(String threadId, int unreadCount);
}
