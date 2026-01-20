import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Service for checking vehicles against blacklist/risk database
/// Currently uses mock data, designed to be API-ready
class BlacklistService {
  /// Mock database of flagged vehicles
  /// In production, this would connect to an API
  static final Map<String, BlacklistResult> _mockDatabase = {
    'CAR-1234': BlacklistResult(
      vehicleId: '1',
      registrationNumber: 'CAR-1234',
      hasIssues: true,
      flags: [BlacklistFlag.accident],
      checkedAt: DateTime.now(),
    ),
    'WP-AB-5678': BlacklistResult(
      vehicleId: '2',
      registrationNumber: 'WP-AB-5678',
      hasIssues: true,
      flags: [BlacklistFlag.flood, BlacklistFlag.tampered],
      checkedAt: DateTime.now(),
    ),
    'CHASSIS123456789': BlacklistResult(
      vehicleId: '3',
      chassisNumber: 'CHASSIS123456789',
      hasIssues: true,
      flags: [BlacklistFlag.stolen],
      checkedAt: DateTime.now(),
    ),
  };

  /// Check a vehicle by registration number
  Future<BlacklistResult> checkByRegistration(String registrationNumber) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final normalizedNumber = registrationNumber.toUpperCase().replaceAll(' ', '');

    // Check mock database
    for (final entry in _mockDatabase.entries) {
      if (entry.key.toUpperCase().replaceAll(' ', '') == normalizedNumber ||
          entry.value.registrationNumber?.toUpperCase().replaceAll(' ', '') ==
              normalizedNumber) {
        return entry.value;
      }
    }

    // No issues found
    return BlacklistResult(
      vehicleId: DateTime.now().millisecondsSinceEpoch.toString(),
      registrationNumber: registrationNumber,
      hasIssues: false,
      flags: [],
      checkedAt: DateTime.now(),
    );
  }

  /// Check a vehicle by chassis number
  Future<BlacklistResult> checkByChassis(String chassisNumber) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final normalizedChassis = chassisNumber.toUpperCase().replaceAll(' ', '');

    // Check mock database
    for (final entry in _mockDatabase.entries) {
      if (entry.key.toUpperCase() == normalizedChassis ||
          entry.value.chassisNumber?.toUpperCase() == normalizedChassis) {
        return entry.value;
      }
    }

    // No issues found
    return BlacklistResult(
      vehicleId: DateTime.now().millisecondsSinceEpoch.toString(),
      chassisNumber: chassisNumber,
      hasIssues: false,
      flags: [],
      checkedAt: DateTime.now(),
    );
  }

  /// Get description for a blacklist flag
  String getFlagDescription(BlacklistFlag flag) {
    switch (flag) {
      case BlacklistFlag.accident:
        return 'This vehicle has been reported in an accident. '
            'Request accident reports and have a professional inspect for hidden damage.';
      case BlacklistFlag.flood:
        return 'This vehicle may have flood damage. '
            'Check for water stains, rust, and electrical issues. Consider avoiding.';
      case BlacklistFlag.stolen:
        return 'WARNING: This vehicle may be stolen. '
            'Do not purchase. Contact authorities immediately.';
      case BlacklistFlag.tampered:
        return 'The odometer may have been tampered with. '
            'Verify service records and compare wear patterns.';
      case BlacklistFlag.legalIssue:
        return 'This vehicle has pending legal issues. '
            'Verify ownership documents carefully before purchase.';
    }
  }
}
