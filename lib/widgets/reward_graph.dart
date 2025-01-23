import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medal_manager.dart';

class RewardGraph extends StatelessWidget {
  const RewardGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medalManager = Provider.of<MedalManager>(context);

    const int maxMedals = 90; // Échelle max du graphique
    double graphHeight = 250; // 🔥 Augmenté pour être plus visible

    double goldHeight = (medalManager.goldMedals / maxMedals) * graphHeight;
    double silverHeight = (medalManager.silverMedals / maxMedals) * graphHeight;
    double bronzeHeight = (medalManager.bronzeMedals / maxMedals) * graphHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Récompenses",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Bloc "Tous" + flèches + nombre de médailles
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_left, size: 28, color: Colors.black.withOpacity(0.6)), // Flèche gauche
              Column(
                children: [
                  const Text(
                    "Tous",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${medalManager.goldMedals + medalManager.silverMedals + medalManager.bronzeMedals} hérissons",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              Icon(Icons.arrow_right, size: 28, color: Colors.black.withOpacity(0.6)), // Flèche droite
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Graphique à barres
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: 300, // 🔥 Augmenté
          child: Stack(
            children: [
              // Lignes de repère
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGraphLine("90"),
                    _buildGraphLine("60"),
                    _buildGraphLine("30"),
                    _buildGraphLine("0"),
                  ],
                ),
              ),

              // Barres du graphique
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMedalColumn("assets/images/rewards/Gold.png", goldHeight),
                    _buildMedalColumn("assets/images/rewards//Silver.png", silverHeight),
                    _buildMedalColumn("assets/images/rewards//Bronze.png", bronzeHeight),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGraphLine(String label) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildMedalColumn(String imagePath, double barHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50, // 🔥 Légèrement agrandi
          height: barHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(imagePath, width: 55, height: 55), // 🔥 Médailles un peu plus grandes
      ],
    );
  }
}