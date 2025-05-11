import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart' as drift;
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/datasources/local/database.dart';
import '../../../domain/entities/message.dart' as domain;
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
      // First check if the thread exists in the database
      final threadExists = await _verifyChatThreadExists(event.threadId);
      
      if (!threadExists) {
        // Create a new thread if it doesn't exist
        await _createChatThread(event.threadId);
      }
      
      // Create a new message
      final message = domain.Message(
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
  
  // Helper method to check if a chat thread exists
  Future<bool> _verifyChatThreadExists(String threadId) async {
    try {
      // Using a direct database call for simplicity; in a real app, use a repository
      final db = sl.get<AppDatabase>();
      final thread = await db.getChatThreadById(threadId);
      return thread != null;
    } catch (e) {
      return false;
    }
  }
  
  // Helper method to create a new chat thread
  Future<void> _createChatThread(String threadId) async {
    try {
      // Using a direct database call for simplicity; in a real app, use a repository
      final db = sl.get<AppDatabase>();
      await db.insertChatThread(
        ChatThreadsCompanion(
          threadId: drift.Value(threadId),
          name: const drift.Value(null),
          lastMessageTimestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    } catch (e) {
      throw Exception('Failed to create chat thread: $e');
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
