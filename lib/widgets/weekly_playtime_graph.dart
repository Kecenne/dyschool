import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/playtime_manager.dart';

class WeeklyPlaytimeGraph extends StatelessWidget {
  final Map<String, int> weeklyData;

  const WeeklyPlaytimeGraph({Key? key, required this.weeklyData}) : super(key: key);

  static const int maxPlaytime = 30;
  static const double graphHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final playtimeManager = Provider.of<PlaytimeManager>(context);
    final weeklyData = playtimeManager.getWeeklyPlaytime();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Temps de Jeu", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Graphique
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: graphHeight + 50,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGraphLine("30+ min"),
                    _buildGraphLine("20 min"),
                    _buildGraphLine("10 min"),
                    _buildGraphLine("0 min"),
                  ],
                ),
              ),

              // Barres du graphique
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weeklyData.entries.map((entry) {
                    double height = (entry.value > maxPlaytime ? maxPlaytime : entry.value) / maxPlaytime * graphHeight;
                    return _buildPlaytimeColumn(entry.key, height, entry.value);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Résumé du temps de jeu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("AUJOURD'HUI", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${playtimeManager.getTodayPlaytime()} min"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("7 DERNIERS JOURS", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${playtimeManager.getTotalWeeklyPlaytime()} min"),
          ],
        ),
      ],
    );
  }

  Widget _buildGraphLine(String label) {
    return Row(
      children: [
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: Colors.black26)),
      ],
    );
  }

  Widget _buildPlaytimeColumn(String day, double barHeight, int playtime) {
    return SizedBox(
      width: 30, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: barHeight.clamp(0, graphHeight - 10), 
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(day.substring(0, 3), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getCurrentDay() {
    return DateFormat('E', 'fr_FR').format(DateTime.now()).substring(0, 3);
  }
}