import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/providers/app_state_provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/constants/app_constants.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/auth/presentation/role_selection_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/user_registration_screen.dart';
import '../features/auth/presentation/inspector_registration_screen.dart';
import '../features/auto_match/presentation/auto_match_screen.dart';
import '../features/vehicle_inspection/presentation/inspection_screen.dart';
import '../features/vehicle_inspection/presentation/inspection_checklist_screen.dart';
import '../features/health_score/presentation/health_score_screen.dart';
import '../features/blacklist_check/presentation/blacklist_check_screen.dart';
import '../features/inspection_marketplace/presentation/marketplace_screen.dart';
import '../features/inspection_marketplace/presentation/inspector_dashboard_screen.dart';
import '../features/vehicle_comparison/presentation/comparison_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import 'home_screen.dart';
import 'main_shell.dart';

/// App router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(appStateProvider);
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: _getInitialLocation(appState, authState),
    routes: [
      // Onboarding flow
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      
      // Authentication routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/user-registration',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return UserRegistrationScreen(
            firebaseUser: args?['user'] as User?,
          );
        },
      ),
      GoRoute(
        path: '/inspector-registration',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return InspectorRegistrationScreen(
            firebaseUser: args?['user'] as User?,
          );
        },
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => const LoginScreen(), // Reuse login screen for now
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const LoginScreen(), // Placeholder
      ),

      // Main app with bottom navigation (Normal User)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/inspect',
            builder: (context, state) => const InspectionScreen(),
          ),
          GoRoute(
            path: '/compare',
            builder: (context, state) => const ComparisonScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Inspector Dashboard (Inspection Service role)
      GoRoute(
        path: '/inspector-dashboard',
        builder: (context, state) => const InspectorDashboardScreen(),
      ),

      // Feature screens
      GoRoute(
        path: '/auto-match',
        builder: (context, state) => const AutoMatchScreen(),
      ),
      GoRoute(
        path: '/inspection-checklist',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return InspectionChecklistScreen(
            vehicleType: args?['vehicleType'],
            fuelType: args?['fuelType'],
            vehicleAge: args?['vehicleAge'],
          );
        },
      ),
      GoRoute(
        path: '/health-score',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return HealthScoreScreen(
            inspectionItems: args['items'],
            vehicle: args['vehicle'],
            vibrationTest: args['vibrationTest'],
          );
        },
      ),
      GoRoute(
        path: '/blacklist-check',
        builder: (context, state) => const BlacklistCheckScreen(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
    ],
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation.startsWith('/onboarding') ||
          state.matchedLocation.startsWith('/role-selection');
      final isAuth = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/user-registration') ||
          state.matchedLocation.startsWith('/inspector-registration') ||
          state.matchedLocation.startsWith('/create-account') ||
          state.matchedLocation.startsWith('/forgot-password');

      // If onboarding not complete, redirect to onboarding
      if (!appState.onboardingComplete && !isOnboarding) {
        return '/onboarding';
      }

      // If on auth pages but already logged in, redirect to appropriate home
      if (isAuth && authState.value != null) {
        if (appState.userRole == UserRole.inspectionService) {
          return '/inspector-dashboard';
        }
        return '/home';
      }

      return null;
    },
  );
});

String _getInitialLocation(AppState appState, AsyncValue<User?> authState) {
  if (!appState.onboardingComplete) {
    return '/onboarding';
  }
  
  // Check if user is logged in via Firebase
  if (authState.value != null) {
    if (appState.userRole == UserRole.inspectionService) {
      return '/inspector-dashboard';
    }
    return '/home';
  }
  
  return '/home';
}
