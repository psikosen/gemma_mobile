import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/get_messages_for_thread_usecase.dart';
import '../../../domain/usecases/save_message_usecase.dart';
import '../../../domain/usecases/search_messages_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesForThreadUseCase _getMessagesForThreadUseCase;
  final SaveMessageUseCase _saveMessageUseCase;
  final SearchMessagesUseCase _searchMessagesUseCase;

  MessageBloc({
    required GetMessagesForThreadUseCase getMessagesForThreadUseCase,
    required SaveMessageUseCase saveMessageUseCase,
    required SearchMessagesUseCase searchMessagesUseCase,
  })  : _getMessagesForThreadUseCase = getMessagesForThreadUseCase,
        _saveMessageUseCase = saveMessageUseCase,
        _searchMessagesUseCase = searchMessagesUseCase,
        super(const MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<LoadMoreMessages>(_onLoadMoreMessages);
    on<SendMessage>(_onSendMessage);
    on<SearchMessages>(_onSearchMessages);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessageLoading());
    try {
      final messages = await _getMessagesForThreadUseCase(
        event.threadId,
        limit: event.limit,
      );
      if (messages.isEmpty) {
        emit(const MessageEmpty());
      } else {
        emit(MessageLoaded(
          threadId: event.threadId,
          messages: messages,
          hasReachedMax: messages.length < event.limit,
        ));
      }
    } catch (error) {
      emit(MessageError(error.toString()));
    }
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreMessages event,
    Emitter<MessageState> emit,
  ) async {
    final state = this.state;
    if (state is MessageLoaded && !state.hasReachedMax) {
      try {
        final moreMessages = await _getMessagesForThreadUseCase(
          event.threadId,
          limit: event.limit,
          offset: state.messages.length,
        );
        
        if (moreMessages.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(
            MessageLoaded(
              threadId: state.threadId,
              messages: [...state.messages, ...moreMessages],
              hasReachedMax: moreMessages.length < event.limit,
            ),
          );
        }
      } catch (error) {
        emit(MessageError(error.toString()));
      }
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    final state = this.state;
    try {
      // Create a new message
      final message = Message(
        messageId: const Uuid().v4(),
        threadId: event.threadId,
        senderId: 'user', // Fixed user ID for now
        content: event.content,
        timestamp: DateTime.now(),
      );
      
      // Save it to the database
      await _saveMessageUseCase(message);
      
      // Update state if already loaded
      if (state is MessageLoaded) {
        emit(MessageLoaded(
          threadId: state.threadId,
          messages: [message, ...state.messages],
          hasReachedMax: state.hasReachedMax,
        ));
      } else {
        // If not loaded yet, load the messages including the new one
        add(LoadMessages(threadId: event.threadId));
      }
    } catch (error) {
      emit(MessageError(error.toString()));
    }
  }

  Future<void> _onSearchMessages(
    SearchMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessageSearching());
    try {
      final searchResults = await _searchMessagesUseCase(event.query);
      if (searchResults.isEmpty) {
        emit(const MessageSearchEmpty());
      } else {
        emit(MessageSearchResults(messages: searchResults));
      }
    } catch (error) {
      emit(MessageError(error.toString()));
    }
  }
}
