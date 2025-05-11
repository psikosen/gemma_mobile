part of 'chat_thread_bloc.dart';

abstract class ChatThreadEvent extends Equatable {
  const ChatThreadEvent();

  @override
  List<Object> get props => [];
}

class LoadChatThreads extends ChatThreadEvent {
  final int limit;

  const LoadChatThreads({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

class LoadMoreChatThreads extends ChatThreadEvent {
  final int limit;

  const LoadMoreChatThreads({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

class RefreshChatThreads extends ChatThreadEvent {
  final int limit;

  const RefreshChatThreads({this.limit = 20});

  @override
  List<Object> get props => [limit];
}
