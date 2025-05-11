import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_thread.dart';

class ChatThreadItem extends StatelessWidget {
  final ChatThread chatThread;
  final VoidCallback onTap;

  const ChatThreadItem({
    Key? key,
    required this.chatThread,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, h:mm a');
    final formattedDate = dateFormatter.format(chatThread.lastMessageTimestamp);

    return ListTile(
      title: Text(
        chatThread.name ?? 'Chat ${chatThread.threadId.substring(0, 8)}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Last message: $formattedDate',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: chatThread.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                chatThread.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
