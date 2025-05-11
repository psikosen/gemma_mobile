part of 'chat_thread_bloc.dart';

abstract class ChatThreadState extends Equatable {
  const ChatThreadState();
  
  @override
  List<Object> get props => [];
}

class ChatThreadInitial extends ChatThreadState {
  const ChatThreadInitial();
}

class ChatThreadLoading extends ChatThreadState {
  const ChatThreadLoading();
}

class ChatThreadLoaded extends ChatThreadState {
  final List<ChatThread> chatThreads;
  final bool hasReachedMax;

  const ChatThreadLoaded({
    required this.chatThreads,
    required this.hasReachedMax,
  });

  ChatThreadLoaded copyWith({
    List<ChatThread>? chatThreads,
    bool? hasReachedMax,
  }) {
    return ChatThreadLoaded(
      chatThreads: chatThreads ?? this.chatThreads,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [chatThreads, hasReachedMax];
}

class ChatThreadEmpty extends ChatThreadState {
  const ChatThreadEmpty();
}

class ChatThreadError extends ChatThreadState {
  final String message;

  const ChatThreadError(this.message);

  @override
  List<Object> get props => [message];
}
