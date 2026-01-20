import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Service for handling phone sensor data (accelerometer, gyroscope)
/// Used for engine vibration testing during vehicle inspection
class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  final List<double> _accelerationReadings = [];
  final List<double> _gyroscopeReadings = [];

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  /// Start recording sensor data for vibration test
  void startRecording() {
    _isRecording = true;
    _accelerationReadings.clear();
    _gyroscopeReadings.clear();

    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: Duration(
        milliseconds: AppConstants.sensorSamplingPeriod,
      ),
    ).listen((AccelerometerEvent event) {
      if (_isRecording) {
        // Calculate magnitude of acceleration vector
        final magnitude = sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );
        _accelerationReadings.add(magnitude);
      }
    });

    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: Duration(
        milliseconds: AppConstants.sensorSamplingPeriod,
      ),
    ).listen((GyroscopeEvent event) {
      if (_isRecording) {
        final magnitude = sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );
        _gyroscopeReadings.add(magnitude);
      }
    });
  }

  /// Stop recording and analyze the data
  VibrationTestResult stopRecordingAndAnalyze() {
    _isRecording = false;
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();

    return _analyzeReadings();
  }

  /// Analyze collected sensor readings
  VibrationTestResult _analyzeReadings() {
    if (_accelerationReadings.isEmpty) {
      return VibrationTestResult(
        averageAcceleration: 0,
        maxAcceleration: 0,
        stability: 0,
        passed: false,
        testedAt: DateTime.now(),
      );
    }

    // Calculate average acceleration
    final avgAcceleration =
        _accelerationReadings.reduce((a, b) => a + b) / _accelerationReadings.length;

    // Find max acceleration
    final maxAcceleration =
        _accelerationReadings.reduce((a, b) => a > b ? a : b);

    // Calculate standard deviation for stability score
    final variance = _accelerationReadings
            .map((x) => pow(x - avgAcceleration, 2))
            .reduce((a, b) => a + b) /
        _accelerationReadings.length;
    final stdDev = sqrt(variance);

    // Stability score: lower std dev = higher stability (0-100)
    // Typical idle engine should have low variance
    final stability = max(0, min(100, 100 - (stdDev * 20)));

    // Test passes if:
    // - Average acceleration is within normal range (9-11 m/s² for gravity + slight vibration)
    // - Stability score is above 60%
    final passed = avgAcceleration >= 8.5 &&
        avgAcceleration <= 12.0 &&
        stability >= 60;

    return VibrationTestResult(
      averageAcceleration: avgAcceleration,
      maxAcceleration: maxAcceleration,
      stability: stability,
      passed: passed,
      testedAt: DateTime.now(),
    );
  }

  /// Get current accelerometer stream for real-time display
  Stream<AccelerometerEvent> get accelerometerStream => accelerometerEventStream(
        samplingPeriod: const Duration(milliseconds: 100),
      );

  /// Get current gyroscope stream for real-time display
  Stream<GyroscopeEvent> get gyroscopeStream => gyroscopeEventStream(
        samplingPeriod: const Duration(milliseconds: 100),
      );

  /// Dispose of resources
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }
}
