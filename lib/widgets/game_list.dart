import 'package:flutter/material.dart';
import '../widgets/game_card.dart';

class GameList extends StatelessWidget {
  final List<Map<String, dynamic>> games;

  const GameList({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: games
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
    );
  }
}