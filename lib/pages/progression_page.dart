import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/playtime_manager.dart';
import '../widgets/page_header.dart';
import "../widgets/reward_graph.dart";
import "../widgets/weekly_playtime_graph.dart";
import "../widgets/month_playtime.dart";

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
            const SizedBox(height: 32),

            Consumer<PlaytimeManager>(
              builder: (context, playtimeManager, child) {
                return const WeeklyPlaytimeGraph();
              },
            ),
            const SizedBox(height: 16),

            // Section Récompenses
            const SizedBox(height: 32),
            const RewardGraph(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),

            // Section Statistiques
            const MonthPlaytime(),
          ],
        ),
      ),
    );
  }
}