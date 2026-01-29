import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/common_widgets.dart';

/// Vehicle comparison screen
class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final List<_ComparisonVehicle> _vehicles = [];

  void _addVehicle() {
    if (_vehicles.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 vehicles can be compared')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _AddVehicleDialog(
        onAdd: (vehicle) {
          setState(() {
            _vehicles.add(vehicle);
          });
        },
      ),
    );
  }

  void _removeVehicle(int index) {
    setState(() {
      _vehicles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.compareVehicles ?? 'Compare Vehicles'),
      ),
      body: _vehicles.isEmpty
          ? _buildEmptyState(context, l10n)
          : _buildComparisonView(context, l10n),
      floatingActionButton: _vehicles.length < 3
          ? FloatingActionButton.extended(
              onPressed: _addVehicle,
              icon: const Icon(Icons.add),
              label: Text(l10n?.addVehicle ?? 'Add Vehicle'),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations? l10n) {
    return EmptyStateWidget(
      icon: Icons.compare_arrows,
      title: 'No vehicles to compare',
      description:
          'Add vehicles you\'re considering to compare them side by side',
      buttonText: l10n?.addVehicle ?? 'Add Vehicle',
      onButtonPressed: _addVehicle,
    );
  }

  Widget _buildComparisonView(BuildContext context, AppLocalizations? l10n) {
    // Find best vehicle by health score
    int? bestIndex;
    int bestScore = 0;
    for (int i = 0; i < _vehicles.length; i++) {
      if (_vehicles[i].healthScore > bestScore) {
        bestScore = _vehicles[i].healthScore;
        bestIndex = i;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle cards row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _vehicles.asMap().entries.map((entry) {
                final index = entry.key;
                final vehicle = entry.value;
                final isBest = index == bestIndex;

                return _VehicleCompareCard(
                  vehicle: vehicle,
                  isBest: isBest,
                  onRemove: () => _removeVehicle(index),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Comparison table
          if (_vehicles.length >= 2) _buildComparisonTable(context),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Comparison',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow(context, 'Health Score',
                _vehicles.map((v) => '${v.healthScore}/100').toList()),
            _buildComparisonRow(context, 'Year',
                _vehicles.map((v) => v.year?.toString() ?? '-').toList()),
            _buildComparisonRow(context, 'Mileage',
                _vehicles.map((v) => v.mileage ?? '-').toList()),
            _buildComparisonRow(context, 'Price',
                _vehicles.map((v) => v.price ?? '-').toList()),
            _buildComparisonRow(context, 'Fuel Type',
                _vehicles.map((v) => v.fuelType ?? '-').toList()),
            _buildComparisonRow(context, 'Engine Issues',
                _vehicles.map((v) => v.engineIssues ? '⚠️ Yes' : '✓ No').toList()),
            _buildComparisonRow(context, 'Body Issues',
                _vehicles.map((v) => v.bodyIssues ? '⚠️ Yes' : '✓ No').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
    BuildContext context,
    String label,
    List<String> values,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          ...values.map((value) {
            return Expanded(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _VehicleCompareCard extends StatelessWidget {
  final _ComparisonVehicle vehicle;
  final bool isBest;
  final VoidCallback onRemove;

  const _VehicleCompareCard({
    required this.vehicle,
    required this.isBest,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: isBest ? Colors.green.withValues(alpha: 0.1) : null,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (isBest)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '★ Best Choice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.directions_car,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicle.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  HealthScoreWidget(
                    score: vehicle.healthScore,
                    size: 80,
                    showLabel: false,
                  ),
                  const SizedBox(height: 8),
                  if (vehicle.price != null)
                    Text(
                      vehicle.price!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddVehicleDialog extends StatefulWidget {
  final Function(_ComparisonVehicle) onAdd;

  const _AddVehicleDialog({required this.onAdd});

  @override
  State<_AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<_AddVehicleDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();
  final _yearController = TextEditingController();
  int _healthScore = 70;
  String _fuelType = 'Petrol';
  bool _engineIssues = false;
  bool _bodyIssues = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Vehicle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Vehicle Name *',
                hintText: 'e.g., Toyota Axio 2018',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Year'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'Rs. 4.5M',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _mileageController,
              decoration: const InputDecoration(
                labelText: 'Mileage',
                hintText: '45,000 km',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Health Score: '),
                Expanded(
                  child: Slider(
                    value: _healthScore.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '$_healthScore',
                    onChanged: (value) {
                      setState(() => _healthScore = value.round());
                    },
                  ),
                ),
                Text('$_healthScore'),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _fuelType,
              decoration: const InputDecoration(labelText: 'Fuel Type'),
              items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _fuelType = value);
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Engine Issues'),
              value: _engineIssues,
              onChanged: (value) => setState(() => _engineIssues = value),
            ),
            SwitchListTile(
              title: const Text('Body Issues'),
              value: _bodyIssues,
              onChanged: (value) => setState(() => _bodyIssues = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;

            widget.onAdd(_ComparisonVehicle(
              name: _nameController.text,
              healthScore: _healthScore,
              year: int.tryParse(_yearController.text),
              price: _priceController.text.isNotEmpty
                  ? _priceController.text
                  : null,
              mileage: _mileageController.text.isNotEmpty
                  ? _mileageController.text
                  : null,
              fuelType: _fuelType,
              engineIssues: _engineIssues,
              bodyIssues: _bodyIssues,
            ));
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _ComparisonVehicle {
  final String name;
  final int healthScore;
  final int? year;
  final String? price;
  final String? mileage;
  final String? fuelType;
  final bool engineIssues;
  final bool bodyIssues;

  _ComparisonVehicle({
    required this.name,
    required this.healthScore,
    this.year,
    this.price,
    this.mileage,
    this.fuelType,
    this.engineIssues = false,
    this.bodyIssues = false,
  });
}
