import "package:flutter/material.dart";
import "../widgets/recent_game_card.dart";
import "../widgets/small_game_card.dart";
import "../data/games_data.dart";
import "../widgets/page_header.dart";
import "../widgets/recommended_game_card.dart";
import "../widgets/reward_graph.dart";
import "../widgets/daily_task_section.dart";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstGame = gamesList[0];
    final recentGames = gamesList.sublist(1);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const PageHeader(title: "Accueil"),
            const SizedBox(height: 16),

            const DailyTasksSection(),
            const SizedBox(height: 16),

            // Jeu récent
            RecentGameCard(
              title: firstGame['title'],
              imagePath: firstGame['imagePath'],
              description: firstGame['description'],
              tags: List<String>.from(firstGame['tags']),
              route: firstGame['route'],
            ),
            const SizedBox(height: 16),

            // Jeux récents 2
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.23 + 20,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentGames.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final game = recentGames[index];
                  return SmallGameCard(
                    imagePath: game['imagePath'],
                    route: game['route'],
                  );
                },
              ),
            ),
            const SizedBox(height: 64),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nos recommandations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16), 

            SizedBox(
              height: MediaQuery.of(context).size.width * 0.25 + 20,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentGames.length, 
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final game = recentGames[index];
                  return RecommendedGameCard(
                    title: game['title'],
                    imagePath: game['imagePath'],
                    route: game['route'],
                  );
                },
              ),
            ),
            const SizedBox(height: 64),

            // Graphique
            const SizedBox(height: 32),
            const RewardGraph(),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
