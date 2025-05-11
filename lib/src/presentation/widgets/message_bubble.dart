import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('h:mm a');
    final formattedTime = dateFormatter.format(message.timestamp);
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: TextStyle(
                color: isMe
                    ? Colors.white.withOpacity(0.7)
                    : Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
