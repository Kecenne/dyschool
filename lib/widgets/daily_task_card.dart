import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class DailyTaskCard extends StatelessWidget {
  final String title;
  final String difficulty;
  final int progress;
  final int goal;

  const DailyTaskCard({
    Key? key,
    required this.title,
    required this.difficulty,
    required this.progress,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progressValue = (progress / goal).clamp(0.0, 1.0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBC4E16),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Niveau $difficulty",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.grey[300],
                color: AppColors.primaryColor, 
                minHeight: 24,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$progress / $goal",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}