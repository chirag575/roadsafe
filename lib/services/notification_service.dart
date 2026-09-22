import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(
        initializationSettings,
      );

      _initialized = true;
      debugPrint('Notification service initialized');
    } catch (e) {
      debugPrint('Notification service error: $e');
      rethrow;
    }
  }

  Future<void> showPotholeAlert({
    required String severity,
    required double gForce,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'pothole_alerts',
      'Pothole Alerts',
      channelDescription: 'Alerts when a pothole is detected',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Color(0xFFFF0000),
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'POTHOLE DETECTED!',
      'Severity: $severity (${gForce.toStringAsFixed(2)} G)',
      platformDetails,
    );
  }

  Future<void> showBlindSpotAlert({
    required String side,
    required double distance,
    required double ttc,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'blind_spot_alerts',
      'Blind Spot Alerts',
      channelDescription: 'Alerts when a vehicle is in the blind spot',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Color(0xFF0000FF),
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1,
      'BLIND SPOT WARNING!',
      '$side side: ${distance.toStringAsFixed(1)}m away, TTC: ${ttc.toStringAsFixed(1)}s',
      platformDetails,
    );
  }

  Future<void> dispose() async {
    _initialized = false;
  }
}
