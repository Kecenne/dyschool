import 'package:flutter/material.dart';
import '../widgets/game_card.dart';
import '../data/games_data.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  String searchQuery = "";
  String selectedTrouble = "";
  String selectedGameType = "";

  List<Map<String, dynamic>> get filteredGames {
    return gamesList.where((game) {
      final matchesSearchQuery = game["title"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesTrouble = selectedTrouble.isEmpty ||
          game["tags"].contains(selectedTrouble);
      return matchesSearchQuery && matchesTrouble;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Jeux"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un jeu',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16.0),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Type de troubles',
                      border: OutlineInputBorder(),
                    ),
                    items: ["", "Dyslexie", "Dyspraxie", "Dysorthographie", "Dysgraphie", "Dyscalculie", "Dysphasie", "Dyséxécutif"]
                        .map((trouble) => DropdownMenuItem(
                              value: trouble,
                              child: Text(
                                  trouble.isEmpty ? "Tous les troubles" : trouble),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTrouble = value ?? "";
                      });
                    },
                    value: selectedTrouble,
                  ),
                ),
                const SizedBox(width: 16.0),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Type de jeux',
                      border: OutlineInputBorder(),
                    ),
                    items: ["", "Type 1", "Type 2", "Type 3"]
                        .map((gameType) => DropdownMenuItem(
                              value: gameType,
                              child: Text(
                                  gameType.isEmpty ? "Tous les types" : gameType),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGameType = value ?? "";
                      });
                    },
                    value: selectedGameType,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            Expanded(
              child: ListView(
                children: filteredGames
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
            ),
          ],
        ),
      ),
    );
  }
}