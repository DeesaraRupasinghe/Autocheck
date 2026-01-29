import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/models.dart';
import '../../../services/health_score_service.dart';

/// Health score results screen
class HealthScoreScreen extends ConsumerStatefulWidget {
  final List<InspectionItem> inspectionItems;
  final VehicleModel vehicle;
  final VibrationTestResult? vibrationTest;

  const HealthScoreScreen({
    super.key,
    required this.inspectionItems,
    required this.vehicle,
    this.vibrationTest,
  });

  @override
  ConsumerState<HealthScoreScreen> createState() => _HealthScoreScreenState();
}

class _HealthScoreScreenState extends ConsumerState<HealthScoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  HealthScoreResult? _result;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _calculateScore();
  }

  void _calculateScore() {
    final service = ref.read(healthScoreServiceProvider);
    _result = service.calculateHealthScore(widget.inspectionItems);

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: _result!.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _generatePdfReport() async {
    if (_result == null) return;

    setState(() => _isGeneratingPdf = true);

    try {
      final pdfService = ref.read(pdfServiceProvider);
      
      final inspectionResult = InspectionResult(
        id: const Uuid().v4(),
        vehicle: widget.vehicle,
        items: widget.inspectionItems,
        healthScore: _result!.score,
        riskLevel: _result!.riskLevel,
        recommendation: _result!.recommendation,
        inspectedAt: DateTime.now(),
        vibrationTest: widget.vibrationTest,
      );

      final file = await pdfService.generateInspectionReport(inspectionResult);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved: ${file.path}'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_result == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.healthScore ?? 'Health Score'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score display
            _buildScoreCard(context),

            const SizedBox(height: 24),

            // Risk level and recommendation
            _buildRecommendationCard(context),

            const SizedBox(height: 24),

            // Category breakdown
            _buildCategoryBreakdown(context),

            const SizedBox(height: 24),

            // Critical issues
            if (_result!.score < 70) ...[
              _buildCriticalIssues(context),
              const SizedBox(height: 24),
            ],

            // Vibration test result
            if (widget.vibrationTest != null) ...[
              _buildVibrationTestCard(context),
              const SizedBox(height: 24),
            ],

            // Action buttons
            _buildActionButtons(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              widget.vehicle.displayName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, child) {
                return HealthScoreWidget(
                  score: _scoreAnimation.value.round(),
                  size: 160,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context) {
    final riskColor = _result!.riskLevel == RiskLevel.safe
        ? AppTheme.riskGreen
        : _result!.riskLevel == RiskLevel.mediumRisk
            ? AppTheme.riskYellow
            : AppTheme.riskRed;

    return Card(
      color: riskColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _result!.riskLevel == RiskLevel.safe
                      ? Icons.check_circle
                      : _result!.riskLevel == RiskLevel.mediumRisk
                          ? Icons.warning
                          : Icons.error,
                  color: riskColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _result!.riskLevel.displayName,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: riskColor,
                                ),
                      ),
                      Text(
                        _result!.riskLevel.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.recommend, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Recommendation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_result!.recommendation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ..._result!.categoryScores.entries.map((entry) {
              final color = entry.value >= 70
                  ? AppTheme.riskGreen
                  : entry.value >= 40
                      ? AppTheme.riskYellow
                      : AppTheme.riskRed;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text(
                          '${entry.value}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: entry.value / 100,
                      backgroundColor: color.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalIssues(BuildContext context) {
    final healthService = ref.read(healthScoreServiceProvider);
    final criticalItems =
        healthService.getCriticalIssues(widget.inspectionItems);
    final uncertainItems =
        healthService.getUncertainItems(widget.inspectionItems);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: AppTheme.riskRed,
                ),
                const SizedBox(width: 8),
                Text(
                  'Issues Found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (criticalItems.isNotEmpty) ...[
              Text(
                'Critical Issues:',
                style: TextStyle(
                  color: AppTheme.riskRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...criticalItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.cancel, size: 16, color: AppTheme.riskRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              if (item.helpText != null)
                                Text(
                                  item.helpText!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (uncertainItems.isNotEmpty) ...[
              Text(
                'Needs Verification:',
                style: TextStyle(
                  color: AppTheme.riskYellow,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...uncertainItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.help, size: 16, color: AppTheme.riskYellow),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.title)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVibrationTestCard(BuildContext context) {
    final test = widget.vibrationTest!;
    return Card(
      color: test.passed
          ? AppTheme.successColor.withValues(alpha: 0.1)
          : AppTheme.warningColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              test.passed ? Icons.check_circle : Icons.warning,
              color: test.passed ? AppTheme.successColor : AppTheme.warningColor,
              size: 40,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Engine Vibration Test',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    test.passed
                        ? 'Passed - Engine vibration is normal'
                        : 'Failed - Excessive vibration detected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Stability: ${test.stability.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations? l10n) {
    return Column(
      children: [
        PrimaryButton(
          text: l10n?.exportPdf ?? 'Export PDF Report',
          icon: Icons.picture_as_pdf,
          onPressed: _generatePdfReport,
          isLoading: _isGeneratingPdf,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          text: l10n?.findInspector ?? 'Find Professional Inspector',
          icon: Icons.location_on,
          onPressed: () => context.push('/marketplace'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/home'),
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}
