part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageLoading extends MessageState {
  const MessageLoading();
}

class MessageLoaded extends MessageState {
  final String threadId;
  final List<domain.Message> messages;
  final bool hasReachedMax;

  const MessageLoaded({
    required this.threadId,
    required this.messages,
    required this.hasReachedMax,
  });

  MessageLoaded copyWith({
    String? threadId,
    List<domain.Message>? messages,
    bool? hasReachedMax,
  }) {
    return MessageLoaded(
      threadId: threadId ?? this.threadId,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [threadId, messages, hasReachedMax];
}

class MessageEmpty extends MessageState {
  const MessageEmpty();
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSearching extends MessageState {
  const MessageSearching();
}

class MessageSearchResults extends MessageState {
  final List<domain.Message> messages;

  const MessageSearchResults({required this.messages});

  @override
  List<Object> get props => [messages];
}

class MessageSearchEmpty extends MessageState {
  const MessageSearchEmpty();
}
