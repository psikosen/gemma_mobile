import '../entities/message.dart';
import '../repositories/i_message_repository.dart';

class GetMessagesForThreadUseCase {
  final IMessageRepository repository;

  GetMessagesForThreadUseCase(this.repository);

  Future<List<Message>> call(String threadId, {int limit = 20, int offset = 0}) {
    return repository.getMessagesForThread(threadId, limit: limit, offset: offset);
  }
}
