import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/games_data.dart';
import '../theme/app_color.dart';
import '../games/memory_game.dart';
import '../games/seven_family_game.dart';
import '../games/connect_four_game.dart';
import '../games/guess_who_game.dart';


class TemplateJeuPage extends StatefulWidget {
  const TemplateJeuPage({Key? key}) : super(key: key);

  @override
  _TemplateJeuPageState createState() => _TemplateJeuPageState();
}

class _TemplateJeuPageState extends State<TemplateJeuPage> {
  String selectedSection = 'Règles';

  @override
  Widget build(BuildContext context) {
    // Récupère les données transmises via les paramètres de la route
    final gameId = Get.parameters['id'];
    final game = gamesList.firstWhere((g) => g['id'] == gameId);

    // Section : Règles
    Widget buildRules() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: game['rules']
            .map<Widget>((rule) => _buildBlueBlock(
                  title: rule['title'],
                  content: rule['content'],
                ))
            .toList(),
      );
    }

    // Section : Troubles
    Widget buildTroubles() {
      return _buildBlueBlock(
        title: "Troubles associés",
        content: game['tags'].join(", "),
      );
    }

    // Section : Objectifs
    Widget buildObjectives() {
      return _buildBlueBlock(
        title: "Objectifs",
        content: game['objectives'],
      );
    }

    // Section dynamique basée sur le contenu sélectionné
    Widget getSectionContent() {
      switch (selectedSection) {
        case 'Règles':
          return buildRules();
        case 'Jeu':
          return _buildBlueBlock(
            title: "Jeu",
            content: game['description'],
          );
        case 'Troubles':
          return buildTroubles();
        case 'Objectifs':
          return buildObjectives();
        default:
          return const Text("Section inconnue");
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image en haut de la page
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(game['imagePath']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Contenu de la page
            Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du jeu
                  Center(
                    child: Text(
                      game['title'],
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Temps de jeu
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 8),
                      Text("15 minutes", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 24),
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 8),
                      Text("1h34", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Bouton "JOUER"
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          if (game['id'] == 'jeu-de-memoire') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => MemoryGamePage()),
                            );
                          } else if (game['id'] == 'jeu-des-7-familles') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SevenFamilyGamePage()),
                            );
                          } else if (game['id'] == 'puissance-4') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ConnectFourGamePage()),
                            );
                          } else if (game['id'] == 'qui-est-ce') {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => GuessWhoGamePage()),
                              );
}
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "JOUER",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36.0),

                  // Explication du jeu
                  const Text(
                    "Explication du jeu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    game['description'],
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                  const SizedBox(height: 36.0),

                  // Onglets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Règles', 'Jeu', 'Troubles', 'Objectifs']
                        .map(
                          (section) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSection = section;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  section,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: selectedSection == section
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedSection == section
                                        ? Colors.deepPurple
                                        : Colors.black,
                                  ),
                                ),
                                if (selectedSection == section)
                                  Container(
                                    height: 3,
                                    width: 60,
                                    color: Colors.deepPurple,
                                    margin: const EdgeInsets.only(top: 8),
                                  ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24.0),

                  // Contenu de la section sélectionnée
                  getSectionContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget générique pour afficher une section avec titre et contenu
  Widget _buildBlueBlock({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}