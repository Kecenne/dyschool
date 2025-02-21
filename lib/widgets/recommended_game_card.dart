import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedGameCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String route;

  const RecommendedGameCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.6;

    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(imagePath, width: cardWidth, height: cardWidth, fit: BoxFit.cover),
              Container(
                width: cardWidth,
                height: cardWidth,
                color: Colors.black.withOpacity(0.5),
              ),

              Positioned(
                bottom: 8,
                left: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}