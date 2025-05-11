import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/core/di/injection_container.dart' as di;
import 'src/core/security/security_service.dart';
import 'src/presentation/pages/chat_threads_page.dart';
import 'src/presentation/pages/passcode_verification_page.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await di.sl.init();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _homeScreenFuture;

  @override
  void initState() {
    super.initState();
    _homeScreenFuture = _getHomeScreen();
  }

  Future<Widget> _getHomeScreen() async {
    final securityService = di.sl.get<SecurityService>();
    final isPasscodeEnabled = await securityService.isPasscodeEnabled();
    
    if (isPasscodeEnabled) {
      return PasscodeVerificationPage(
        destination: MultiBlocProvider(
          providers: di.sl.blocProviders,
          child: const ChatThreadsPage(),
        ),
      );
    } else {
      return MultiBlocProvider(
        providers: di.sl.blocProviders,
        child: const ChatThreadsPage(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RCHAT',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // Deep purple
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Customize app bar theme
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Customize card theme
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Customize button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        // Customize text field theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // Customize app bar theme for dark mode
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Customize card theme for dark mode
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Customize button themes for dark mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        // Customize text field theme for dark mode
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Use system theme
      home: FutureBuilder<Widget>(
        future: _homeScreenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/icon/icon.png', 
                        errorBuilder: (context, error, stackTrace) {
                          // If asset not found, show a fallback icon
                          return const Icon(
                            Icons.chat,
                            size: 80,
                            color: Color(0xFF6750A4),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'RCHAT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6750A4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
