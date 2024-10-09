import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../games/memory_game.dart';

class TemplateJeuPage extends StatefulWidget {
  const TemplateJeuPage({Key? key}) : super(key: key);

  @override
  _TemplateJeuPageState createState() => _TemplateJeuPageState();
}

class _TemplateJeuPageState extends State<TemplateJeuPage> {
  String selectedSection = 'Règles';

  final Map<String, Widget> sectionContents = {
    'Règles': Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBlueBlock(
            title: "Règles",
            content:
                "Les troubles d'apprentissage incluent la dyslexie, la dyscalculie, et d'autres difficultés. "
                "Ce jeu peut être adapté pour aider à travailler sur ces troubles par des exercices spécifiques.",
          ),
          const SizedBox(height: 16.0),
          _buildBlueBlock(
            title: "Adaptations",
            content:
                "Pour rendre le jeu accessible, différentes adaptations sont possibles : "
                "polices lisibles, énoncés simplifiés, et consignes adaptées aux capacités de chaque joueur.",
          ),
        ],
      ),
    ),
    'Jeu': Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBlueBlock(
            title: "Jeu",
            content:
                "Les troubles d'apprentissage incluent la dyslexie, la dyscalculie, et d'autres difficultés. "
                "Ce jeu peut être adapté pour aider à travailler sur ces troubles par des exercices spécifiques.",
          ),
        ],
      ),
    ),
    'Troubles': Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBlueBlock(
            title: "Troubles",
            content:
                "Les troubles d'apprentissage incluent la dyslexie, la dyscalculie, et d'autres difficultés. "
                "Ce jeu peut être adapté pour aider à travailler sur ces troubles par des exercices spécifiques.",
          ),
        ],
      ),
    ),
    'Objectifs': Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBlueBlock(
            title: "Objectifs",
            content:
                "Les troubles d'apprentissage incluent la dyslexie, la dyscalculie, et d'autres difficultés. "
                "Ce jeu peut être adapté pour aider à travailler sur ces troubles par des exercices spécifiques.",
          ),
        ],
      ),
    ),
  };

  static Widget _buildBlueBlock({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
      width: double.infinity,
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
                fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.backgroundColor),
          ),
          const SizedBox(height: 16.0),
          Text(
            content,
            style: const TextStyle(fontSize: 18, height: 1.5, color: AppColors.backgroundColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/placeholder.png'),
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
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    child: IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.black, size: 28),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Détails du Jeu 1",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24.0),
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
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MemoryGamePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text("JOUER", style: TextStyle(fontSize: 20, color: AppColors.backgroundColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36.0),
                  const Text(
                    "Explication du jeu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    "Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada. "
                    "Mauris non libero suscipit, tincidunt erat a, consequat libero. Curabitur eget commodo purus. "
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                  const SizedBox(height: 36.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: sectionContents.keys.map((section) {
                      return GestureDetector(
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
                                fontWeight: selectedSection == section ? FontWeight.bold : FontWeight.normal,
                                color: selectedSection == section ? Colors.deepPurple : Colors.black,
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
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    width: double.infinity,
                    child: sectionContents[selectedSection]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
