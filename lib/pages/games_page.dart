import 'package:flutter/material.dart';
import '../widgets/game_card.dart';
import '../data/games_data.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Jeux"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: gamesList
            .map(
              (game) => GameCard(
                title: game["title"],
                route: game["route"],
                description: game["description"],
                tags: game["tags"].cast<String>(),
                imagePath: game["imagePath"],
              ),
            )
            .toList(),
      ),
    );
  }
}
