import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'utils/routes.dart';

class RoadSafeAI extends StatelessWidget {
  const RoadSafeAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoadSafe AI',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}