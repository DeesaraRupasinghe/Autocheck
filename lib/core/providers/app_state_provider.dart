import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/models.dart';
import '../constants/app_constants.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main');
});

/// App state provider for user session and settings
class AppState {
  final bool onboardingComplete;
  final UserRole userRole;
  final String locale;
  final bool isDarkMode;
  final UserModel? currentUser;

  const AppState({
    this.onboardingComplete = false,
    this.userRole = UserRole.normalUser,
    this.locale = 'en',
    this.isDarkMode = false,
    this.currentUser,
  });

  AppState copyWith({
    bool? onboardingComplete,
    UserRole? userRole,
    String? locale,
    bool? isDarkMode,
    UserModel? currentUser,
  }) {
    return AppState(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      userRole: userRole ?? this.userRole,
      locale: locale ?? this.locale,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

/// State notifier for app-wide state
class AppStateNotifier extends StateNotifier<AppState> {
  final SharedPreferences _prefs;

  AppStateNotifier(this._prefs) : super(const AppState()) {
    _loadState();
  }

  void _loadState() {
    final onboardingComplete =
        _prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;
    final roleIndex = _prefs.getInt(AppConstants.userRoleKey) ?? 0;
    final locale = _prefs.getString(AppConstants.localeKey) ?? 'en';
    final isDarkMode = _prefs.getBool(AppConstants.themeKey) ?? false;

    state = AppState(
      onboardingComplete: onboardingComplete,
      userRole: UserRole.values[roleIndex],
      locale: locale,
      isDarkMode: isDarkMode,
    );
  }

  Future<void> completeOnboarding(UserRole role) async {
    await _prefs.setBool(AppConstants.onboardingCompleteKey, true);
    await _prefs.setInt(AppConstants.userRoleKey, role.index);
    state = state.copyWith(
      onboardingComplete: true,
      userRole: role,
    );
  }

  Future<void> setLocale(String locale) async {
    await _prefs.setString(AppConstants.localeKey, locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(AppConstants.themeKey, isDark);
    state = state.copyWith(isDarkMode: isDark);
  }

  Future<void> setUser(UserModel user) async {
    state = state.copyWith(currentUser: user);
  }

  Future<void> logout() async {
    state = state.copyWith(currentUser: null);
  }
}

/// Provider for app state
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppStateNotifier(prefs);
});

/// Provider for checking if user is an inspector
final isInspectorProvider = Provider<bool>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.userRole == UserRole.inspectionService;
});
