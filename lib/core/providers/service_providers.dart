import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/health_score_service.dart';
import '../../services/blacklist_service.dart';
import '../../services/auto_match_service.dart';
import '../../services/map_service.dart';
import '../../services/pdf_service.dart';
import '../../services/sensor_service.dart';

/// Provider for Health Score Service
final healthScoreServiceProvider = Provider<HealthScoreService>((ref) {
  return HealthScoreService();
});

/// Provider for Blacklist Service
final blacklistServiceProvider = Provider<BlacklistService>((ref) {
  return BlacklistService();
});

/// Provider for Auto Match Service
final autoMatchServiceProvider = Provider<AutoMatchService>((ref) {
  return AutoMatchService();
});

/// Provider for Map Service
final mapServiceProvider = Provider<MapService>((ref) {
  return MapService();
});

/// Provider for PDF Service
final pdfServiceProvider = Provider<PdfService>((ref) {
  return PdfService();
});

/// Provider for Sensor Service
final sensorServiceProvider = Provider<SensorService>((ref) {
  final service = SensorService();
  ref.onDispose(() => service.dispose());
  return service;
});
