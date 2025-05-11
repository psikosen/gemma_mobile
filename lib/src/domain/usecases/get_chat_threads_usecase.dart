import '../entities/chat_thread.dart';
import '../repositories/i_chat_thread_repository.dart';

class GetChatThreadsUseCase {
  final IChatThreadRepository repository;

  GetChatThreadsUseCase(this.repository);

  Future<List<ChatThread>> call({int limit = 20, int offset = 0}) {
    return repository.getChatThreads(limit: limit, offset: offset);
  }
}
