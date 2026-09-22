import 'package:flutter/material.dart';

class BlindSpotWarning extends StatelessWidget {
  final bool vehicleDetected;
  final String side;
  final String distance;
  final String ttc;

  const BlindSpotWarning({
    super.key,
    required this.vehicleDetected,
    required this.side,
    required this.distance,
    required this.ttc,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        vehicleDetected ? Colors.red : Colors.green;

    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              vehicleDetected
                  ? Icons.warning_rounded
                  : Icons.check_circle,
              color: color,
              size: 50,
            ),

            const SizedBox(height: 10),

            Text(
              vehicleDetected
                  ? 'BLIND SPOT WARNING'
                  : 'BLIND SPOT CLEAR',
              style: TextStyle(
                color: color,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (vehicleDetected) ...[
              _row('Side', side),
              _row('Distance', distance),
              _row('TTC', ttc),
            ] else
              const Text(
                'No vehicle detected in the blind spot.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}