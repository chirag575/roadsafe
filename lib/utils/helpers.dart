import 'dart:math';

class AppHelpers {
  AppHelpers._();

  // Generate a simple unique ID.
  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);

    return '$timestamp-$random';
  }

  // Convert confidence from decimal to percentage.
  static String formatConfidence(double confidence) {
    final percentage = confidence * 100;
    return '${percentage.toStringAsFixed(1)}%';
  }

  // Determine pothole severity from G-force.
  static String calculateSeverity(double gForce) {
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

  // Calculate TTC.
  //
  // distance = meters
  // relativeSpeed = meters/second
  static double calculateTtc(
    double distance,
    double relativeSpeed,
  ) {
    if (relativeSpeed <= 0) {
      return double.infinity;
    }

    return distance / relativeSpeed;
  }

  // Check whether TTC is dangerous.
  static bool isCriticalTtc(double ttc) {
    return ttc > 0 && ttc <= 3.0;
  }

  // Format coordinates.
  static String formatCoordinates(
    double latitude,
    double longitude,
  ) {
    return '${latitude.toStringAsFixed(6)}, '
        '${longitude.toStringAsFixed(6)}';
  }

  // Format date and time.
  static String formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}