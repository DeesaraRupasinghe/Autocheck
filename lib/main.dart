import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/app_state_provider.dart';
import 'routes/app_router.dart';
import 'firebase_options.dart';

/// Provider to track Firebase initialization state
/// This ensures Firebase-dependent widgets don't build before initialization
final firebaseInitProvider = FutureProvider<bool>((ref) async {
  try {
    // Initialize Firebase with platform-specific options
    // This must complete before any Firebase services (Auth, Firestore) are used
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Return false to indicate Firebase is not available
    // App will run in offline/demo mode
    return false;
  }
});

/// Main entry point for AutoCheck app
///
/// IMPORTANT: Firebase must be initialized BEFORE runApp() is called.
/// We use WidgetsFlutterBinding.ensureInitialized() first to ensure
/// Flutter engine is ready for async operations.
void main() async {
  // Ensure Flutter binding is initialized before any async operations
  // This is required for Firebase.initializeApp() to work correctly
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage (offline-first support)
  await Hive.initFlutter();

  // Get SharedPreferences instance for app settings persistence
  final sharedPreferences = await SharedPreferences.getInstance();

  // Run the app with Riverpod for state management
  // Firebase initialization is handled by firebaseInitProvider
  // to allow graceful error handling and loading states
  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider with actual instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const AutoCheckApp(),
    ),
  );
}

/// Root widget for AutoCheck application
///
/// Uses firebaseInitProvider to ensure Firebase is initialized
/// before any Firebase-dependent widgets are built.
class AutoCheckApp extends ConsumerWidget {
  const AutoCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch Firebase initialization state
    final firebaseInit = ref.watch(firebaseInitProvider);
    
    return firebaseInit.when(
      // Firebase initialized successfully (or gracefully failed)
      data: (isInitialized) {
        if (!isInitialized) {
          debugPrint('Running in offline/demo mode - Firebase not available');
        }
        return _buildApp(context, ref);
      },
      // Show loading indicator during Firebase initialization
      loading: () => MaterialApp(
        title: 'AutoCheck',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Initializing AutoCheck...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      // Show error screen if initialization fails catastrophically
      error: (error, stack) => MaterialApp(
        title: 'AutoCheck',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Refresh Firebase initialization
                      ref.invalidate(firebaseInitProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main app with routing and theming
  Widget _buildApp(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appState = ref.watch(appStateProvider);

    return MaterialApp.router(
      title: 'AutoCheck',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Routing
      routerConfig: router,

      // Localization
      locale: Locale(appState.locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
