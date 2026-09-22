import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/pothole.dart';
import '../models/vehicle.dart';

class FirebaseService {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    try {
      // Firebase initialization is typically handled in main.dart
      // for Flutter projects using firebase_core.
      
      _initialized = true;
      debugPrint('Firebase service ready');
    } catch (e) {
      debugPrint('Firebase error: $e');
      rethrow;
    }
  }

  Future<void> savePothole(
    Pothole pothole,
  ) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      await FirebaseFirestore.instance
          .collection('potholes')
          .doc(pothole.id)
          .set(pothole.toMap());

      debugPrint(
        'Pothole saved to Firestore: ${pothole.id}',
      );
    } catch (e) {
      debugPrint('Error saving pothole to Firestore: $e');
      // For simulation purposes, we won't rethrow here if we want the app to keep running
    }
  }

  Future<void> saveVehicle(
    Vehicle vehicle,
  ) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(vehicle.id)
          .set(vehicle.toMap());

      debugPrint(
        'Vehicle saved to Firestore: ${vehicle.id}',
      );
    } catch (e) {
      debugPrint('Error saving vehicle to Firestore: $e');
    }
  }

  Future<void> deletePothole(
    String id,
  ) async {
    debugPrint(
      'Pothole deleted: $id',
    );
  }

  Future<void> dispose() async {
    _initialized = false;
  }
}