/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'AutoCheck';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Smart Vehicle Buying Assistant';

  // Storage Keys
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
  static const String localeKey = 'app_locale';
  static const String themeKey = 'app_theme';
  static const String savedVehiclesKey = 'saved_vehicles';
  static const String inspectionHistoryKey = 'inspection_history';

  // Health Score Thresholds
  static const int healthScoreGreenMin = 70;
  static const int healthScoreYellowMin = 40;
  static const int healthScoreMax = 100;

  // API Endpoints (placeholder for future)
  static const String baseApiUrl = 'https://api.autocheck.lk';
  static const String blacklistEndpoint = '/blacklist';
  static const String inspectorsEndpoint = '/inspectors';

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Sensor Settings
  static const int sensorSamplingPeriod = 100; // milliseconds
  static const int vibrationTestDuration = 10; // seconds
}

/// User role types
enum UserRole {
  normalUser,
  inspectionService,
}

/// Supported locales
enum AppLocale {
  english('en', 'English'),
  sinhala('si', 'සිංහල'),
  tamil('ta', 'தமிழ்');

  final String code;
  final String displayName;
  const AppLocale(this.code, this.displayName);
}

/// Vehicle types for recommendations
enum VehicleType {
  hatchback('Hatchback', 'Small, fuel-efficient, easy to park'),
  sedan('Sedan', 'Comfortable, spacious, good for families'),
  suv('SUV', 'Versatile, powerful, off-road capable'),
  mpv('MPV', 'Maximum space, ideal for large families'),
  pickup('Pickup', 'Utility vehicle, good for carrying loads'),
  van('Van', 'Commercial or large family transport');

  final String displayName;
  final String description;
  const VehicleType(this.displayName, this.description);
}

/// Fuel types
enum FuelType {
  petrol('Petrol'),
  diesel('Diesel'),
  hybrid('Hybrid'),
  electric('Electric');

  final String displayName;
  const FuelType(this.displayName);
}

/// Risk levels for health scoring
enum RiskLevel {
  safe('Safe', 'This vehicle appears to be in good condition'),
  mediumRisk('Medium Risk', 'Some concerns found - professional inspection recommended'),
  highRisk('High Risk', 'Significant issues detected - consider avoiding this vehicle');

  final String displayName;
  final String description;
  const RiskLevel(this.displayName, this.description);
}

/// Blacklist flag types
enum BlacklistFlag {
  accident('Accident Reported'),
  flood('Flood Damaged'),
  stolen('Stolen Vehicle'),
  tampered('Odometer Tampered'),
  legalIssue('Legal Issues');

  final String displayName;
  const BlacklistFlag(this.displayName);
}
