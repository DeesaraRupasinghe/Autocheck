import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/models.dart';

/// Vehicle inspection start screen
class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  VehicleType? _selectedVehicleType;
  FuelType? _selectedFuelType;
  int? _vehicleAge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.startInspection ?? 'Start Inspection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.checklist_rtl,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tell us about the vehicle',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll customize the checklist based on the vehicle type',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Vehicle Type Selection
            Text(
              'Vehicle Type (optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: VehicleType.values.map((type) {
                final isSelected = _selectedVehicleType == type;
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedVehicleType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Fuel Type Selection
            Text(
              'Fuel Type (optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FuelType.values.map((type) {
                final isSelected = _selectedFuelType == type;
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFuelType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Vehicle Age
            Text(
              'Vehicle Age (optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _AgeChip(
                  label: '0-3 years',
                  isSelected: _vehicleAge == 2,
                  onSelected: () => setState(() => _vehicleAge = 2),
                ),
                _AgeChip(
                  label: '3-5 years',
                  isSelected: _vehicleAge == 4,
                  onSelected: () => setState(() => _vehicleAge = 4),
                ),
                _AgeChip(
                  label: '5-10 years',
                  isSelected: _vehicleAge == 7,
                  onSelected: () => setState(() => _vehicleAge = 7),
                ),
                _AgeChip(
                  label: '10+ years',
                  isSelected: _vehicleAge == 12,
                  onSelected: () => setState(() => _vehicleAge = 12),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Start button
            PrimaryButton(
              text: l10n?.startInspection ?? 'Start Inspection',
              icon: Icons.play_arrow,
              onPressed: () {
                context.push(
                  '/inspection-checklist',
                  extra: {
                    'vehicleType': _selectedVehicleType,
                    'fuelType': _selectedFuelType,
                    'vehicleAge': _vehicleAge,
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Works Offline',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'You can complete the inspection even without internet connection.',
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
}

class _AgeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _AgeChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}
