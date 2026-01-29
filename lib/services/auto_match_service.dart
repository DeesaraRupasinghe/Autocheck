import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Service for auto-matching vehicles based on user preferences
/// Uses rule-based logic (extensible to AI later)
class AutoMatchService {
  /// Generate vehicle recommendations based on user preferences
  List<VehicleRecommendation> getRecommendations(VehiclePreferences prefs) {
    final recommendations = <VehicleRecommendation>[];

    // Score each vehicle type based on preferences
    for (final vehicleType in VehicleType.values) {
      final score = _calculateMatchScore(vehicleType, prefs);
      if (score > 30) {
        // Only include if reasonable match
        recommendations.add(_buildRecommendation(vehicleType, prefs, score));
      }
    }

    // Sort by match score descending
    recommendations.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return recommendations.take(3).toList(); // Return top 3
  }

  int _calculateMatchScore(VehicleType type, VehiclePreferences prefs) {
    int score = 50; // Base score

    // Family size scoring
    switch (type) {
      case VehicleType.hatchback:
        if (prefs.familySize <= 2) score += 20;
        if (prefs.familySize > 4) score -= 30;
        break;
      case VehicleType.sedan:
        if (prefs.familySize >= 2 && prefs.familySize <= 4) score += 20;
        if (prefs.familySize > 5) score -= 10;
        break;
      case VehicleType.suv:
        if (prefs.familySize >= 3) score += 15;
        break;
      case VehicleType.mpv:
        if (prefs.familySize >= 5) score += 30;
        if (prefs.familySize <= 2) score -= 20;
        break;
      case VehicleType.pickup:
        if (prefs.familySize <= 3) score += 10;
        break;
      case VehicleType.van:
        if (prefs.familySize >= 6) score += 25;
        if (prefs.familySize <= 3) score -= 25;
        break;
    }

    // Road condition scoring
    switch (prefs.roadCondition) {
      case RoadCondition.roughRoads:
        if (type == VehicleType.suv) score += 25;
        if (type == VehicleType.pickup) score += 20;
        if (type == VehicleType.hatchback) score -= 15;
        break;
      case RoadCondition.mixedRoads:
        if (type == VehicleType.suv) score += 10;
        if (type == VehicleType.sedan) score += 5;
        break;
      case RoadCondition.goodRoads:
        if (type == VehicleType.sedan) score += 10;
        if (type == VehicleType.hatchback) score += 15;
        break;
    }

    // Driving condition scoring
    switch (prefs.drivingCondition) {
      case DrivingCondition.cityOnly:
        if (type == VehicleType.hatchback) score += 25;
        if (type == VehicleType.sedan) score += 10;
        if (type == VehicleType.suv) score -= 10;
        break;
      case DrivingCondition.longDrives:
        if (type == VehicleType.sedan) score += 20;
        if (type == VehicleType.suv) score += 15;
        if (type == VehicleType.hatchback) score -= 10;
        break;
      case DrivingCondition.mixed:
        if (type == VehicleType.sedan) score += 10;
        if (type == VehicleType.suv) score += 10;
        break;
    }

    // Priority scoring
    switch (prefs.priority) {
      case VehiclePriority.fuelEconomy:
        if (type == VehicleType.hatchback) score += 25;
        if (type == VehicleType.suv) score -= 15;
        if (type == VehicleType.pickup) score -= 20;
        break;
      case VehiclePriority.comfort:
        if (type == VehicleType.sedan) score += 20;
        if (type == VehicleType.suv) score += 15;
        if (type == VehicleType.mpv) score += 10;
        break;
      case VehiclePriority.performance:
        if (type == VehicleType.sedan) score += 15;
        if (type == VehicleType.suv) score += 10;
        break;
      case VehiclePriority.safety:
        if (type == VehicleType.suv) score += 20;
        if (type == VehicleType.sedan) score += 10;
        break;
    }

    // Fuel preference scoring
    if (prefs.fuelPreference != null) {
      switch (prefs.fuelPreference!) {
        case FuelType.hybrid:
        case FuelType.electric:
          if (type == VehicleType.hatchback) score += 10;
          if (type == VehicleType.sedan) score += 15;
          break;
        case FuelType.diesel:
          if (type == VehicleType.suv) score += 10;
          if (type == VehicleType.pickup) score += 15;
          break;
        case FuelType.petrol:
          // Neutral for most
          break;
      }
    }

    return score.clamp(0, 100);
  }

