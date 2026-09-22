class AppConstants {
  AppConstants._();

  // App information
  static const String appName = 'RoadSafe AI';
  static const String appVersion = '1.0.0';

  // Detection
  static const double defaultConfidenceThreshold = 0.50;

  // Pothole severity thresholds
  static const double lowGForceThreshold = 1.5;
  static const double mediumGForceThreshold = 2.5;
  static const double highGForceThreshold = 3.5;

  // Blind spot
  static const double blindSpotDistance = 5.0;
  static const double criticalTtc = 3.0;

  // GPS
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;

  // Messages
  static const String potholeDetected = 'Pothole Detected';
  static const String vehicleDetected = 'Vehicle Detected';
  static const String blindSpotWarning = 'Blind Spot Warning';
  static const String noVehicleDetected = 'No Vehicle Detected';
}