import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medal_manager.dart';

class RewardGraph extends StatelessWidget {
  const RewardGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medalManager = Provider.of<MedalManager>(context);

    const int maxMedals = 90;
    double graphHeight = 250;

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
            color: const Color(0xFF6B9DA4), // ✅ Bleu-gris
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_left, size: 28, color: Colors.white), // ✅ Icône blanche
              Column(
                children: [
                  const Text(
                    "Tous",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // ✅ Texte blanc
                  ),
                  Text(
                    "${medalManager.goldMedals + medalManager.silverMedals + medalManager.bronzeMedals} hérissons",
                    style: const TextStyle(fontSize: 14, color: Colors.white70), // ✅ Texte gris clair
                  ),
                ],
              ),
              const Icon(Icons.arrow_right, size: 28, color: Colors.white), // ✅ Icône blanche
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Graphique à barres
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // ✅ Fond blanc
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: 300,
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
                    _buildMedalColumn("assets/images/rewards/Bronze.png", bronzeHeight),
                    _buildMedalColumn("assets/images/rewards/Silver.png", silverHeight),
                    _buildMedalColumn("assets/images/rewards/Gold.png", goldHeight),
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
          Text(label, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)), 
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        ],
      ),
    );
  }

  Widget _buildMedalColumn(String imagePath, double barHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF6B9DA4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(imagePath, width: 55, height: 55),
      ],
    );
  }
}