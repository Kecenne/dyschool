import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assure-toi d'importer Get pour la navigation

class SmallGameCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String route; // Ajoute la route pour la navigation

  const SmallGameCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.45;

    return GestureDetector(
      onTap: () {
        Get.toNamed(route); 
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: Container(
          width: cardWidth,
          height: cardWidth,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: cardWidth * 0.40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
