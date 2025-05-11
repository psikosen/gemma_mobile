import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';
import '../bloc/message/message_bloc.dart';
import '../utils/custom_page_transitions.dart';
import '../widgets/loading_animation.dart';
import 'message_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      context.read<MessageBloc>().add(SearchMessages(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: const InputDecoration(
              hintText: 'Search messages...',
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _performSearch(),
            textInputAction: TextInputAction.search,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageSearching) {
            return const Center(child: ChatLoadingAnimation());
          } else if (state is MessageSearchResults) {
            if (state.messages.isEmpty) {
              return _buildEmptyResults();
            }
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message = state.messages[index];
                  return _buildSearchResultItem(message, index);
                },
              ),
            );
          } else if (state is MessageSearchEmpty) {
            return _buildEmptyResults();
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
                ],
              ),
            );
          } else if (!_isSearching) {
            return Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Search your messages',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Enter search terms to find messages across all your chats',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Try different keywords or check your spelling',
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(Message message, int index) {
    final dateFormatter = DateFormat('MMM d, yyyy · h:mm a');
    final formattedDate = dateFormatter.format(message.timestamp);

    // Add a staggered animation effect to each result
    final animationDelay = Duration(milliseconds: 50 * index);
    
    return FutureBuilder(
      future: Future.delayed(animationDelay),
      builder: (context, snapshot) {
        // Start animation when delay completes
        if (snapshot.connectionState == ConnectionState.done) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(20 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideRightRoute(
                      page: MessagePage(threadId: message.threadId),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Highlight the search term in the content (this is a simple approach)
                      Text(
                        message.content,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Navigate to chat',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink(); // While waiting for the delay
      },
    );
  }
}
