import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/tag_list.dart'; // Assurez-vous que le chemin est correct
import '../controllers/game_history_controller.dart';

class RecentGameCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final List<String> tags;
  final String route;

  const RecentGameCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.tags,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final gameHistoryController = Get.find<GameHistoryController>();
        gameHistoryController.addGameToHistory(route);
        Get.toNamed(route);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 450,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                height: 450,
                color: Colors.black.withOpacity(0.5),
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: TagList(tags: tags),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
