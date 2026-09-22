import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

/// A card that displays a single numeric statistic.
class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
Text(value, style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
