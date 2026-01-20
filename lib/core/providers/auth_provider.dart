import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';
import '../../main.dart' show firebaseInitProvider;

/// Provider for AuthService
/// 
/// IMPORTANT: This provider watches firebaseInitProvider to ensure
/// Firebase is initialized before creating AuthService.
/// Never access FirebaseAuth.instance before Firebase.initializeApp() completes.
final authServiceProvider = Provider<AuthService?>((ref) {
  // Watch Firebase initialization state
  final firebaseInit = ref.watch(firebaseInitProvider);
  
  // Only create AuthService if Firebase is initialized
  return firebaseInit.when(
    data: (isInitialized) {
      if (!isInitialized) {
        // Firebase not available - return null
        // App will run in offline/demo mode
        return null;
      }
      return AuthService();
    },
    loading: () => null, // Still loading
    error: (_, __) => null, // Failed to initialize
  );
});

/// Stream provider for auth state changes
/// 
/// Returns null stream if Firebase is not available
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  if (authService == null) {
    // Firebase not available - return empty stream
    return const Stream.empty();
  }
  return authService.authStateChanges;
});

/// Provider for current Firebase user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Provider for current Firestore user data
final firestoreUserProvider = FutureProvider<FirestoreUser?>((ref) async {
  final user = ref.watch(currentUserProvider);
  final authService = ref.read(authServiceProvider);
  if (user == null || authService == null) return null;
  return authService.getUserData(user.uid);
});

/// Provider for inspector profile (for inspector role)
final inspectorProfileProvider = FutureProvider<InspectorProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  final authService = ref.read(authServiceProvider);
  if (user == null || authService == null) return null;
  return authService.getInspectorProfile(user.uid);
});

/// Auth state notifier for managing auth UI state
class AuthStateNotifier extends StateNotifier<AuthUIState> {
  final AuthService? _authService;

  AuthStateNotifier(this._authService) : super(const AuthUIState());

  /// Check if Firebase/Auth is available
  bool get isAuthAvailable => _authService != null;

  Future<void> signInWithGoogle() async {
    if (_authService == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Authentication service not available. Please try again later.',
      );
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authService.signInWithGoogle();
    
    state = state.copyWith(
      isLoading: false,
      error: result.isError ? result.errorMessage : null,
      isNewUser: result.isNewUser,
      user: result.user,
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (_authService == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Authentication service not available. Please try again later.',
      );
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authService.signInWithEmail(email, password);
    
    state = state.copyWith(
      isLoading: false,
      error: result.isError ? result.errorMessage : null,
      isNewUser: result.isNewUser,
      user: result.user,
    );
  }

  Future<void> signOut() async {
    if (_authService == null) {
      state = const AuthUIState();
      return;
    }
    
    state = state.copyWith(isLoading: true);
    await _authService.signOut();
    state = const AuthUIState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// UI state for authentication
class AuthUIState {
  final bool isLoading;
  final String? error;
  final bool isNewUser;
  final User? user;

  const AuthUIState({
    this.isLoading = false,
    this.error,
    this.isNewUser = false,
    this.user,
  });

  AuthUIState copyWith({
    bool? isLoading,
    String? error,
    bool? isNewUser,
    User? user,
  }) {
    return AuthUIState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isNewUser: isNewUser ?? this.isNewUser,
      user: user ?? this.user,
    );
  }
}

/// Provider for auth UI state
final authUIStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthUIState>((ref) {
  return AuthStateNotifier(ref.read(authServiceProvider));
});
