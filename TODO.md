# TODO - RoadSafe AI Development

## Completed
- [x] Step 1: Generate missing web/ platform folder (`flutter create .`)
- [x] Step 2: Fix Firebase initialization crash in `lib/main.dart` (wrap in try/catch)
- [x] Step 3: Make the app web-compatible (verify top-level flow works)
- [x] Step 4: Run & verify the app on web (Chrome)

## GPS & Location
- [x] Step 1: Implement real GPS in `lib/services/gps_service.dart` using `geolocator`
- [x] Step 2: Wire GPS into screens (camera, pothole, map) to display real coordinates
- [x] Step 3: Verify GPS works on web/device

## IMU (G-Force) & Sensors
- [x] Step 1: Implement `ImuService` using `sensors_plus` in `lib/services/imu_service.dart`
- [x] Step 2: Wire `ImuService` into `CameraScreen` and `PotholeScreen` for real-time G-Force display
- [x] Step 3: Add severity calculation based on G-Force magnitude

## Notifications & Alerts
- [x] Step 1: Implement `NotificationService` using `flutter_local_notifications`
- [x] Step 2: Configure Android channels for Pothole and Blind Spot alerts
- [x] Step 3: Trigger notifications when actual events occur (Requires sensor threshold logic)

## Firebase & Integration
- [x] Step 1: Implement Cloud Firestore methods in FirebaseService
- [x] Step 2: Simulate YOLO detections for Potholes and Vehicles
- [x] Step 3: Implement Upload Report button in PotholeScreen
- [x] Step 4: Add simulation button in BlindSpotScreen
