import '../entities/message.dart';
import '../repositories/i_message_repository.dart';

class SaveMessageUseCase {
  final IMessageRepository repository;

  SaveMessageUseCase(this.repository);

  Future<void> call(Message message) {
    return repository.saveMessage(message);
  }
}
