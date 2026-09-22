import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ImuData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const ImuData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  double get totalAcceleration {
    return sqrt(
      (x * x) +
      (y * y) +
      (z * z),
    );
  }

  double get gForce {
    // Standard gravity ≈ 9.81 m/s²
    return totalAcceleration / 9.81;
  }
}

class ImuService {
  bool _isInitialized = false;
  bool _isMonitoring = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  bool get isInitialized => _isInitialized;
  bool get isMonitoring => _isMonitoring;

  Future<void> initialize() async {
    try {
      // Check if we can access the sensors (not strictly required by API, 
      // but good to check if we can get a stream)
      _isInitialized = true;
      debugPrint('IMU initialized');
    } catch (e) {
      debugPrint('IMU error: $e');
      rethrow;
    }
  }

  Stream<ImuData> getImuStream() {
    return accelerometerEventStream().map((event) => ImuData(
      x: event.x,
      y: event.y,
      z: event.z,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> startMonitoring() async {
    if (!_isInitialized) {
      await initialize();
    }
    _isMonitoring = true;
    debugPrint('IMU monitoring started');
  }

  Future<void> stopMonitoring() async {
    _isMonitoring = false;
    debugPrint('IMU monitoring stopped');
  }

  String calculateSeverity(double gForce) {
    if (gForce >= 3.5) {
      return 'High';
    }
    if (gForce >= 2.5) {
      return 'Medium';
    }
    if (gForce >= 1.5) {
      return 'Low';
    }
    return 'Normal';
  }

  Future<void> dispose() async {
    await _accelerometerSubscription?.cancel();
    _isMonitoring = false;
    _isInitialized = false;
    debugPrint('IMU disposed');
  }
}
