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

/// Enhanced user model for Firebase authentication
class FirestoreUser extends Equatable {
  final String uid;
  final String? displayName;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final UserRole role;
  final String preferredLanguage;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const FirestoreUser({
    required this.uid,
    this.displayName,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.role,
    this.preferredLanguage = 'en',
    this.isEmailVerified = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role.name,
      'preferredLanguage': preferredLanguage,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory FirestoreUser.fromFirestore(Map<String, dynamic> data) {
    return FirestoreUser(
      uid: data['uid'] as String,
      displayName: data['displayName'] as String?,
      email: data['email'] as String,
      phoneNumber: data['phoneNumber'] as String?,
      photoUrl: data['photoUrl'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == data['role'],
        orElse: () => UserRole.normalUser,
      ),
      preferredLanguage: data['preferredLanguage'] as String? ?? 'en',
      isEmailVerified: data['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(data['createdAt'] as String),
      lastLoginAt: data['lastLoginAt'] != null
          ? DateTime.parse(data['lastLoginAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        phoneNumber,
        photoUrl,
        role,
        preferredLanguage,
        isEmailVerified,
        createdAt,
        lastLoginAt,
      ];
}

/// Inspector profile model for Firestore
class InspectorProfile extends Equatable {
  final String id;
  final String userId;
  final String businessName;
  final String ownerName;
  final String email;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;
  final double coverageRadiusKm;
  final List<String> inspectionTypes;
  final double priceFrom;
  final double? priceTo;
  final int yearsOfExperience;
  final List<String>? certifications;
  final List<String> availableDays;
  final String? openTime;
  final String? closeTime;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final InspectorStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const InspectorProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.coverageRadiusKm = 10.0,
    required this.inspectionTypes,
    required this.priceFrom,
    this.priceTo,
    required this.yearsOfExperience,
    this.certifications,
    required this.availableDays,
    this.openTime,
    this.closeTime,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.status = InspectorStatus.pendingVerification,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'ownerName': ownerName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'coverageRadiusKm': coverageRadiusKm,
      'inspectionTypes': inspectionTypes,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'yearsOfExperience': yearsOfExperience,
      'certifications': certifications,
      'availableDays': availableDays,
      'openTime': openTime,
      'closeTime': closeTime,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory InspectorProfile.fromFirestore(Map<String, dynamic> data) {
    return InspectorProfile(
      id: data['id'] as String,
      userId: data['userId'] as String,
      businessName: data['businessName'] as String,
      ownerName: data['ownerName'] as String,
      email: data['email'] as String,
      phoneNumber: data['phoneNumber'] as String,
      address: data['address'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      coverageRadiusKm: (data['coverageRadiusKm'] as num?)?.toDouble() ?? 10.0,
      inspectionTypes: List<String>.from(data['inspectionTypes'] as List),
      priceFrom: (data['priceFrom'] as num).toDouble(),
      priceTo: (data['priceTo'] as num?)?.toDouble(),
      yearsOfExperience: data['yearsOfExperience'] as int,
      certifications: data['certifications'] != null
          ? List<String>.from(data['certifications'] as List)
          : null,
      availableDays: List<String>.from(data['availableDays'] as List),
      openTime: data['openTime'] as String?,
      closeTime: data['closeTime'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] as int? ?? 0,
      isVerified: data['isVerified'] as bool? ?? false,
      status: InspectorStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => InspectorStatus.pendingVerification,
      ),
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : null,
    );
  }

  InspectorProfile copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? ownerName,
    String? email,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    double? coverageRadiusKm,
    List<String>? inspectionTypes,
    double? priceFrom,
    double? priceTo,
    int? yearsOfExperience,
    List<String>? certifications,
    List<String>? availableDays,
    String? openTime,
    String? closeTime,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    InspectorStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InspectorProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      coverageRadiusKm: coverageRadiusKm ?? this.coverageRadiusKm,
      inspectionTypes: inspectionTypes ?? this.inspectionTypes,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      certifications: certifications ?? this.certifications,
      availableDays: availableDays ?? this.availableDays,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        businessName,
        ownerName,
        email,
        phoneNumber,
        address,
        latitude,
        longitude,
        coverageRadiusKm,
        inspectionTypes,
        priceFrom,
        priceTo,
        yearsOfExperience,
        certifications,
        availableDays,
        openTime,
        closeTime,
        rating,
        reviewCount,
        isVerified,
        status,
        createdAt,
        updatedAt,
      ];
}

enum InspectorStatus {
  pendingVerification,
  active,
  suspended,
  rejected,
}

/// Inspection request model
class InspectionRequest extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String inspectorId;
  final String inspectorName;
  final String? vehicleInfo;
  final String? location;
  final DateTime requestedDate;
  final String? requestedTime;
  final String? notes;
  final InspectionRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const InspectionRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.inspectorId,
    required this.inspectorName,
    this.vehicleInfo,
    this.location,
    required this.requestedDate,
    this.requestedTime,
    this.notes,
    this.status = InspectionRequestStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'inspectorId': inspectorId,
      'inspectorName': inspectorName,
      'vehicleInfo': vehicleInfo,
      'location': location,
      'requestedDate': requestedDate.toIso8601String(),
      'requestedTime': requestedTime,
      'notes': notes,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory InspectionRequest.fromFirestore(Map<String, dynamic> data) {
    return InspectionRequest(
      id: data['id'] as String,
      customerId: data['customerId'] as String,
      customerName: data['customerName'] as String,
      customerPhone: data['customerPhone'] as String,
      inspectorId: data['inspectorId'] as String,
      inspectorName: data['inspectorName'] as String,
      vehicleInfo: data['vehicleInfo'] as String?,
      location: data['location'] as String?,
      requestedDate: DateTime.parse(data['requestedDate'] as String),
      requestedTime: data['requestedTime'] as String?,
      notes: data['notes'] as String?,
      status: InspectionRequestStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => InspectionRequestStatus.pending,
      ),
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        customerPhone,
        inspectorId,
        inspectorName,
        vehicleInfo,
        location,
        requestedDate,
        requestedTime,
        notes,
        status,
        createdAt,
        updatedAt,
      ];
}

enum InspectionRequestStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled,
}

/// Review model for inspectors
class Review extends Equatable {
  final String id;
  final String inspectorId;
  final String customerId;
  final String customerName;
  final String? customerPhotoUrl;
  final double rating;
  final String? comment;
  final String? inspectionRequestId;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.inspectorId,
    required this.customerId,
    required this.customerName,
    this.customerPhotoUrl,
    required this.rating,
    this.comment,
    this.inspectionRequestId,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'inspectorId': inspectorId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhotoUrl': customerPhotoUrl,
      'rating': rating,
      'comment': comment,
      'inspectionRequestId': inspectionRequestId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromFirestore(Map<String, dynamic> data) {
    return Review(
      id: data['id'] as String,
      inspectorId: data['inspectorId'] as String,
      customerId: data['customerId'] as String,
      customerName: data['customerName'] as String,
      customerPhotoUrl: data['customerPhotoUrl'] as String?,
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] as String?,
      inspectionRequestId: data['inspectionRequestId'] as String?,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        inspectorId,
        customerId,
        customerName,
        customerPhotoUrl,
        rating,
        comment,
        inspectionRequestId,
        createdAt,
      ];
}
