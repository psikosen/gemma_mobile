class Message {
  final String messageId;
  final String threadId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String status;
  final String messageType;
  final String? localFilePath;

  const Message({
    required this.messageId,
    required this.threadId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.status = 'saved',
    this.messageType = 'text',
    this.localFilePath,
  });

  Message copyWith({
    String? messageId,
    String? threadId,
    String? senderId,
    String? content,
    DateTime? timestamp,
    String? status,
    String? messageType,
    String? localFilePath,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      threadId: threadId ?? this.threadId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      localFilePath: localFilePath ?? this.localFilePath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          messageId == other.messageId;

  @override
  int get hashCode => messageId.hashCode;

  @override
  String toString() {
    return 'Message{messageId: $messageId, threadId: $threadId, senderId: $senderId, content: $content, timestamp: $timestamp, status: $status, messageType: $messageType, localFilePath: $localFilePath}';
  }
}
