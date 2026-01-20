import 'package:equatable/equatable.dart';
import '../core/constants/app_constants.dart';

/// User model for authentication and profile
class UserModel extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final UserRole role;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.guest() {
    return UserModel(
      id: 'guest',
      role: UserRole.normalUser,
      createdAt: DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: UserRole.values[json['role'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, email, phoneNumber, role, createdAt];
}

/// Vehicle model for inspections and comparisons
class VehicleModel extends Equatable {
  final String id;
  final String? registrationNumber;
  final String? chassisNumber;
  final String? make;
  final String? model;
  final int? year;
  final VehicleType? vehicleType;
  final FuelType? fuelType;
  final int? mileage;
  final String? color;
  final double? askingPrice;
  final String? notes;
  final DateTime createdAt;

  const VehicleModel({
    required this.id,
    this.registrationNumber,
    this.chassisNumber,
    this.make,
    this.model,
    this.year,
    this.vehicleType,
    this.fuelType,
    this.mileage,
    this.color,
    this.askingPrice,
    this.notes,
    required this.createdAt,
  });

  String get displayName {
    if (make != null && model != null) {
      return '$make $model ${year ?? ''}';
    }
    if (registrationNumber != null) {
      return registrationNumber!;
    }
    return 'Unknown Vehicle';
  }

  VehicleModel copyWith({
    String? id,
    String? registrationNumber,
    String? chassisNumber,
    String? make,
    String? model,
    int? year,
    VehicleType? vehicleType,
    FuelType? fuelType,
    int? mileage,
    String? color,
    double? askingPrice,
    String? notes,
    DateTime? createdAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      vehicleType: vehicleType ?? this.vehicleType,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
      color: color ?? this.color,
      askingPrice: askingPrice ?? this.askingPrice,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'chassisNumber': chassisNumber,
      'make': make,
      'model': model,
      'year': year,
      'vehicleType': vehicleType?.index,
      'fuelType': fuelType?.index,
      'mileage': mileage,
      'color': color,
      'askingPrice': askingPrice,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      registrationNumber: json['registrationNumber'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      make: json['make'] as String?,
      model: json['model'] as String?,
      year: json['year'] as int?,
      vehicleType: json['vehicleType'] != null
          ? VehicleType.values[json['vehicleType'] as int]
          : null,
      fuelType: json['fuelType'] != null
          ? FuelType.values[json['fuelType'] as int]
          : null,
      mileage: json['mileage'] as int?,
      color: json['color'] as String?,
      askingPrice: (json['askingPrice'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        registrationNumber,
        chassisNumber,
        make,
        model,
        year,
        vehicleType,
        fuelType,
        mileage,
        color,
        askingPrice,
        notes,
        createdAt
      ];
}

/// Inspection checklist item
class InspectionItem extends Equatable {
  final String id;
  final String category;
  final String title;
  final String description;
  final String? helpText;
  final int riskWeight;
  final InspectionAnswer? answer;

  const InspectionItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.helpText,
    required this.riskWeight,
    this.answer,
  });

  InspectionItem copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    String? helpText,
    int? riskWeight,
    InspectionAnswer? answer,
  }) {
    return InspectionItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      helpText: helpText ?? this.helpText,
      riskWeight: riskWeight ?? this.riskWeight,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'helpText': helpText,
      'riskWeight': riskWeight,
      'answer': answer?.index,
    };
  }

  factory InspectionItem.fromJson(Map<String, dynamic> json) {
    return InspectionItem(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      helpText: json['helpText'] as String?,
      riskWeight: json['riskWeight'] as int,
      answer: json['answer'] != null
          ? InspectionAnswer.values[json['answer'] as int]
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [id, category, title, description, helpText, riskWeight, answer];
}

/// Possible answers for inspection items
enum InspectionAnswer {
  yes,
  no,
  notSure,
}

/// Complete inspection result
class InspectionResult extends Equatable {
  final String id;
  final VehicleModel vehicle;
  final List<InspectionItem> items;
  final int healthScore;
  final RiskLevel riskLevel;
  final String recommendation;
  final DateTime inspectedAt;
  final VibrationTestResult? vibrationTest;

  const InspectionResult({
    required this.id,
    required this.vehicle,
    required this.items,
    required this.healthScore,
    required this.riskLevel,
    required this.recommendation,
    required this.inspectedAt,
    this.vibrationTest,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle': vehicle.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'healthScore': healthScore,
      'riskLevel': riskLevel.index,
      'recommendation': recommendation,
      'inspectedAt': inspectedAt.toIso8601String(),
      'vibrationTest': vibrationTest?.toJson(),
    };
  }

  factory InspectionResult.fromJson(Map<String, dynamic> json) {
    return InspectionResult(
      id: json['id'] as String,
      vehicle: VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>),
      items: (json['items'] as List)
          .map((e) => InspectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      healthScore: json['healthScore'] as int,
      riskLevel: RiskLevel.values[json['riskLevel'] as int],
      recommendation: json['recommendation'] as String,
      inspectedAt: DateTime.parse(json['inspectedAt'] as String),
      vibrationTest: json['vibrationTest'] != null
          ? VibrationTestResult.fromJson(
              json['vibrationTest'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        vehicle,
        items,
        healthScore,
        riskLevel,
        recommendation,
        inspectedAt,
        vibrationTest
      ];
}

/// Vibration test result from phone sensors
class VibrationTestResult extends Equatable {
  final double averageAcceleration;
  final double maxAcceleration;
  final double stability;
  final bool passed;
  final DateTime testedAt;

  const VibrationTestResult({
    required this.averageAcceleration,
    required this.maxAcceleration,
    required this.stability,
    required this.passed,
    required this.testedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'averageAcceleration': averageAcceleration,
      'maxAcceleration': maxAcceleration,
      'stability': stability,
      'passed': passed,
      'testedAt': testedAt.toIso8601String(),
    };
  }

  factory VibrationTestResult.fromJson(Map<String, dynamic> json) {
    return VibrationTestResult(
      averageAcceleration: (json['averageAcceleration'] as num).toDouble(),
      maxAcceleration: (json['maxAcceleration'] as num).toDouble(),
      stability: (json['stability'] as num).toDouble(),
      passed: json['passed'] as bool,
      testedAt: DateTime.parse(json['testedAt'] as String),
    );
  }

  @override
  List<Object?> get props =>
      [averageAcceleration, maxAcceleration, stability, passed, testedAt];
}

/// Blacklist check result
class BlacklistResult extends Equatable {
  final String vehicleId;
  final String? registrationNumber;
  final String? chassisNumber;
  final bool hasIssues;
  final List<BlacklistFlag> flags;
  final DateTime checkedAt;

  const BlacklistResult({
    required this.vehicleId,
    this.registrationNumber,
    this.chassisNumber,
    required this.hasIssues,
    required this.flags,
    required this.checkedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'registrationNumber': registrationNumber,
      'chassisNumber': chassisNumber,
      'hasIssues': hasIssues,
      'flags': flags.map((e) => e.index).toList(),
      'checkedAt': checkedAt.toIso8601String(),
    };
  }

  factory BlacklistResult.fromJson(Map<String, dynamic> json) {
    return BlacklistResult(
      vehicleId: json['vehicleId'] as String,
      registrationNumber: json['registrationNumber'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      hasIssues: json['hasIssues'] as bool,
      flags: (json['flags'] as List)
          .map((e) => BlacklistFlag.values[e as int])
          .toList(),
      checkedAt: DateTime.parse(json['checkedAt'] as String),
    );
  }

  @override
  List<Object?> get props =>
      [vehicleId, registrationNumber, chassisNumber, hasIssues, flags, checkedAt];
}

/// Inspection service provider
class InspectionService extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final double priceFrom;
  final List<String> services;
  final bool isVerified;

  const InspectionService({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.priceFrom,
    required this.services,
    required this.isVerified,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceFrom': priceFrom,
      'services': services,
      'isVerified': isVerified,
    };
  }

  factory InspectionService.fromJson(Map<String, dynamic> json) {
    return InspectionService(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      priceFrom: (json['priceFrom'] as num).toDouble(),
      services: List<String>.from(json['services'] as List),
      isVerified: json['isVerified'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phoneNumber,
        latitude,
        longitude,
        rating,
        reviewCount,
        priceFrom,
        services,
        isVerified
      ];
}

/// Vehicle recommendation from Auto Match
class VehicleRecommendation extends Equatable {
  final VehicleType vehicleType;
  final List<String> popularModels;
  final List<String> pros;
  final List<String> cons;
  final String fuelConsumption;
  final String maintenanceCost;
  final List<String> commonIssues;
  final List<String> scamWarnings;
  final int matchScore;

  const VehicleRecommendation({
    required this.vehicleType,
    required this.popularModels,
    required this.pros,
    required this.cons,
    required this.fuelConsumption,
    required this.maintenanceCost,
    required this.commonIssues,
    required this.scamWarnings,
    required this.matchScore,
  });

  @override
  List<Object?> get props => [
        vehicleType,
        popularModels,
        pros,
        cons,
        fuelConsumption,
        maintenanceCost,
        commonIssues,
        scamWarnings,
        matchScore
      ];
}

/// Auto Match questionnaire preferences
class VehiclePreferences extends Equatable {
  final double budgetMin;
  final double budgetMax;
  final int familySize;
  final DrivingCondition drivingCondition;
  final FuelType? fuelPreference;
  final RoadCondition roadCondition;
  final VehiclePriority priority;

  const VehiclePreferences({
    required this.budgetMin,
    required this.budgetMax,
    required this.familySize,
    required this.drivingCondition,
    this.fuelPreference,
    required this.roadCondition,
    required this.priority,
  });

  @override
  List<Object?> get props => [
        budgetMin,
        budgetMax,
        familySize,
        drivingCondition,
        fuelPreference,
        roadCondition,
        priority
      ];
}

enum DrivingCondition {
  cityOnly,
  longDrives,
  mixed,
}

enum RoadCondition {
  goodRoads,
  mixedRoads,
  roughRoads,
}

enum VehiclePriority {
  fuelEconomy,
  comfort,
  performance,
  safety,
}
