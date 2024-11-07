import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

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
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Temps de Jeu"),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: Center(child: Text("Graphique Placeholder")),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("AUJOURD'HUI"),
                        Text("6 MIN"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("7 DERNIERS JOURS"),
                        Text("76 MIN"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Récompenses
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back),
                        Text("Tous"),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: Center(child: Text("Hérissons Placeholder")),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Statistiques
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Statistiques"),
                        DropdownButton<String>(
                          hint: const Text("Choix du mois"),
                          items: <String>["Janvier", "Février", "Mars", "Avril", "Mai"]
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatItem("Casse-tête", "85 MIN ET 54 SECONDES"),
                    _buildStatItem("Aventure", "32 MIN ET 23 SECONDES"),
                    _buildStatItem("Mémoire", "10 SECONDES"),
                    _buildStatItem("Jeux de plateau", "1 HEURE 25 MINUTES ET 30 SECONDES"),
                    _buildStatItem("Jeux - Disgraphie", "45 MIN ET 14 SECONDES"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(time),
                ],
              ),
              const SizedBox(
                width: 100,
                height: 50,
                child: Center(child: Text("Graphique")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}