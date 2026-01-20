import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_localizations.dart';

/// Main shell with bottom navigation bar
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/inspect')) return 1;
    if (location.startsWith('/compare')) return 2;
    if (location.startsWith('/history')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/inspect');
        break;
      case 2:
        context.go('/compare');
        break;
      case 3:
        context.go('/history');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n?.home ?? 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist),
            label: l10n?.inspect ?? 'Inspect',
          ),
          NavigationDestination(
            icon: const Icon(Icons.compare_outlined),
            selectedIcon: const Icon(Icons.compare),
            label: l10n?.compare ?? 'Compare',
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n?.history ?? 'History',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: l10n?.profile ?? 'Profile',
          ),
        ],
      ),
    );
  }
}
