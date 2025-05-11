import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/local/database.dart';
import '../../data/repositories/chat_thread_repository_impl.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/repositories/i_chat_thread_repository.dart';
import '../../domain/repositories/i_message_repository.dart';
import '../../domain/usecases/get_chat_threads_usecase.dart';
import '../../domain/usecases/get_messages_for_thread_usecase.dart';
import '../../domain/usecases/save_message_usecase.dart';
import '../../domain/usecases/search_messages_usecase.dart';
import '../../presentation/bloc/chat_thread/chat_thread_bloc.dart';
import '../../presentation/bloc/message/message_bloc.dart';
import '../../presentation/bloc/models/model_bloc.dart';
import '../security/security_service.dart';

/// A simple service locator pattern implementation for dependency injection.
class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _dependencies = {};

  static ServiceLocator get instance => _instance;

  // Core
  late final AppDatabase _database;
  late final SecurityService _securityService;

  // Repositories
  late final IMessageRepository _messageRepository;
  late final IChatThreadRepository _chatThreadRepository;

  // Use Cases
  late final GetChatThreadsUseCase _getChatThreadsUseCase;
  late final GetMessagesForThreadUseCase _getMessagesForThreadUseCase;
  late final SaveMessageUseCase _saveMessageUseCase;
  late final SearchMessagesUseCase _searchMessagesUseCase;
  
  // BLoCs
  late final ChatThreadBloc _chatThreadBloc;
  late final MessageBloc _messageBloc;
  late final ModelBloc _modelBloc;

  /// Initialize all dependencies
  Future<void> init() async {
    // Core
    _securityService = SecurityService();
    _register<SecurityService>(_securityService);
    
    // Database
    _database = AppDatabase();
    _register<AppDatabase>(_database);

    // Repositories
    _messageRepository = MessageRepositoryImpl(_database);
    _chatThreadRepository = ChatThreadRepositoryImpl(_database);
    _register<IMessageRepository>(_messageRepository);
    _register<IChatThreadRepository>(_chatThreadRepository);

    // Use Cases
    _getChatThreadsUseCase = GetChatThreadsUseCase(_chatThreadRepository);
    _getMessagesForThreadUseCase = GetMessagesForThreadUseCase(_messageRepository);
    _saveMessageUseCase = SaveMessageUseCase(_messageRepository);
    _searchMessagesUseCase = SearchMessagesUseCase(_messageRepository);
    _register<GetChatThreadsUseCase>(_getChatThreadsUseCase);
    _register<GetMessagesForThreadUseCase>(_getMessagesForThreadUseCase);
    _register<SaveMessageUseCase>(_saveMessageUseCase);
    _register<SearchMessagesUseCase>(_searchMessagesUseCase);
    
    // BLoCs
    _chatThreadBloc = ChatThreadBloc(getChatThreadsUseCase: _getChatThreadsUseCase);
    _messageBloc = MessageBloc(
      getMessagesForThreadUseCase: _getMessagesForThreadUseCase,
      saveMessageUseCase: _saveMessageUseCase,
      searchMessagesUseCase: _searchMessagesUseCase,
    );
    _modelBloc = ModelBloc();
    _register<ChatThreadBloc>(_chatThreadBloc);
    _register<MessageBloc>(_messageBloc);
    _register<ModelBloc>(_modelBloc);
  }

  /// Register a dependency
  void _register<T>(T dependency) {
    _dependencies[T] = dependency;
  }

  /// Get a registered dependency
  T get<T>() {
    final dependency = _dependencies[T];
    if (dependency == null) {
      throw Exception('Dependency $T not found');
    }
    return dependency as T;
  }
  
  /// Get all BLoC providers for Flutter BLoC
  List<BlocProvider> get blocProviders => [
    BlocProvider<ChatThreadBloc>(
      create: (context) => _chatThreadBloc,
    ),
    BlocProvider<MessageBloc>(
      create: (context) => _messageBloc,
    ),
    BlocProvider<ModelBloc>(
      create: (context) => _modelBloc,
    ),
  ];

  /// Clean up resources
  Future<void> dispose() async {
    await _database.close();
    await _chatThreadBloc.close();
    await _messageBloc.close();
    await _modelBloc.close();
  }
}

final sl = ServiceLocator.instance;
