import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/models.dart';

/// Auto Match screen for vehicle recommendations
class AutoMatchScreen extends ConsumerStatefulWidget {
  const AutoMatchScreen({super.key});

  @override
  ConsumerState<AutoMatchScreen> createState() => _AutoMatchScreenState();
}

class _AutoMatchScreenState extends ConsumerState<AutoMatchScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Questionnaire answers
  double _budgetMin = 1500000;
  double _budgetMax = 5000000;
  int _familySize = 4;
  DrivingCondition _drivingCondition = DrivingCondition.mixed;
  FuelType? _fuelPreference;
  RoadCondition _roadCondition = RoadCondition.mixedRoads;
  VehiclePriority _priority = VehiclePriority.fuelEconomy;

  List<VehicleRecommendation>? _recommendations;
  bool _isLoading = false;

  void _nextStep() {
    if (_currentStep < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _generateRecommendations();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  void _generateRecommendations() {
    setState(() => _isLoading = true);

    final prefs = VehiclePreferences(
      budgetMin: _budgetMin,
      budgetMax: _budgetMax,
      familySize: _familySize,
      drivingCondition: _drivingCondition,
      fuelPreference: _fuelPreference,
      roadCondition: _roadCondition,
      priority: _priority,
    );

    final service = ref.read(autoMatchServiceProvider);
    final results = service.getRecommendations(prefs);

    setState(() {
      _recommendations = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Show results if available
    if (_recommendations != null) {
      return _buildResultsScreen(context, l10n);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.autoMatch ?? 'Auto Match'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 6,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),

          // Question pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentStep = index);
              },
              children: [
                _buildBudgetQuestion(context, l10n),
                _buildFamilySizeQuestion(context, l10n),
                _buildDrivingConditionQuestion(context, l10n),
                _buildFuelPreferenceQuestion(context, l10n),
                _buildRoadConditionQuestion(context, l10n),
                _buildPriorityQuestion(context, l10n),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(
              text: _currentStep < 5
                  ? (l10n?.next ?? 'Next')
                  : (l10n?.recommendations ?? 'Get Recommendations'),
              onPressed: _nextStep,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetQuestion(BuildContext context, AppLocalizations? l10n) {
    return _QuestionPage(
      icon: Icons.account_balance_wallet,
      title: l10n?.budget ?? 'What is your budget?',
      subtitle: 'Select your price range in Sri Lankan Rupees',
      child: Column(
        children: [
          RangeSlider(
            values: RangeValues(_budgetMin, _budgetMax),
            min: 500000,
            max: 20000000,
            divisions: 39,
            labels: RangeLabels(
              'Rs. ${(_budgetMin / 100000).toStringAsFixed(1)}L',
              'Rs. ${(_budgetMax / 100000).toStringAsFixed(1)}L',
            ),
            onChanged: (values) {
              setState(() {
                _budgetMin = values.start;
                _budgetMax = values.end;
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Rs. ${(_budgetMin / 100000).toStringAsFixed(1)} Lakhs - Rs. ${(_budgetMax / 100000).toStringAsFixed(1)} Lakhs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilySizeQuestion(
      BuildContext context, AppLocalizations? l10n) {
    return _QuestionPage(
      icon: Icons.family_restroom,
      title: l10n?.familySize ?? 'How many people in your family?',
      subtitle: 'Include regular passengers',
      child: Column(
        children: [
          Slider(
            value: _familySize.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            label: '$_familySize',
            onChanged: (value) {
              setState(() => _familySize = value.round());
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _familySize,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_familySize ${_familySize == 1 ? 'person' : 'people'}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDrivingConditionQuestion(
      BuildContext context, AppLocalizations? l10n) {
    return _QuestionPage(
      icon: Icons.route,
      title: l10n?.drivingConditions ?? 'How do you usually drive?',
      subtitle: 'Select your primary driving pattern',
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.location_city,
            title: 'Mostly City Driving',
            description: 'Short trips, traffic, parking in tight spaces',
            isSelected: _drivingCondition == DrivingCondition.cityOnly,
            onTap: () =>
                setState(() => _drivingCondition = DrivingCondition.cityOnly),
          ),
          _OptionTile(
            icon: Icons.add_road,
            title: 'Long Distance Drives',
            description: 'Highway trips, interstate travel',
            isSelected: _drivingCondition == DrivingCondition.longDrives,
            onTap: () =>
                setState(() => _drivingCondition = DrivingCondition.longDrives),
          ),
          _OptionTile(
            icon: Icons.sync_alt,
            title: 'Mixed - Both',
            description: 'City commute and occasional long trips',
            isSelected: _drivingCondition == DrivingCondition.mixed,
            onTap: () =>
                setState(() => _drivingCondition = DrivingCondition.mixed),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelPreferenceQuestion(
      BuildContext context, AppLocalizations? l10n) {
    return _QuestionPage(
      icon: Icons.local_gas_station,
      title: l10n?.fuelPreference ?? 'Fuel type preference?',
      subtitle: 'Select your preferred fuel type',
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.local_gas_station,
            title: 'Petrol',
            description: 'Smooth, widely available',
            isSelected: _fuelPreference == FuelType.petrol,
            onTap: () => setState(() => _fuelPreference = FuelType.petrol),
          ),
          _OptionTile(
            icon: Icons.oil_barrel,
            title: 'Diesel',
            description: 'Fuel efficient, more torque',
            isSelected: _fuelPreference == FuelType.diesel,
            onTap: () => setState(() => _fuelPreference = FuelType.diesel),
          ),
          _OptionTile(
            icon: Icons.eco,
            title: 'Hybrid',
            description: 'Best fuel economy, eco-friendly',
            isSelected: _fuelPreference == FuelType.hybrid,
            onTap: () => setState(() => _fuelPreference = FuelType.hybrid),
          ),
          _OptionTile(
            icon: Icons.help_outline,
            title: 'No Preference',
            description: 'Open to suggestions',
            isSelected: _fuelPreference == null,
            onTap: () => setState(() => _fuelPreference = null),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadConditionQuestion(
      BuildContext context, AppLocalizations? l10n) {
    return _QuestionPage(
      icon: Icons.terrain,
      title: 'What roads do you drive on?',
      subtitle: 'Consider roads in your area',
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.linear_scale,
            title: 'Good Roads',
            description: 'Smooth city roads, well-maintained highways',
            isSelected: _roadCondition == RoadCondition.goodRoads,
            onTap: () =>
                setState(() => _roadCondition = RoadCondition.goodRoads),
          ),
          _OptionTile(
            icon: Icons.waves,
            title: 'Mixed Roads',
            description: 'Some rough patches, village roads',
            isSelected: _roadCondition == RoadCondition.mixedRoads,
            onTap: () =>
                setState(() => _roadCondition = RoadCondition.mixedRoads),
          ),
          _OptionTile(
            icon: Icons.landscape,
            title: 'Rough Roads',
            description: 'Unpaved roads, hilly areas, floods',
            isSelected: _roadCondition == RoadCondition.roughRoads,
            onTap: () =>
                setState(() => _roadCondition = RoadCondition.roughRoads),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityQuestion(BuildContext context, AppLocalizations? l10n) {
    return _QuestionPage(
      icon: Icons.stars,
      title: l10n?.priority ?? 'What matters most to you?',
      subtitle: 'Select your top priority',
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.local_gas_station,
            title: 'Fuel Economy',
            description: 'Low running costs, maximum mileage',
            isSelected: _priority == VehiclePriority.fuelEconomy,
            onTap: () =>
                setState(() => _priority = VehiclePriority.fuelEconomy),
          ),
          _OptionTile(
            icon: Icons.airline_seat_recline_extra,
            title: 'Comfort',
            description: 'Smooth ride, spacious interior',
            isSelected: _priority == VehiclePriority.comfort,
            onTap: () => setState(() => _priority = VehiclePriority.comfort),
          ),
          _OptionTile(
            icon: Icons.speed,
            title: 'Performance',
            description: 'Power, handling, driving experience',
            isSelected: _priority == VehiclePriority.performance,
            onTap: () =>
                setState(() => _priority = VehiclePriority.performance),
          ),
          _OptionTile(
            icon: Icons.security,
            title: 'Safety',
            description: 'Safety features, reliability',
            isSelected: _priority == VehiclePriority.safety,
            onTap: () => setState(() => _priority = VehiclePriority.safety),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen(BuildContext context, AppLocalizations? l10n) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.recommendations ?? 'Recommendations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => _recommendations = null);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _recommendations!.length,
        itemBuilder: (context, index) {
          final rec = _recommendations![index];
          return _RecommendationCard(
            recommendation: rec,
            rank: index + 1,
          );
        },
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _QuestionPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final VehicleRecommendation recommendation;
  final int rank;

  const _RecommendationCard({
    required this.recommendation,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: rank == 1
                ? Colors.amber.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: rank == 1
                ? const Icon(Icons.star, color: Colors.amber)
                : Text(
                    '#$rank',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
          ),
        ),
        title: Text(
          recommendation.vehicleType.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${recommendation.matchScore}% match',
          style: TextStyle(
            color: recommendation.matchScore >= 70
                ? Colors.green
                : recommendation.matchScore >= 50
                    ? Colors.orange
                    : Colors.grey,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Popular models
                Text(
                  'Popular Models in Sri Lanka:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recommendation.popularModels.map((model) {
                    return Chip(label: Text(model));
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Pros
                _buildSection(context, 'Pros', recommendation.pros, Icons.check_circle, Colors.green),

                const SizedBox(height: 12),

                // Cons
                _buildSection(context, 'Cons', recommendation.cons, Icons.warning, Colors.orange),

                const SizedBox(height: 16),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_gas_station,
                        label: 'Fuel Economy',
                        value: recommendation.fuelConsumption,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.build,
                        label: 'Maintenance',
                        value: recommendation.maintenanceCost,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Common issues
                _buildSection(context, 'Common Issues', recommendation.commonIssues, Icons.error_outline, Colors.red),

                const SizedBox(height: 12),

                // Scam warnings
                Text(
                  'Scam Warnings:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...recommendation.scamWarnings.map((warning) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            warning,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(item)),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
