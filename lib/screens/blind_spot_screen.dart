import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class BlindSpotScreen extends StatefulWidget {
  const BlindSpotScreen({super.key});

  @override
  State<BlindSpotScreen> createState() => _BlindSpotScreenState();
}

class _BlindSpotScreenState extends State<BlindSpotScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

  void _simulateDetection() {
    _notificationService.showBlindSpotAlert(
      side: "Left",
      distance: 3.2,
      ttc: 1.5,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Simulated blind spot detection alert!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blind Spot Detection"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // CAMERA PREVIEW
            Container(
              height: 220,

              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // WARNING
            Card(
              color: Colors.red.shade100,

              child: const ListTile(
                leading: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),

                title: Text(
                  "Bike Detected",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  "Left Blind Spot",
                ),
              ),
            ),

            const SizedBox(height: 15),

            // VEHICLE TYPE
            Card(
              child: const ListTile(
                leading: Icon(
                  Icons.two_wheeler,
                ),

                title: Text(
                  "Vehicle",
                ),

                subtitle: Text(
                  "Motorcycle",
                ),
              ),
            ),

            // DISTANCE
            Card(
              child: const ListTile(
                leading: Icon(
                  Icons.straighten,
                ),

                title: Text(
                  "Distance",
                ),

                subtitle: Text(
                  "4.5 meters",
                ),
              ),
            ),

            // TTC
            Card(
              child: const ListTile(
                leading: Icon(
                  Icons.timer,
                ),

                title: Text(
                  "TTC",
                ),

                subtitle: Text(
                  "2.3 sec",
                ),
              ),
            ),

            const Spacer(),

            // SIMULATE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _simulateDetection,
                icon: const Icon(
                  Icons.bug_report,
                ),
                label: const Text(
                  "Simulate Detection",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ALERT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Blind spot alert activated",
                      ),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.notifications_active,
                ),

                label: const Text(
                  "Activate Alert",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}