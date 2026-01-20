import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers/app_state_provider.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/auth/presentation/role_selection_screen.dart';
import '../features/auto_match/presentation/auto_match_screen.dart';
import '../features/vehicle_inspection/presentation/inspection_screen.dart';
import '../features/vehicle_inspection/presentation/inspection_checklist_screen.dart';
import '../features/health_score/presentation/health_score_screen.dart';
import '../features/blacklist_check/presentation/blacklist_check_screen.dart';
import '../features/inspection_marketplace/presentation/marketplace_screen.dart';
import '../features/vehicle_comparison/presentation/comparison_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import 'home_screen.dart';
import 'main_shell.dart';

/// App router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(appStateProvider);

  return GoRouter(
    initialLocation: appState.onboardingComplete ? '/home' : '/onboarding',
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

      // Main app with bottom navigation
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
      // If onboarding not complete and not on onboarding screens
      if (!appState.onboardingComplete &&
          !state.matchedLocation.startsWith('/onboarding') &&
          !state.matchedLocation.startsWith('/role-selection')) {
        return '/onboarding';
      }
      return null;
    },
  );
});
