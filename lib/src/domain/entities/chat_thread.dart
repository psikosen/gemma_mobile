class ChatThread {
  final String threadId;
  final String? name;
  final DateTime lastMessageTimestamp;
  final int unreadCount;

  const ChatThread({
    required this.threadId,
    this.name,
    required this.lastMessageTimestamp,
    this.unreadCount = 0,
  });

  ChatThread copyWith({
    String? threadId,
    String? name,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
  }) {
    return ChatThread(
      threadId: threadId ?? this.threadId,
      name: name ?? this.name,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatThread &&
          runtimeType == other.runtimeType &&
          threadId == other.threadId;

  @override
  int get hashCode => threadId.hashCode;

  @override
  String toString() {
    return 'ChatThread{threadId: $threadId, name: $name, lastMessageTimestamp: $lastMessageTimestamp, unreadCount: $unreadCount}';
  }
}
