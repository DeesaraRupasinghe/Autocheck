import '../models/models.dart';

/// Service providing mock inspection service providers
/// In production, this would connect to a real API
class MapService {
  /// Get nearby inspection services (mock data for Sri Lanka)
  Future<List<InspectionService>> getNearbyInspectionServices({
    double? latitude,
    double? longitude,
    double radiusKm = 10.0,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data for Sri Lanka
    return _mockInspectionServices;
  }

  /// Calculate distance between two points (simplified Haversine)
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Simplified distance calculation for demo
    // In production, use proper Haversine formula
    final latDiff = (lat2 - lat1).abs();
    final lonDiff = (lon2 - lon1).abs();
    return (latDiff + lonDiff) * 111; // Rough km approximation
  }

  /// Mock inspection services in Colombo area
  static final List<InspectionService> _mockInspectionServices = [
    const InspectionService(
      id: '1',
      name: 'AutoCare Inspections',
      address: 'No. 45, Galle Road, Colombo 03',
      phoneNumber: '+94 11 234 5678',
      latitude: 6.9271,
      longitude: 79.8612,
      rating: 4.8,
      reviewCount: 256,
      priceFrom: 5000,
      services: [
        'Full Vehicle Inspection',
        'Hybrid Battery Check',
        'Pre-Purchase Inspection',
        'Computer Diagnostics',
      ],
      isVerified: true,
    ),
    const InspectionService(
      id: '2',
      name: 'VehicleDoc Lanka',
      address: 'No. 123, Duplication Road, Colombo 04',
      phoneNumber: '+94 11 567 8901',
      latitude: 6.8896,
      longitude: 79.8567,
      rating: 4.6,
      reviewCount: 189,
      priceFrom: 4500,
      services: [
        'Basic Inspection',
        'Full Inspection',
        'Engine Diagnostics',
        'Document Verification',
      ],
      isVerified: true,
    ),
    const InspectionService(
      id: '3',
      name: 'Ceylon Motor Inspectors',
      address: 'No. 78, High Level Road, Nugegoda',
      phoneNumber: '+94 11 289 3456',
      latitude: 6.8728,
      longitude: 79.8885,
      rating: 4.5,
      reviewCount: 145,
      priceFrom: 3500,
      services: [
        'Basic Inspection',
        'Full Inspection',
        'Accident Check',
      ],
      isVerified: false,
    ),
    const InspectionService(
      id: '4',
      name: 'Prime Auto Check',
      address: 'No. 234, Kandy Road, Kiribathgoda',
      phoneNumber: '+94 11 901 2345',
      latitude: 6.9784,
      longitude: 79.9279,
      rating: 4.7,
      reviewCount: 98,
      priceFrom: 4000,
      services: [
        'Full Vehicle Inspection',
        'Hybrid Specialist',
        'Computer Diagnostics',
        'Pre-Purchase Reports',
      ],
      isVerified: true,
    ),
    const InspectionService(
      id: '5',
      name: 'Lanka Vehicle Experts',
      address: 'No. 56, Negombo Road, Wattala',
      phoneNumber: '+94 11 456 7890',
      latitude: 6.9897,
      longitude: 79.8912,
      rating: 4.4,
      reviewCount: 76,
      priceFrom: 3000,
      services: [
        'Basic Inspection',
        'Engine Check',
        'Body Inspection',
      ],
      isVerified: false,
    ),
    const InspectionService(
      id: '6',
      name: 'TrustAuto Inspections',
      address: 'No. 89, Galle Road, Mount Lavinia',
      phoneNumber: '+94 11 234 5678',
      latitude: 6.8390,
      longitude: 79.8652,
      rating: 4.9,
      reviewCount: 312,
      priceFrom: 6000,
      services: [
        'Premium Inspection',
        'Full Vehicle Report',
        'Hybrid & Electric Specialist',
        'Mobile Inspection Service',
        'Court-Ready Reports',
      ],
      isVerified: true,
    ),
  ];
}
