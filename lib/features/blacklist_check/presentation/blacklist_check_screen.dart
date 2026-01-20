import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/models.dart';

/// Blacklist check screen for verifying vehicles
class BlacklistCheckScreen extends ConsumerStatefulWidget {
  const BlacklistCheckScreen({super.key});

  @override
  ConsumerState<BlacklistCheckScreen> createState() =>
      _BlacklistCheckScreenState();
}

class _BlacklistCheckScreenState extends ConsumerState<BlacklistCheckScreen> {
  final _registrationController = TextEditingController();
  final _chassisController = TextEditingController();
  bool _isLoading = false;
  BlacklistResult? _result;
  String? _error;

  @override
  void dispose() {
    _registrationController.dispose();
    _chassisController.dispose();
    super.dispose();
  }

  Future<void> _checkByRegistration() async {
    if (_registrationController.text.isEmpty) {
      setState(() => _error = 'Please enter a registration number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final service = ref.read(blacklistServiceProvider);
      final result =
          await service.checkByRegistration(_registrationController.text);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error checking vehicle: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkByChassis() async {
    if (_chassisController.text.isEmpty) {
      setState(() => _error = 'Please enter a chassis number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final service = ref.read(blacklistServiceProvider);
      final result = await service.checkByChassis(_chassisController.text);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error checking vehicle: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.blacklistCheck ?? 'Blacklist Check'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade700,
                    Colors.orange.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Vehicle Safety Check',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Check if a vehicle has any reported issues like accidents, floods, theft, or odometer tampering.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Registration number input
            Text(
              l10n?.enterRegistration ?? 'Enter Registration Number',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _registrationController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'CAR-1234 or WP-AB-5678',
                prefixIcon: const Icon(Icons.credit_card),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _isLoading ? null : _checkByRegistration,
                ),
              ),
              onSubmitted: (_) => _checkByRegistration(),
            ),

            const SizedBox(height: 24),

            // OR divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            // Chassis number input
            Text(
              l10n?.enterChassis ?? 'Enter Chassis Number',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _chassisController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'e.g., JT2AE91A1M0123456',
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _isLoading ? null : _checkByChassis,
                ),
              ),
              onSubmitted: (_) => _checkByChassis(),
            ),

            const SizedBox(height: 24),

            // Check button
            PrimaryButton(
              text: l10n?.checkNow ?? 'Check Now',
              icon: Icons.search,
              isLoading: _isLoading,
              onPressed: () {
                if (_registrationController.text.isNotEmpty) {
                  _checkByRegistration();
                } else if (_chassisController.text.isNotEmpty) {
                  _checkByChassis();
                } else {
                  setState(() =>
                      _error = 'Please enter a registration or chassis number');
                }
              },
            ),

            // Error message
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: AppTheme.errorColor),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_error!)),
                  ],
                ),
              ),
            ],

            // Result display
            if (_result != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(context, l10n),
            ],

            const SizedBox(height: 24),

            // Demo notice
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demo Mode',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Try: CAR-1234 (accident), WP-AB-5678 (flood + tampered), CHASSIS123456789 (stolen)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, AppLocalizations? l10n) {
    final result = _result!;
    final hasIssues = result.hasIssues;
    final color = hasIssues ? AppTheme.riskRed : AppTheme.riskGreen;

    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasIssues ? Icons.warning : Icons.check_circle,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasIssues
                            ? (l10n?.issuesFound ?? 'Issues Found')
                            : (l10n?.noIssuesFound ?? 'No Issues Found'),
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                      ),
                      if (result.registrationNumber != null)
                        Text('Registration: ${result.registrationNumber}'),
                      if (result.chassisNumber != null)
                        Text('Chassis: ${result.chassisNumber}'),
                    ],
                  ),
                ),
              ],
            ),

            if (hasIssues) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Flags
              ...result.flags.map((flag) => _buildFlagItem(context, flag)),
            ],

            if (!hasIssues) ...[
              const SizedBox(height: 16),
              Text(
                'This vehicle has no reported issues in our database. '
                'However, we still recommend a professional inspection before purchase.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 16),

            // Timestamp
            Text(
              'Checked: ${result.checkedAt.toString().split('.').first}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagItem(BuildContext context, BlacklistFlag flag) {
    final service = ref.read(blacklistServiceProvider);
    final description = service.getFlagDescription(flag);

    IconData icon;
    Color color;

    switch (flag) {
      case BlacklistFlag.accident:
        icon = Icons.car_crash;
        color = Colors.red;
        break;
      case BlacklistFlag.flood:
        icon = Icons.water;
        color = Colors.blue;
        break;
      case BlacklistFlag.stolen:
        icon = Icons.gpp_bad;
        color = Colors.purple;
        break;
      case BlacklistFlag.tampered:
        icon = Icons.speed;
        color = Colors.orange;
        break;
      case BlacklistFlag.legalIssue:
        icon = Icons.gavel;
        color = Colors.brown;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
