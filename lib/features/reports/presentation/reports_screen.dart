import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/theme/app_theme.dart';

/// Reports and history screen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Mock inspection history
    final mockHistory = [
      _InspectionHistoryItem(
        vehicleName: 'Toyota Axio 2018',
        registrationNumber: 'WP-CAR-1234',
        healthScore: 78,
        inspectedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      _InspectionHistoryItem(
        vehicleName: 'Honda Fit 2017',
        registrationNumber: 'WP-AB-5678',
        healthScore: 45,
        inspectedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      _InspectionHistoryItem(
        vehicleName: 'Suzuki Swift 2019',
        registrationNumber: 'SP-CD-9012',
        healthScore: 92,
        inspectedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.inspectionHistory ?? 'Inspection History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Add filter options
            },
          ),
        ],
      ),
      body: mockHistory.isEmpty
          ? EmptyStateWidget(
              icon: Icons.history,
              title: 'No inspection history',
              description:
                  'Your completed inspections will appear here',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockHistory.length,
              itemBuilder: (context, index) {
                return _HistoryCard(item: mockHistory[index]);
              },
            ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final _InspectionHistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scoreColor = item.healthScore >= 70
        ? AppTheme.riskGreen
        : item.healthScore >= 40
            ? AppTheme.riskYellow
            : AppTheme.riskRed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to detailed report
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report details coming soon!')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Score indicator
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${item.healthScore}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Vehicle info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.vehicleName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.registrationNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.inspectedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating PDF...')),
                      );
                    },
                    tooltip: 'Export PDF',
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share feature coming soon!')),
                      );
                    },
                    tooltip: 'Share',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _InspectionHistoryItem {
  final String vehicleName;
  final String registrationNumber;
  final int healthScore;
  final DateTime inspectedAt;

  _InspectionHistoryItem({
    required this.vehicleName,
    required this.registrationNumber,
    required this.healthScore,
    required this.inspectedAt,
  });
}
