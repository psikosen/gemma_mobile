import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../bloc/message/message_bloc.dart';
import '../utils/custom_page_transitions.dart';
import '../widgets/animated_message_bubble.dart';
import '../widgets/loading_animation.dart';
import 'search_page.dart';

class MessagePage extends StatefulWidget {
  final String threadId;

  const MessagePage({
    Key? key,
    required this.threadId,
  }) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _sendButtonController;
  Animation<double>? _sendButtonAnimation;
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(LoadMessages(threadId: widget.threadId));
    _scrollController.addListener(_onScroll);
    _messageController.addListener(_onTextChanged);
    
    // Animation for the send button
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _sendButtonAnimation = CurvedAnimation(
      parent: _sendButtonController,
      curve: Curves.easeInOut,
    );
  }

  void _onTextChanged() {
    final hasText = _messageController.text.isNotEmpty;
    if (hasText && !_showSendButton) {
      setState(() {
        _showSendButton = true;
      });
      _sendButtonController.forward();
    } else if (!hasText && _showSendButton) {
      setState(() {
        _showSendButton = false;
      });
      _sendButtonController.reverse();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAtTop) {
      context.read<MessageBloc>().add(LoadMoreMessages(threadId: widget.threadId));
    }
  }

  bool get _isAtTop {
    if (!_scrollController.hasClients) return false;
    return _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9;
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    context.read<MessageBloc>().add(
          SendMessage(
            threadId: widget.threadId,
            content: messageText,
          ),
        );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                FadeRoute(
                  page: BlocProvider.value(
                    value: sl.get<MessageBloc>(),
                    child: const SearchPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageInitial || state is MessageLoading) {
                    return const Center(child: ChatLoadingAnimation());
                  } else if (state is MessageLoaded) {
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        itemCount: state.hasReachedMax
                            ? state.messages.length
                            : state.messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.messages.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: PulseLoadingIndicator(size: 30)),
                            );
                          }
                          final message = state.messages[index];
                          // In a real app, you'd determine if the message is from the current user
                          // based on the senderId. For this example, let's say all messages with
                          // senderId 'user' are from the current user.
                          final isMe = message.senderId == 'user';
                          // Only animate the latest message from the user (index 0 in the list)
                          final isLatestMessage = index == 0 && isMe;
                          return AnimatedMessageBubble(
                            message: message,
                            isMe: isMe,
                            isLatestMessage: isLatestMessage,
                          );
                        },
                      ),
                    );
                  } else if (state is MessageEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start the conversation!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  } else if (state is MessageError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MessageBloc>()
                                  .add(LoadMessages(threadId: widget.threadId));
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _sendButtonController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _sendButtonAnimation?.value ?? 0,
                        child: FloatingActionButton(
                          onPressed: _sendMessage,
                          mini: true,
                          child: const Icon(Icons.send),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
