import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_localizations.dart';
import '../core/widgets/common_widgets.dart';
import '../core/theme/app_theme.dart';

/// Home screen with main feature cards
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n?.appName ?? 'AutoCheck',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.welcome ?? 'Welcome to AutoCheck',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your trusted vehicle buying assistant',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/auto-match'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    icon: const Icon(Icons.search),
                    label: Text(l10n?.findPerfectVehicle ?? 'Find Your Perfect Vehicle'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick actions
            SectionHeader(
              title: 'Quick Actions',
              actionText: 'See all',
              onAction: () {},
            ),
            const SizedBox(height: 12),

            // Feature cards grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                FeatureCard(
                  title: l10n?.autoMatch ?? 'Auto Match',
                  description: 'Get vehicle recommendations based on your needs',
                  icon: Icons.auto_awesome,
                  color: Colors.purple,
                  onTap: () => context.push('/auto-match'),
                ),
                FeatureCard(
                  title: l10n?.startInspection ?? 'Start Inspection',
                  description: 'Check any vehicle with our guided checklist',
                  icon: Icons.checklist_rtl,
                  color: Colors.blue,
                  onTap: () => context.go('/inspect'),
                ),
                FeatureCard(
                  title: l10n?.blacklistCheck ?? 'Blacklist Check',
                  description: 'Check for accidents, theft, or tampering',
                  icon: Icons.security,
                  color: Colors.orange,
                  onTap: () => context.push('/blacklist-check'),
                ),
                FeatureCard(
                  title: l10n?.findInspector ?? 'Find Inspector',
                  description: 'Book professional inspection services',
                  icon: Icons.location_on,
                  color: Colors.green,
                  onTap: () => context.push('/marketplace'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tips section
            SectionHeader(
              title: 'Safety Tips',
              actionText: 'More tips',
              onAction: () {},
            ),
            const SizedBox(height: 12),

            _buildTipCard(
              context,
              icon: Icons.warning_amber,
              title: 'Avoid Scam Sellers',
              description:
                  'Never pay before seeing the vehicle. Always verify documents match the vehicle.',
              color: AppTheme.warningColor,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              context,
              icon: Icons.water_drop,
              title: 'Flood Damage Signs',
              description:
                  'Check for water stains under seats, musty smells, and rust in hidden areas.',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              context,
              icon: Icons.speed,
              title: 'Odometer Tampering',
              description:
                  'Compare wear on pedals and steering with claimed mileage. Check service records.',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        isThreeLine: true,
      ),
    );
  }
}
