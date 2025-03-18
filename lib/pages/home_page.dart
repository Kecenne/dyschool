import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "../widgets/recent_game_card.dart";
import "../widgets/small_game_card.dart";
import "../data/games_data.dart";
import "../widgets/page_header.dart";
import "../widgets/recommended_game_card.dart";
import "../widgets/reward_graph.dart";
import "../widgets/daily_task_section.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> userTroubles = [];

  @override
  void initState() {
    super.initState();
    _loadUserTroubles();
  }

  Future<void> _loadUserTroubles() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data();
      if (userData != null && userData.containsKey("troubles")) {
        Map<String, dynamic> troublesMap = userData["troubles"];
        setState(() {
          userTroubles = troublesMap.entries
              .where((entry) => entry.value == true)
              .map((entry) => entry.key)
              .toList();
        });
      }
    }
  }

  List<Map<String, dynamic>> get recommendedGames {
    if (userTroubles.isEmpty) {
      final shuffledGames = List<Map<String, dynamic>>.from(gamesList)..shuffle();
      return shuffledGames.take(5).toList();
    }

    return gamesList.where((game) {
      List<String> gameTagsLower = (game["tags"] as List<dynamic>)
          .map((tag) => tag.toString().toLowerCase())
          .toList();
      List<String> userTroublesLower = 
          userTroubles.map((trouble) => trouble.toLowerCase()).toList();

      return gameTagsLower.any((tag) => userTroublesLower.contains(tag));
    }).toList();
  }

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
                itemCount: recommendedGames.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final game = recommendedGames[index];
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
