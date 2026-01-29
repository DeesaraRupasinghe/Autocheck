import 'package:flutter_test/flutter_test.dart';
import 'package:autocheck/core/constants/app_constants.dart';
import 'package:autocheck/models/models.dart';
import 'package:autocheck/services/health_score_service.dart';
import 'package:autocheck/services/auto_match_service.dart';

void main() {
  group('HealthScoreService', () {
    late HealthScoreService service;

    setUp(() {
      service = HealthScoreService();
    });

    test('calculates perfect score when all items are yes', () {
      final items = [
        const InspectionItem(
          id: '1',
          category: 'Test',
          title: 'Test Item 1',
          description: 'Description',
          riskWeight: 10,
          answer: InspectionAnswer.yes,
        ),
        const InspectionItem(
          id: '2',
          category: 'Test',
          title: 'Test Item 2',
          description: 'Description',
          riskWeight: 10,
          answer: InspectionAnswer.yes,
        ),
      ];

      final result = service.calculateHealthScore(items);
      expect(result.score, 100);
      expect(result.riskLevel, RiskLevel.safe);
    });

    test('calculates low score when all items are no', () {
      final items = [
        const InspectionItem(
          id: '1',
          category: 'Test',
          title: 'Test Item 1',
          description: 'Description',
          riskWeight: 10,
          answer: InspectionAnswer.no,
        ),
        const InspectionItem(
          id: '2',
          category: 'Test',
          title: 'Test Item 2',
          description: 'Description',
          riskWeight: 10,
          answer: InspectionAnswer.no,
        ),
      ];

      final result = service.calculateHealthScore(items);
      expect(result.score, 0);
      expect(result.riskLevel, RiskLevel.highRisk);
    });

    test('calculates partial score for not sure answers', () {
      final items = [
        const InspectionItem(
          id: '1',
          category: 'Test',
          title: 'Test Item 1',
          description: 'Description',
          riskWeight: 10,
          answer: InspectionAnswer.notSure,
        ),
      ];

      final result = service.calculateHealthScore(items);
      expect(result.score, 50);
      expect(result.riskLevel, RiskLevel.mediumRisk);
    });

    test('identifies critical issues correctly', () {
      final items = [
        const InspectionItem(
          id: '1',
          category: 'Test',
          title: 'Critical Issue',
          description: 'Description',
          riskWeight: 10,
          answer: InspectionAnswer.no,
        ),
        const InspectionItem(
          id: '2',
          category: 'Test',
          title: 'Minor Issue',
          description: 'Description',
          riskWeight: 3,
          answer: InspectionAnswer.no,
        ),
      ];

      final criticalItems = service.getCriticalIssues(items);
      expect(criticalItems.length, 1);
      expect(criticalItems.first.title, 'Critical Issue');
    });
  });

  group('AutoMatchService', () {
    late AutoMatchService service;

    setUp(() {
      service = AutoMatchService();
    });

    test('returns recommendations based on preferences', () {
      const prefs = VehiclePreferences(
        budgetMin: 2000000,
        budgetMax: 5000000,
        familySize: 4,
        drivingCondition: DrivingCondition.mixed,
        roadCondition: RoadCondition.mixedRoads,
        priority: VehiclePriority.fuelEconomy,
      );

      final recommendations = service.getRecommendations(prefs);
      
      expect(recommendations, isNotEmpty);
      expect(recommendations.length, lessThanOrEqualTo(3));
      expect(recommendations.first.matchScore, greaterThan(0));
    });

    test('recommends SUV for rough roads and large family', () {
      const prefs = VehiclePreferences(
        budgetMin: 5000000,
        budgetMax: 15000000,
        familySize: 6,
        drivingCondition: DrivingCondition.longDrives,
        roadCondition: RoadCondition.roughRoads,
        priority: VehiclePriority.safety,
      );

      final recommendations = service.getRecommendations(prefs);
      
      expect(recommendations, isNotEmpty);
      // SUV should be among top recommendations for this profile
      final hasSubOrMpv = recommendations.any((r) =>
          r.vehicleType == VehicleType.suv ||
          r.vehicleType == VehicleType.mpv);
      expect(hasSubOrMpv, isTrue);
    });

    test('recommends hatchback for city driving and small family', () {
      const prefs = VehiclePreferences(
        budgetMin: 1000000,
        budgetMax: 3000000,
        familySize: 2,
        drivingCondition: DrivingCondition.cityOnly,
        roadCondition: RoadCondition.goodRoads,
        priority: VehiclePriority.fuelEconomy,
      );

      final recommendations = service.getRecommendations(prefs);
      
      expect(recommendations, isNotEmpty);
      // Hatchback should be the top recommendation for this profile
      expect(recommendations.first.vehicleType, VehicleType.hatchback);
    });
  });

  group('AppConstants', () {
    test('health score thresholds are correct', () {
      expect(AppConstants.healthScoreGreenMin, 70);
      expect(AppConstants.healthScoreYellowMin, 40);
      expect(AppConstants.healthScoreMax, 100);
    });

    test('app name is AutoCheck', () {
      expect(AppConstants.appName, 'AutoCheck');
    });
  });

  group('Models', () {
    test('VehicleModel serialization works', () {
      final vehicle = VehicleModel(
        id: 'test-id',
        registrationNumber: 'CAR-1234',
        make: 'Toyota',
        model: 'Axio',
        year: 2020,
        createdAt: DateTime(2024, 1, 1),
      );

      final json = vehicle.toJson();
      final restored = VehicleModel.fromJson(json);

      expect(restored.id, vehicle.id);
      expect(restored.registrationNumber, vehicle.registrationNumber);
      expect(restored.make, vehicle.make);
      expect(restored.model, vehicle.model);
      expect(restored.year, vehicle.year);
    });

    test('InspectionItem serialization works', () {
      const item = InspectionItem(
        id: 'test-id',
        category: 'Engine',
        title: 'Oil Level',
        description: 'Check oil level',
        riskWeight: 8,
        answer: InspectionAnswer.yes,
      );

      final json = item.toJson();
      final restored = InspectionItem.fromJson(json);

      expect(restored.id, item.id);
      expect(restored.category, item.category);
      expect(restored.title, item.title);
      expect(restored.answer, item.answer);
    });
  });
}
