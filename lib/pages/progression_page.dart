import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/playtime_manager.dart';
import '../widgets/page_header.dart';
import "../widgets/reward_graph.dart";
import "../widgets/weekly_playtime_graph.dart";

class ProgressionPage extends StatelessWidget {
  const ProgressionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: "Progression"),
            const SizedBox(height: 16),

            Consumer<PlaytimeManager>(
              builder: (context, playtimeManager, child) {
                return WeeklyPlaytimeGraph(weeklyData: playtimeManager.getWeeklyPlaytime());
              },
            ),
            const SizedBox(height: 16),

            // Section Récompenses
            const SizedBox(height: 32),
            const RewardGraph(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),

            // Section Statistiques
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Statistiques"),
                        DropdownButton<String>(
                          hint: const Text("Choix du mois"),
                          items: <String>["Janvier", "Février", "Mars", "Avril", "Mai"]
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatItem("Casse-tête", "85 MIN ET 54 SECONDES"),
                    _buildStatItem("Aventure", "32 MIN ET 23 SECONDES"),
                    _buildStatItem("Mémoire", "10 SECONDES"),
                    _buildStatItem("Jeux de plateau", "1 HEURE 25 MINUTES ET 30 SECONDES"),
                    _buildStatItem("Jeux - Disgraphie", "45 MIN ET 14 SECONDES"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(time),
                ],
              ),
              const SizedBox(
                width: 100,
                height: 50,
                child: Center(child: Text("Graphique")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}