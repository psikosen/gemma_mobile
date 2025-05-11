part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {
  final String threadId;
  final int limit;

  const LoadMessages({
    required this.threadId,
    this.limit = 20,
  });

  @override
  List<Object> get props => [threadId, limit];
}

class LoadMoreMessages extends MessageEvent {
  final String threadId;
  final int limit;

  const LoadMoreMessages({
    required this.threadId,
    this.limit = 20,
  });

  @override
  List<Object> get props => [threadId, limit];
}

class SendMessage extends MessageEvent {
  final String threadId;
  final String content;

  const SendMessage({
    required this.threadId,
    required this.content,
  });

  @override
  List<Object> get props => [threadId, content];
}

class SearchMessages extends MessageEvent {
  final String query;

  const SearchMessages({
    required this.query,
  });

  @override
  List<Object> get props => [query];
}
