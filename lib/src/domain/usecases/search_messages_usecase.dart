import '../entities/message.dart';
import '../repositories/i_message_repository.dart';

class SearchMessagesUseCase {
  final IMessageRepository repository;

  SearchMessagesUseCase(this.repository);

  Future<List<Message>> call(String query) {
    return repository.searchMessages(query);
  }
}
