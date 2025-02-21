import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmallGameCard extends StatelessWidget {
  final String imagePath;
  final String route;

  const SmallGameCard({
    Key? key,
    required this.imagePath,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.35;

    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        color: const Color(0xFFFBDFD2), // Fond de la carte modifié
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            width: cardWidth,
            height: cardWidth,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
