import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../services/medal_manager.dart';
import 'daily_task_card.dart';

class DailyTasksSection extends StatelessWidget {
  const DailyTasksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medalManager = Provider.of<MedalManager>(context);

    final List<Map<String, dynamic>> selectedTasks = List.from(taskList)..shuffle();
    final List<Map<String, dynamic>> tasksToShow = selectedTasks.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Récompenses quotidiennes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: tasksToShow.map((task) {
              int currentProgress = 0;

              switch (task['type']) {
                case 'bronze':
                  currentProgress = medalManager.bronzeMedals;
                  break;
                case 'silver':
                  currentProgress = medalManager.silverMedals;
                  break;
                case 'gold':
                  currentProgress = medalManager.goldMedals;
                  break;
              }

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DailyTaskCard(
                  title: task['title'],
                  difficulty: task['difficulty'],
                  progress: currentProgress,
                  goal: task['goal'],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}