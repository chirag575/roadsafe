import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/blind_spot_screen.dart';
import '../screens/pothole_screen.dart';
import '../screens/map_screen.dart';
import '../screens/report_screen.dart';
import '../screens/report_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String blindSpot = '/blindspot';
  static const String pothole = '/pothole';
  static const String map = '/map';
  static const String reports = '/reports';
  static const String reportDetails = '/reportDetails';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      camera: (context) => const CameraScreen(),
      blindSpot: (context) => const BlindSpotScreen(),
      pothole: (context) => const PotholeScreen(),
      map: (context) => const MapScreen(),
      reports: (context) => const ReportScreen(),
      reportDetails: (context) => const ReportDetailScreen(),
      profile: (context) => const ProfileScreen(),
      settings: (context) => const SettingsScreen(),
      about: (context) => const AboutScreen(),
    };
  }
}