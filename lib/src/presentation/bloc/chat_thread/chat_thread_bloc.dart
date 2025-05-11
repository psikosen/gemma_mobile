import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_thread.dart';
import '../../../domain/usecases/get_chat_threads_usecase.dart';

part 'chat_thread_event.dart';
part 'chat_thread_state.dart';

class ChatThreadBloc extends Bloc<ChatThreadEvent, ChatThreadState> {
  final GetChatThreadsUseCase _getChatThreadsUseCase;

  ChatThreadBloc({
    required GetChatThreadsUseCase getChatThreadsUseCase,
  }) : _getChatThreadsUseCase = getChatThreadsUseCase,
       super(const ChatThreadInitial()) {
    on<LoadChatThreads>(_onLoadChatThreads);
    on<LoadMoreChatThreads>(_onLoadMoreChatThreads);
    on<RefreshChatThreads>(_onRefreshChatThreads);
  }

  Future<void> _onLoadChatThreads(
    LoadChatThreads event,
    Emitter<ChatThreadState> emit,
  ) async {
    emit(const ChatThreadLoading());
    try {
      final chatThreads = await _getChatThreadsUseCase(limit: event.limit);
      if (chatThreads.isEmpty) {
        emit(const ChatThreadEmpty());
      } else {
        emit(ChatThreadLoaded(
          chatThreads: chatThreads,
          hasReachedMax: chatThreads.length < event.limit,
        ));
      }
    } catch (error) {
      emit(ChatThreadError(error.toString()));
    }
  }

  Future<void> _onLoadMoreChatThreads(
    LoadMoreChatThreads event,
    Emitter<ChatThreadState> emit,
  ) async {
    final state = this.state;
    if (state is ChatThreadLoaded && !state.hasReachedMax) {
      try {
        final moreThreads = await _getChatThreadsUseCase(
          limit: event.limit,
          offset: state.chatThreads.length,
        );
        
        if (moreThreads.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(
            ChatThreadLoaded(
              chatThreads: [...state.chatThreads, ...moreThreads],
              hasReachedMax: moreThreads.length < event.limit,
            ),
          );
        }
      } catch (error) {
        emit(ChatThreadError(error.toString()));
      }
    }
  }

  Future<void> _onRefreshChatThreads(
    RefreshChatThreads event,
    Emitter<ChatThreadState> emit,
  ) async {
    emit(const ChatThreadLoading());
    try {
      final chatThreads = await _getChatThreadsUseCase(limit: event.limit);
      if (chatThreads.isEmpty) {
        emit(const ChatThreadEmpty());
      } else {
        emit(ChatThreadLoaded(
          chatThreads: chatThreads,
          hasReachedMax: chatThreads.length < event.limit,
        ));
      }
    } catch (error) {
      emit(ChatThreadError(error.toString()));
    }
  }
}
