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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
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
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section - Hero card with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                boxShadow: isDark ? null : [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
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
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Your trusted vehicle buying assistant',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/auto-match'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      ),
                    ),
                    icon: const Icon(Icons.search),
                    label: Text(l10n?.findPerfectVehicle ?? 'Find Your Perfect Vehicle'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

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
                  color: AppTheme.primaryColor,
                  onTap: () => context.push('/auto-match'),
                ),
                FeatureCard(
                  title: l10n?.startInspection ?? 'Start Inspection',
                  description: 'Check any vehicle with our guided checklist',
                  icon: Icons.checklist_rtl,
                  color: AppTheme.successColor,
                  onTap: () => context.go('/inspect'),
                ),
                FeatureCard(
                  title: l10n?.blacklistCheck ?? 'Blacklist Check',
                  description: 'Check for accidents, theft, or tampering',
                  icon: Icons.security,
                  color: AppTheme.warningColor,
                  onTap: () => context.push('/blacklist-check'),
                ),
                FeatureCard(
                  title: l10n?.findInspector ?? 'Find Inspector',
                  description: 'Book professional inspection services',
                  icon: Icons.location_on,
                  color: AppTheme.riskGreen,
                  onTap: () => context.push('/marketplace'),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingLg),

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
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              context,
              icon: Icons.water_drop,
              title: 'Flood Damage Signs',
              description:
                  'Check for water stains under seats, musty smells, and rust in hidden areas.',
              color: AppTheme.primaryColor,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              context,
              icon: Icons.speed,
              title: 'Odometer Tampering',
              description:
                  'Compare wear on pedals and steering with claimed mileage. Check service records.',
              color: AppTheme.errorColor,
              isDark: isDark,
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
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: isDark ? null : AppTheme.softShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppTheme.spacingMd),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
