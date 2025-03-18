import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../data/games_data.dart';
import '../theme/app_color.dart';
import '../games/memoire/memory_game.dart';
import '../games/7-familles/seven_family_game.dart';
import '../games/puissance-4/connect_four_game.dart';
import '../games/qui-est-ce/guess_who_game.dart';
import '../games/simon/simon_game.dart';
import '../widgets/tag_list.dart';
import '../services/playtime_manager.dart';


class TemplateJeuPage extends StatefulWidget {
  const TemplateJeuPage({Key? key}) : super(key: key);

  @override
  _TemplateJeuPageState createState() => _TemplateJeuPageState();
}

class _TemplateJeuPageState extends State<TemplateJeuPage> {
  String selectedSection = 'Règles';

  @override
  Widget build(BuildContext context) {
    final gameId = Get.parameters['id'];
    final game = gamesList.firstWhere((g) => g['id'] == gameId);

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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          TagList(tags: game['tags']),
        ],
      );
    }

    // Section : Objectifs
    Widget buildObjectives() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: game['objectives']
            .map<Widget>((objective) => _buildBlueBlock(
                  title: objective['title'],
                  content: objective['content'],
                ))
            .toList(),
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
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  color: Colors.white, 
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBDFD2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                    child: Image.asset(
                      game['imagePath'],
                      fit: BoxFit.contain,
                      width: double.infinity,
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
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Temps de jeu
                  FutureBuilder<Map<String, dynamic>>(
                    future: context.read<PlaytimeManager>().getGameStats(game['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final stats = snapshot.data ?? {'duration': Duration.zero, 'playCount': 0};
                      final Duration totalTime = stats['duration'] as Duration;
                      final int playCount = stats['playCount'] as int;

                      String formattedTime = '';
                      if (totalTime.inHours > 0) {
                        formattedTime = '${totalTime.inHours}h${(totalTime.inMinutes % 60).toString().padLeft(2, '0')}';
                      } else if (totalTime.inMinutes > 0) {
                        formattedTime = '${totalTime.inMinutes} minutes';
                      } else {
                        formattedTime = '${totalTime.inSeconds} secondes';
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 8),
                          Text(formattedTime, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 24),
                          const Icon(Icons.games, size: 20),
                          const SizedBox(width: 8),
                          Text('$playCount parties', style: const TextStyle(fontSize: 24)),
                        ],
                      );
                    },
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
                          } else if (game['id'] == 'jeu-du-simon') {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => SimonGamePage()),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: ['Règles', 'Jeu', 'Troubles', 'Objectifs']
                        .map(
                          (section) => Padding(
                            padding: const EdgeInsets.only(right: 42.0), 
                            child: GestureDetector(
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
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (selectedSection == section)
                                    Container(
                                      height: 3,
                                      width: 60,
                                      color: Colors.black,
                                      margin: const EdgeInsets.only(top: 8),
                                    ),
                                ],
                              ),
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
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.black,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}