import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/chat_thread.dart';
import '../bloc/chat_thread/chat_thread_bloc.dart';
import '../bloc/message/message_bloc.dart';
import '../utils/custom_page_transitions.dart';
import '../widgets/animated_chat_thread_item.dart';
import '../widgets/loading_animation.dart';
import 'message_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class ChatThreadsPage extends StatefulWidget {
  const ChatThreadsPage({Key? key}) : super(key: key);

  @override
  State<ChatThreadsPage> createState() => _ChatThreadsPageState();
}

class _ChatThreadsPageState extends State<ChatThreadsPage> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ChatThreadBloc>().add(const LoadChatThreads());
    
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );
    
    // Delay the FAB animation for a nice entrance
    Future.delayed(const Duration(milliseconds: 500), () {
      _fabController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ChatThreadBloc>().add(const LoadMoreChatThreads());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RCHAT'),
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
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                SlideRightRoute(
                  page: const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatThreadBloc, ChatThreadState>(
        builder: (context, state) {
          if (state is ChatThreadInitial || state is ChatThreadLoading) {
            return const Center(
              child: ChatLoadingAnimation(),
            );
          } else if (state is ChatThreadLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatThreadBloc>().add(const RefreshChatThreads());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: state.hasReachedMax
                    ? state.chatThreads.length
                    : state.chatThreads.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.chatThreads.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: PulseLoadingIndicator(size: 30)),
                    );
                  }
                  final chatThread = state.chatThreads[index];
                  return AnimatedChatThreadItem(
                    chatThread: chatThread,
                    index: index,
                    onTap: () => _navigateToMessagePage(chatThread),
                  );
                },
              ),
            );
          } else if (state is ChatThreadEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No chat threads yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start a new conversation',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create New Chat'),
                    onPressed: () => _createNewChatThread(context),
                  ),
                ],
              ),
            );
          } else if (state is ChatThreadError) {
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
                      context.read<ChatThreadBloc>().add(const RefreshChatThreads());
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
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () => _createNewChatThread(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _navigateToMessagePage(ChatThread chatThread) {
    Navigator.push(
      context,
      SlideRightRoute(
        page: BlocProvider.value(
          value: sl.get<MessageBloc>(),
          child: MessagePage(threadId: chatThread.threadId),
        ),
      ),
    );
  }

  void _createNewChatThread(BuildContext context) {
    // This is just a simple implementation. In a real app, you'd want to
    // show a dialog to enter the thread name, etc.
    
    // Create a new thread with a timestamp of now
    final thread = ChatThread(
      threadId: const Uuid().v4(),
      name: 'New Chat',
      lastMessageTimestamp: DateTime.now(),
    );
    
    // We'd typically save this to the database first, but for simplicity,
    // we're just navigating to the MessagePage with the new thread ID
    _navigateToMessagePage(thread);
  }
}
