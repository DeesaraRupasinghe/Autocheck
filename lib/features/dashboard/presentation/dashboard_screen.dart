import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';

/// Dashboard screen with user stats, recent activity, and quick actions
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and avatar
              _buildHeader(context),

              const SizedBox(height: AppTheme.spacingLg),

              // Stats Section - Horizontally scrollable
              _buildStatsSection(context, isDark),

              const SizedBox(height: AppTheme.spacingLg),

              // Recent Activity Section
              _buildRecentActivitySection(context, isDark),
            ],
          ),
        ),
      ),
      // Extended FAB for New Inspection
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inspection-checklist'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Inspection'),
      ),
    );
  }

  /// Builds the header with greeting and user avatar
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Alex',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        // User Avatar with subtle border
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            child: Text(
              'A',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns time-based greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  /// Builds the horizontally scrollable stats section
  Widget _buildStatsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Overview'),
        const SizedBox(height: AppTheme.spacingSm),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _StatCard(
                icon: Icons.fact_check_outlined,
                value: '24',
                label: 'Total Checked',
                color: AppTheme.primaryColor,
                isDark: isDark,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _StatCard(
                icon: Icons.pending_actions_outlined,
                value: '3',
                label: 'Pending',
                color: AppTheme.warningColor,
                isDark: isDark,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _StatCard(
                icon: Icons.warning_amber_outlined,
                value: '5',
                label: 'Issues Found',
                color: AppTheme.errorColor,
                isDark: isDark,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _StatCard(
                icon: Icons.check_circle_outline,
                value: '16',
                label: 'Completed',
                color: AppTheme.successColor,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the recent activity section with inspection cards
  Widget _buildRecentActivitySection(BuildContext context, bool isDark) {
    // Sample inspection data
    final recentInspections = [
      _InspectionData(
        carModel: 'Toyota Corolla',
        licensePlate: 'CAB-1234',
        status: InspectionStatus.completed,
        imageIcon: Icons.directions_car,
      ),
      _InspectionData(
        carModel: 'Honda Civic',
        licensePlate: 'WP-5678',
        status: InspectionStatus.inProgress,
        imageIcon: Icons.directions_car,
      ),
      _InspectionData(
        carModel: 'Nissan Sunny',
        licensePlate: 'NW-9012',
        status: InspectionStatus.issueFound,
        imageIcon: Icons.directions_car,
      ),
      _InspectionData(
        carModel: 'Suzuki Swift',
        licensePlate: 'SP-3456',
        status: InspectionStatus.completed,
        imageIcon: Icons.directions_car,
      ),
      _InspectionData(
        carModel: 'Mazda Axela',
        licensePlate: 'EP-7890',
        status: InspectionStatus.inProgress,
        imageIcon: Icons.directions_car,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Inspections',
          actionText: 'See all',
          onAction: () => context.go('/history'),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentInspections.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppTheme.spacingSm),
          itemBuilder: (context, index) {
            final inspection = recentInspections[index];
            return _InspectionCard(
              data: inspection,
              isDark: isDark,
              onTap: () {
                // Navigate to inspection details
              },
            );
          },
        ),
        // Add padding at bottom for FAB
        const SizedBox(height: 80),
      ],
    );
  }
}

/// Summary stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: isDark ? null : AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// Inspection status enum
enum InspectionStatus {
  inProgress,
  completed,
  issueFound,
}

/// Data class for inspection items
class _InspectionData {
  final String carModel;
  final String licensePlate;
  final InspectionStatus status;
  final IconData imageIcon;

  _InspectionData({
    required this.carModel,
    required this.licensePlate,
    required this.status,
    required this.imageIcon,
  });
}

/// Inspection card widget for the recent activity list
class _InspectionCard extends StatelessWidget {
  final _InspectionData data;
  final bool isDark;
  final VoidCallback? onTap;

  const _InspectionCard({
    required this.data,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: isDark ? null : AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                // Car image thumbnail (placeholder)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    data.imageIcon,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                // Car info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.carModel,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.licensePlate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                // Status chip
                _StatusChip(status: data.status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Status chip for inspection status
class _StatusChip extends StatelessWidget {
  final InspectionStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    String chipText;

    switch (status) {
      case InspectionStatus.inProgress:
        chipColor = AppTheme.primaryColor;
        chipText = 'In Progress';
        break;
      case InspectionStatus.completed:
        chipColor = AppTheme.successColor;
        chipText = 'Completed';
        break;
      case InspectionStatus.issueFound:
        chipColor = AppTheme.errorColor;
        chipText = 'Issue Found';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        chipText,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
