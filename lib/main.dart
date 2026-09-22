import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } on FirebaseException catch (error) {
    debugPrint(
      'Firebase initialization failed (${error.code}): ${error.message}',
    );
  }

  runApp(const RoadSafeAI());
}
