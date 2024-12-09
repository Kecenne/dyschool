import "package:flutter/material.dart";
import '../theme/app_color.dart';
import "../widgets/recent_game_card.dart";
import "../widgets/small_game_card.dart";
import "../data/games_data.dart";
import "../widgets/page_header.dart";

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

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Container(
                height: 400,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    "Récompenses quotidiennes",
                    style: TextStyle(fontSize: 18, color: AppColors.primaryColor,),
                  ),
                ),
              ),
            ),
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
                    title: game['title'],
                    imagePath: game['imagePath'],
                    route: game['route'],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Recommendations
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Text(
                          "Recommendations",
                          style: TextStyle(fontSize: 16, color: AppColors.primaryColor,),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Graphique
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    "Graphique",
                    style: TextStyle(fontSize: 18, color: AppColors.primaryColor,),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Herisson
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      height: 100, 
                      child: const Center(
                        child: Text(
                          "Herisson or",
                          style: TextStyle(color: AppColors.primaryColor)
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      height: 100,
                      child: const Center(
                        child: Text(
                          "Herisson argent",
                          style: TextStyle(color: AppColors.primaryColor)
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      height: 100,
                      child: const Center(
                        child: Text(
                          "Herisson bronze",
                          style: TextStyle(color: AppColors.primaryColor)
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