  VehicleRecommendation _buildRecommendation(
    VehicleType type,
    VehiclePreferences prefs,
    int score,
  ) {
    return VehicleRecommendation(
      vehicleType: type,
      popularModels: _getPopularModels(type, prefs),
      pros: _getPros(type),
      cons: _getCons(type),
      fuelConsumption: _getFuelConsumption(type, prefs.fuelPreference),
      maintenanceCost: _getMaintenanceCost(type),
      commonIssues: _getCommonIssues(type),
      scamWarnings: _getScamWarnings(type),
      matchScore: score,
    );
  }

  List<String> _getPopularModels(VehicleType type, VehiclePreferences prefs) {
    // Popular models in Sri Lanka based on budget and type
    final budgetCategory = prefs.budgetMax < 3000000
        ? 'budget'
        : prefs.budgetMax < 8000000
            ? 'mid'
            : 'premium';

    switch (type) {
      case VehicleType.hatchback:
        return budgetCategory == 'budget'
            ? ['Suzuki Alto', 'Maruti 800', 'Daihatsu Mira']
            : budgetCategory == 'mid'
                ? ['Toyota Vitz', 'Honda Fit', 'Suzuki Swift']
                : ['Toyota Aqua', 'Honda Fit Hybrid', 'Mazda 2'];
      case VehicleType.sedan:
        return budgetCategory == 'budget'
            ? ['Toyota Corolla 121', 'Nissan Sunny', 'Honda Civic ES']
            : budgetCategory == 'mid'
                ? ['Toyota Axio', 'Honda Grace', 'Mazda 3']
                : ['Toyota Prius', 'Honda Accord', 'Toyota Camry'];
      case VehicleType.suv:
        return budgetCategory == 'budget'
            ? ['Suzuki Escudo', 'Daihatsu Terios', 'Honda CR-V (Old)']
            : budgetCategory == 'mid'
                ? ['Nissan X-Trail', 'Toyota RAV4', 'Honda CR-V']
                : ['Toyota Land Cruiser Prado', 'Mitsubishi Outlander', 'Toyota Fortuner'];
      case VehicleType.mpv:
        return budgetCategory == 'budget'
            ? ['Toyota Noah (Old)', 'Nissan Serena (Old)']
            : ['Toyota Noah', 'Toyota Voxy', 'Honda Stepwgn'];
      case VehicleType.pickup:
        return ['Toyota Hilux', 'Mitsubishi L200', 'Nissan Navara'];
      case VehicleType.van:
        return ['Toyota HiAce', 'Nissan Caravan', 'Toyota KDH'];
    }
  }

  List<String> _getPros(VehicleType type) {
    switch (type) {
      case VehicleType.hatchback:
        return [
          'Excellent fuel economy',
          'Easy to park in city',
          'Lower maintenance costs',
          'Affordable spare parts',
        ];
      case VehicleType.sedan:
        return [
          'Comfortable for long drives',
          'Good boot space',
          'Better highway stability',
          'Professional appearance',
        ];
      case VehicleType.suv:
        return [
          'High ground clearance',
          'Handles rough roads well',
          'Spacious interior',
          'Good for floods',
        ];
      case VehicleType.mpv:
        return [
          'Maximum seating capacity',
          'Flexible interior layout',
          'Great for large families',
          'Sliding doors for easy access',
        ];
      case VehicleType.pickup:
        return [
          'Excellent for carrying loads',
          'Very durable',
          'High resale value',
          'Good off-road capability',
        ];
      case VehicleType.van:
        return [
          'Maximum cargo space',
          'Ideal for business use',
          'Can seat many passengers',
          'Versatile configuration',
        ];
    }
  }

