import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_thread.dart';

class AnimatedChatThreadItem extends StatefulWidget {
  final ChatThread chatThread;
  final VoidCallback onTap;
  final int index;

  const AnimatedChatThreadItem({
    Key? key,
    required this.chatThread,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedChatThreadItem> createState() => _AnimatedChatThreadItemState();
}

class _AnimatedChatThreadItemState extends State<AnimatedChatThreadItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.easeOut,
        ),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.3,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Delay the animation start based on the index for a staggered effect
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, h:mm a');
    final formattedDate = dateFormatter.format(widget.chatThread.lastMessageTimestamp);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _heightAnimation,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          radius: 24,
                          child: Text(
                            _getInitials(widget.chatThread.name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.chatThread.name ??
                                    'Chat ${widget.chatThread.threadId.substring(0, 8)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last message: $formattedDate',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (widget.chatThread.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              widget.chatThread.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) {
      return 'C';
    }
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}';
    } else if (parts.length == 1) {
      return parts.first[0];
    }
    return 'C';
  }
}
