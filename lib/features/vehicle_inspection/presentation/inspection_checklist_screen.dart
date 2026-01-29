import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/models.dart';
import '../../../services/inspection_data_provider.dart';

/// Inspection checklist screen with step-by-step guidance
class InspectionChecklistScreen extends ConsumerStatefulWidget {
  final VehicleType? vehicleType;
  final FuelType? fuelType;
  final int? vehicleAge;

  const InspectionChecklistScreen({
    super.key,
    this.vehicleType,
    this.fuelType,
    this.vehicleAge,
  });

  @override
  ConsumerState<InspectionChecklistScreen> createState() =>
      _InspectionChecklistScreenState();
}

class _InspectionChecklistScreenState
    extends ConsumerState<InspectionChecklistScreen>
    with SingleTickerProviderStateMixin {
  late List<InspectionItem> _items;
  late TabController _tabController;
  late List<String> _categories;
  VibrationTestResult? _vibrationTestResult;

  // Vehicle info for the report
  final _registrationController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = InspectionDataProvider.getInspectionItems(
      vehicleType: widget.vehicleType,
      fuelType: widget.fuelType,
      vehicleAge: widget.vehicleAge,
    );
    _categories = InspectionDataProvider.getCategories();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _registrationController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _updateAnswer(String itemId, InspectionAnswer answer) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = _items[index].copyWith(answer: answer);
      }
    });
  }

  List<InspectionItem> _getItemsForCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  int _getCompletedCount() {
    return _items.where((item) => item.answer != null).length;
  }

  double _getProgress() {
    if (_items.isEmpty) return 0;
    return _getCompletedCount() / _items.length;
  }

  Future<void> _startVibrationTest() async {
    final result = await showDialog<VibrationTestResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VibrationTestDialog(ref: ref),
    );

    if (result != null) {
      setState(() {
        _vibrationTestResult = result;
      });
    }
  }

  void _finishInspection() {
    // Create vehicle model
    final vehicle = VehicleModel(
      id: const Uuid().v4(),
      registrationNumber: _registrationController.text.isNotEmpty
          ? _registrationController.text
          : null,
      make: _makeController.text.isNotEmpty ? _makeController.text : null,
      model: _modelController.text.isNotEmpty ? _modelController.text : null,
      year: int.tryParse(_yearController.text),
      vehicleType: widget.vehicleType,
      fuelType: widget.fuelType,
      createdAt: DateTime.now(),
    );

    // Navigate to health score screen
    context.push(
      '/health-score',
      extra: {
        'items': _items,
        'vehicle': vehicle,
        'vibrationTest': _vibrationTestResult,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final completedCount = _getCompletedCount();
    final progress = _getProgress();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.inspectionChecklist ?? 'Inspection Checklist'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: _categories.map((cat) => Tab(text: cat)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildCategoryTab(context, category, l10n);
        }).toList(),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$completedCount of ${_items.length} items checked',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Vibration Test',
                      icon: Icons.vibration,
                      onPressed: _startVibrationTest,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Get Health Score',
                      onPressed: _finishInspection,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(
    BuildContext context,
    String category,
    AppLocalizations? l10n,
  ) {
    final items = _getItemsForCategory(category);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Vehicle info card (only on first tab)
        if (_categories.indexOf(category) == 0) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Information (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _registrationController,
                          decoration: const InputDecoration(
                            labelText: 'Registration No.',
                            hintText: 'CAR-1234',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Year',
                            hintText: '2020',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _makeController,
                          decoration: const InputDecoration(
                            labelText: 'Make',
                            hintText: 'Toyota',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _modelController,
                          decoration: const InputDecoration(
                            labelText: 'Model',
                            hintText: 'Axio',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Vibration test result if available
        if (_vibrationTestResult != null &&
            category == 'Engine & Mechanical') ...[
          _VibrationTestResultCard(result: _vibrationTestResult!),
          const SizedBox(height: 16),
        ],

        // Inspection items
        ...items.map((item) => _InspectionItemCard(
              item: item,
              onAnswerSelected: (answer) => _updateAnswer(item.id, answer),
            )),
      ],
    );
  }
}

class _InspectionItemCard extends StatelessWidget {
  final InspectionItem item;
  final Function(InspectionAnswer) onAnswerSelected;

  const _InspectionItemCard({
    required this.item,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(context),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // Risk weight indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRiskColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Risk: ${item.riskWeight}',
                    style: TextStyle(
                      fontSize: 10,
                      color: _getRiskColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Help text
            if (item.helpText != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.helpText!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Answer buttons
            Row(
              children: [
                Expanded(
                  child: _AnswerButton(
                    label: 'Yes',
                    icon: Icons.check,
                    color: AppTheme.successColor,
                    isSelected: item.answer == InspectionAnswer.yes,
                    onTap: () => onAnswerSelected(InspectionAnswer.yes),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AnswerButton(
                    label: 'No',
                    icon: Icons.close,
                    color: AppTheme.errorColor,
                    isSelected: item.answer == InspectionAnswer.no,
                    onTap: () => onAnswerSelected(InspectionAnswer.no),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AnswerButton(
                    label: 'Not Sure',
                    icon: Icons.help_outline,
                    color: AppTheme.warningColor,
                    isSelected: item.answer == InspectionAnswer.notSure,
                    onTap: () => onAnswerSelected(InspectionAnswer.notSure),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (item.answer) {
      case InspectionAnswer.yes:
        return Icons.check_circle;
      case InspectionAnswer.no:
        return Icons.cancel;
      case InspectionAnswer.notSure:
        return Icons.help;
      case null:
        return Icons.radio_button_unchecked;
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (item.answer) {
      case InspectionAnswer.yes:
        return AppTheme.successColor;
      case InspectionAnswer.no:
        return AppTheme.errorColor;
      case InspectionAnswer.notSure:
        return AppTheme.warningColor;
      case null:
        return Theme.of(context).colorScheme.outline;
    }
  }

  Color _getRiskColor() {
    if (item.riskWeight >= 8) return AppTheme.errorColor;
    if (item.riskWeight >= 5) return AppTheme.warningColor;
    return AppTheme.successColor;
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? color : Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VibrationTestDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _VibrationTestDialog({required this.ref});

  @override
  ConsumerState<_VibrationTestDialog> createState() =>
      _VibrationTestDialogState();
}

class _VibrationTestDialogState extends ConsumerState<_VibrationTestDialog> {
  bool _isRecording = false;
  int _countdown = 10;
  VibrationTestResult? _result;

  Future<void> _startTest() async {
    final sensorService = widget.ref.read(sensorServiceProvider);
    
    setState(() {
      _isRecording = true;
      _countdown = 10;
    });

    sensorService.startRecording();

    // Countdown timer
    for (int i = 10; i > 0; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    // Stop and get results
    final result = sensorService.stopRecordingAndAnalyze();
    
    setState(() {
      _isRecording = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Engine Vibration Test'),
      content: _result != null
          ? _buildResultView()
          : _isRecording
              ? _buildRecordingView()
              : _buildInstructionsView(),
      actions: [
        if (_result != null) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_result),
            child: const Text('Save Result'),
          ),
        ] else if (!_isRecording) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _startTest,
            child: const Text('Start Test'),
          ),
        ],
      ],
    );
  }

  Widget _buildInstructionsView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.vibration,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        const Text(
          'Instructions:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('1. Start the engine and let it idle'),
        const Text('2. Place your phone on the dashboard'),
        const Text('3. Press Start Test and wait 10 seconds'),
        const Text('4. Don\'t move the phone during the test'),
      ],
    );
  }

  Widget _buildRecordingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(strokeWidth: 8),
        ),
        const SizedBox(height: 24),
        Text(
          'Recording... $_countdown',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text('Keep the phone still'),
      ],
    );
  }

  Widget _buildResultView() {
    final result = _result!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          result.passed ? Icons.check_circle : Icons.warning,
          size: 64,
          color: result.passed ? AppTheme.successColor : AppTheme.warningColor,
        ),
        const SizedBox(height: 16),
        Text(
          result.passed ? 'Test Passed' : 'Test Failed',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: result.passed ? AppTheme.successColor : AppTheme.warningColor,
              ),
        ),
        const SizedBox(height: 16),
        _buildStatRow('Stability', '${result.stability.toStringAsFixed(1)}%'),
        _buildStatRow('Avg Acceleration',
            '${result.averageAcceleration.toStringAsFixed(2)} m/s²'),
        _buildStatRow('Max Acceleration',
            '${result.maxAcceleration.toStringAsFixed(2)} m/s²'),
        const SizedBox(height: 16),
        Text(
          result.passed
              ? 'Engine vibration appears normal'
              : 'Excessive vibration detected - may indicate engine issues',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _VibrationTestResultCard extends StatelessWidget {
  final VibrationTestResult result;

  const _VibrationTestResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: result.passed
          ? AppTheme.successColor.withValues(alpha: 0.1)
          : AppTheme.warningColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              result.passed ? Icons.check_circle : Icons.warning,
              color: result.passed ? AppTheme.successColor : AppTheme.warningColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vibration Test: ${result.passed ? 'Passed' : 'Failed'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Stability: ${result.stability.toStringAsFixed(1)}%',
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
}