  List<String> _getCons(VehicleType type) {
    switch (type) {
      case VehicleType.hatchback:
        return [
          'Limited boot space',
          'Not ideal for long drives',
          'Less safety features',
          'Cramped for tall people',
        ];
      case VehicleType.sedan:
        return [
          'Higher fuel consumption than hatchbacks',
          'Harder to park',
          'Lower ground clearance',
          'More expensive parts',
        ];
      case VehicleType.suv:
        return [
          'Higher fuel consumption',
          'More expensive maintenance',
          'Harder to maneuver',
          'Higher initial cost',
        ];
      case VehicleType.mpv:
        return [
          'Poor fuel economy',
          'Difficult to park',
          'High maintenance costs',
          'Expensive spare parts',
        ];
      case VehicleType.pickup:
        return [
          'Very poor fuel economy',
          'Rough ride quality',
          'Not suitable for cities',
          'High running costs',
        ];
      case VehicleType.van:
        return [
          'Poor fuel economy',
          'Hard to drive',
          'Limited visibility',
          'High maintenance',
        ];
    }
  }

  String _getFuelConsumption(VehicleType type, FuelType? fuel) {
    final isHybrid = fuel == FuelType.hybrid;
    switch (type) {
      case VehicleType.hatchback:
        return isHybrid ? '20-25 km/L' : '15-20 km/L';
      case VehicleType.sedan:
        return isHybrid ? '18-23 km/L' : '12-16 km/L';
      case VehicleType.suv:
        return isHybrid ? '12-16 km/L' : '8-12 km/L';
      case VehicleType.mpv:
        return '8-12 km/L';
      case VehicleType.pickup:
        return '6-10 km/L';
      case VehicleType.van:
        return '6-9 km/L';
    }
  }

  String _getMaintenanceCost(VehicleType type) {
    switch (type) {
      case VehicleType.hatchback:
        return 'Low (Rs. 15,000-25,000 per service)';
      case VehicleType.sedan:
        return 'Medium (Rs. 20,000-40,000 per service)';
      case VehicleType.suv:
        return 'High (Rs. 35,000-60,000 per service)';
      case VehicleType.mpv:
        return 'High (Rs. 30,000-50,000 per service)';
      case VehicleType.pickup:
        return 'Medium-High (Rs. 25,000-50,000 per service)';
      case VehicleType.van:
        return 'High (Rs. 30,000-55,000 per service)';
    }
  }

  List<String> _getCommonIssues(VehicleType type) {
    switch (type) {
      case VehicleType.hatchback:
        return [
          'CVT gearbox problems in older models',
          'AC compressor failures',
          'Weak suspension components',
        ];
      case VehicleType.sedan:
        return [
          'Hybrid battery degradation',
          'Transmission issues in high-mileage cars',
          'Rust in older models',
        ];
      case VehicleType.suv:
        return [
          'Transfer case problems',
          'High tire wear',
          'Suspension wear from rough roads',
        ];
      case VehicleType.mpv:
        return [
          'Sliding door mechanism issues',
          'Air conditioning problems',
          'Engine mounts wear',
        ];
      case VehicleType.pickup:
        return [
          'Diesel injector problems',
          'Leaf spring failures',
          'Turbo issues in diesel engines',
        ];
      case VehicleType.van:
        return [
          'High mileage engine wear',
          'Turbo failures',
          'Transmission problems',
        ];
    }
  }

  List<String> _getScamWarnings(VehicleType type) {
    return [
      'Odometer tampering is common - verify service records',
      'Beware of accident-repaired vehicles with fresh paint',
      'Check for flood damage - look under carpets and seats',
      'Verify registration documents match the chassis number',
      'Don\'t trust sellers who refuse professional inspection',
    ];
  }
}
