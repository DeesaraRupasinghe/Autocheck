import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';

/// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Stream provider for auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Provider for current Firebase user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Provider for current Firestore user data
final firestoreUserProvider = FutureProvider<FirestoreUser?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.read(authServiceProvider).getUserData(user.uid);
});

/// Provider for inspector profile (for inspector role)
final inspectorProfileProvider = FutureProvider<InspectorProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.read(authServiceProvider).getInspectorProfile(user.uid);
});

/// Auth state notifier for managing auth UI state
class AuthStateNotifier extends StateNotifier<AuthUIState> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthUIState());

  Future<void> signInWithGoogle() async {
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
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authService.signInWithEmail(email, password);
    
    state = state.copyWith(
      isLoading: false,
      error: result.isError ? result.errorMessage : null,
    );
  }

  Future<void> signOut() async {
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
