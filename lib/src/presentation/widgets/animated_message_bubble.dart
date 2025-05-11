import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';

class AnimatedMessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;
  final bool isLatestMessage;

  const AnimatedMessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.isLatestMessage = false,
  }) : super(key: key);

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Trigger animation if this is the latest message
    if (widget.isLatestMessage) {
      _controller.forward();
    } else {
      _controller.value = 1.0; // Skip animation for older messages
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('h:mm a');
    final formattedTime = dateFormatter.format(widget.message.timestamp);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: 0.8 + (_scaleAnimation.value * 0.2),
            child: Align(
              alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: widget.isMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.content,
                      style: TextStyle(
                        color: widget.isMe
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: widget.isMe
                                ? Colors.white.withOpacity(0.7)
                                : Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 12,
                          ),
                        ),
                        if (widget.isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
