import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/detection_result.dart';
import '../services/imu_service.dart';
import '../services/notification_service.dart';
import '../services/yolo_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final ImuService _imuService = ImuService();
  final YoloService _yoloService = YoloService();
  final NotificationService _notificationService = NotificationService();

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  StreamSubscription<Position>? _gpsSubscription;
  StreamSubscription<ImuData>? _imuSubscription;

  List<DetectionResult> _detections = const [];
  bool _processingFrame = false;

  String gpsLocation = "Fetching GPS...";
  String gForceValue = "0.0 G";
  String detectionStatus = "Waiting for detection...";
  String blindSpotStatus = "Monitoring vehicles...";

  String cameraStatus = "Starting camera...";

  bool cameraReady = false;
  bool imuReady = false;
  bool _alertTriggered = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initCamera();
    await _initGps();
    await _initImu();
    await _initYolo();

    await _notificationService.initialize();
  }

  // ==========================================================
  // CAMERA INITIALIZATION
  // ==========================================================

  Future<void> _initCamera() async {
    try {
      setState(() {
        cameraStatus = "Requesting camera permission...";
        cameraReady = false;
      });

      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            cameraStatus = "No camera found";
          });
        }
        return;
      }

      // Use the back camera if available
      CameraDescription selectedCamera = _cameras.first;

      for (final camera in _cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          selectedCamera = camera;
          break;
        }
      }

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_onCameraImage);

      if (mounted) {
        setState(() {
          cameraReady = true;
          cameraStatus = "Camera Active";
        });
      }
    } on CameraException catch (e) {
      if (mounted) {
        setState(() {
          cameraReady = false;
          cameraStatus = "Camera Error: ${e.description ?? e.code}";
        });
      }

      debugPrint("Camera Error: $e");
    } catch (e) {
      if (mounted) {
        setState(() {
          cameraReady = false;
          cameraStatus = "Camera Error: $e";
        });
      }

      debugPrint("Camera Error: $e");
    }
  }

  // ==========================================================
  // GPS INITIALIZATION
  // ==========================================================

  Future<void> _initGps() async {
    try {
      if (mounted) {
        setState(() {
          gpsLocation = "Checking GPS...";
        });
      }

      // Check if location is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            gpsLocation = "Please turn ON phone Location";
          });
        }
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            gpsLocation = "Location permission denied";
          });
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            gpsLocation = "Location permission permanently denied";
          });
        }

        return;
      }

      // Cancel old GPS stream before starting a new one
      await _gpsSubscription?.cancel();

      if (mounted) {
        setState(() {
          gpsLocation = "Getting current location...";
        });
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          gpsLocation = "${position.latitude.toStringAsFixed(7)}, "
              "${position.longitude.toStringAsFixed(7)}";
        });
      }

      // Start live GPS updates
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );

      _gpsSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          if (mounted) {
            setState(() {
              gpsLocation = "${position.latitude.toStringAsFixed(7)}, "
                  "${position.longitude.toStringAsFixed(7)}";
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              gpsLocation = "GPS Error: $error";
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          gpsLocation = "GPS Error: $e";
        });
      }

      debugPrint("GPS Error: $e");
    }
  }

  // ==========================================================
  // IMU INITIALIZATION
  // ==========================================================

  Future<void> _initImu() async {
    try {
      await _imuService.initialize();

      if (mounted) {
        setState(() {
          imuReady = true;
        });
      }

      _imuSubscription = _imuService.getImuStream().listen((data) {
        if (!mounted) return;

        setState(() {
          gForceValue = "${data.gForce.toStringAsFixed(2)} G";
        });

        if (data.gForce > 3.0 && !_alertTriggered) {
          _alertTriggered = true;

          _notificationService.showPotholeAlert(
            severity: _imuService.calculateSeverity(
              data.gForce,
            ),
            gForce: data.gForce,
          );

          Future.delayed(
            const Duration(seconds: 5),
            () {
              _alertTriggered = false;
            },
          );
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          imuReady = false;
        });
      }

      debugPrint("IMU Error: $e");
    }
  }

  // ==========================================================
  // YOLO INITIALIZATION
  // ==========================================================

  Future<void> _initYolo() async {
    try {
      await _yoloService.loadPotholeModel();
    } catch (e) {
      debugPrint("YOLO Error: $e");

      if (mounted) {
        setState(() {
          detectionStatus = "AI model not available";
        });
      }
    }
  }

  Future<void> _onCameraImage(CameraImage image) async {
    if (_processingFrame || !cameraReady || !_yoloService.isLoaded) return;
    _processingFrame = true;
    try {
      final detections = await _yoloService.detect(image);
      if (!mounted) return;
      final potholes = detections
          .where((detection) => detection.type == DetectionType.pothole)
          .toList();
      setState(() {
        _detections = potholes;
        detectionStatus = potholes.isEmpty
            ? "No potholes detected"
            : "Pothole detected (${(potholes.first.confidence * 100).toStringAsFixed(0)}%)"
                " - ${potholes.first.severity ?? 'Unknown'} severity";
      });
    } catch (error) {
      debugPrint("YOLO frame error: $error");
    } finally {
      _processingFrame = false;
    }
  }

  // ==========================================================
  // APP LIFECYCLE
  // ==========================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      if (controller.value.isStreamingImages) {
        controller.stopImageStream();
      }
      controller.dispose();
      _cameraController = null;

      if (mounted) {
        setState(() {
          cameraReady = false;
        });
      }
    }

    if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _gpsSubscription?.cancel();
    _imuSubscription?.cancel();
    _yoloService.dispose();

    _cameraController?.dispose();

    super.dispose();
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Live Detection",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CAMERA PREVIEW
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // REAL CAMERA PREVIEW
                    if (_cameraController != null &&
                        _cameraController!.value.isInitialized)
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _cameraController!.value.previewSize!.height,
                            height: _cameraController!.value.previewSize!.width,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CameraPreview(_cameraController!),
                                if (_detections.isNotEmpty)
                                  CustomPaint(
                                    painter: _DetectionOverlayPainter(
                                      _detections,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 90,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            cameraStatus,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: _initCamera,
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            label: const Text(
                              "Start Camera",
                            ),
                          ),
                        ],
                      ),

                    // LIVE INDICATOR
                    if (cameraReady)
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 9,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // AI DETECTION STATUS
                    Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          detectionStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // INFORMATION AREA
            Expanded(
              flex: 4,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  _buildInfoCard(
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    title: "GPS",
                    value: gpsLocation,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.grey,
                      ),
                      onPressed: _initGps,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.camera,
                    iconColor: Colors.blue,
                    title: "Camera",
                    value: cameraStatus,
                    trailing: Icon(
                      cameraReady ? Icons.check_circle : Icons.error,
                      color: cameraReady ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.speed,
                    iconColor: Colors.orange,
                    title: "IMU / G-Force",
                    value: imuReady ? gForceValue : "Sensor Not Available",
                    trailing: Icon(
                      imuReady ? Icons.check_circle : Icons.error,
                      color: imuReady ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetectionCard(
                    icon: Icons.warning_rounded,
                    color: Colors.orange,
                    title: "Pothole Detection",
                    subtitle: detectionStatus,
                  ),
                  const SizedBox(height: 10),
                  _buildDetectionCard(
                    icon: Icons.directions_car,
                    color: Colors.blue,
                    title: "Blind Spot Detection",
                    subtitle: blindSpotStatus,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.stop),
                      label: const Text(
                        "STOP DETECTION",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // INFORMATION CARD
  // ==========================================================

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: iconColor.withOpacity(0.12),
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // ==========================================================
  // DETECTION CARD
  // ==========================================================

  Widget _buildDetectionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.more_horiz,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _DetectionOverlayPainter extends CustomPainter {
  const _DetectionOverlayPainter(this.detections);

  final List<DetectionResult> detections;

  @override
  void paint(Canvas canvas, Size size) {
    final boxPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final labelPaint = Paint()..color = Colors.redAccent.withOpacity(0.85);
    for (final detection in detections) {
      final rect = Rect.fromLTWH(
        detection.x * size.width,
        detection.y * size.height,
        detection.width * size.width,
        detection.height * size.height,
      );
      canvas.drawRect(rect, boxPaint);
      final label =
          '${detection.label} ${(detection.confidence * 100).toStringAsFixed(0)}%'
          '${detection.severity == null ? '' : ' - ${detection.severity}'}';
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);
      final labelRect = Rect.fromLTWH(
        rect.left,
        max(0, rect.top - textPainter.height - 4),
        textPainter.width + 8,
        textPainter.height + 4,
      );
      canvas.drawRect(labelRect, labelPaint);
      textPainter.paint(canvas, Offset(labelRect.left + 4, labelRect.top + 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DetectionOverlayPainter oldDelegate) =>
      oldDelegate.detections != detections;
}
