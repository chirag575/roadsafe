import 'package:flutter/foundation.dart';

import '../models/vehicle.dart';

class BlindSpotService {
  static const double blindSpotDistance = 5.0;
  static const double criticalTtc = 3.0;

  bool isVehicleInBlindSpot({
    required double distance,
    required String side,
  }) {
    final validSide =
        side.toLowerCase() == 'left' ||
        side.toLowerCase() == 'right';

    return validSide &&
        distance <= blindSpotDistance;
  }

  double calculateTtc({
    required double distance,
    required double relativeSpeed,
  }) {
    if (relativeSpeed <= 0) {
      return double.infinity;
    }

    return distance / relativeSpeed;
  }

  bool isCritical({
    required double distance,
    required double relativeSpeed,
  }) {
    final ttc = calculateTtc(
      distance: distance,
      relativeSpeed: relativeSpeed,
    );

    return ttc <= criticalTtc;
  }

  String getWarningLevel({
    required double distance,
    required double ttc,
  }) {
    if (distance <= 2.0 || ttc <= 1.5) {
      return 'HIGH';
    }

    if (distance <= 5.0 || ttc <= 3.0) {
      return 'MEDIUM';
    }

    return 'SAFE';
  }

  Vehicle createVehicle({
    required String type,
    required String side,
    required double distance,
    required double speed,
    required double confidence,
  }) {
    final ttc = calculateTtc(
      distance: distance,
      relativeSpeed: speed,
    );

    final vehicle = Vehicle(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      type: type,
      side: side,
      distance: distance,
      speed: speed,
      ttc: ttc,
      confidence: confidence,
      detectedAt: DateTime.now(),
    );

    debugPrint(
      'Vehicle detected: $type | $side | $distance m',
    );

    return vehicle;
  }
}