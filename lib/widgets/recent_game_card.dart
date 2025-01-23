import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              Image.asset(imagePath, width: double.infinity, height: 450, fit: BoxFit.cover),
              Container(
                width: double.infinity,
                height: 450,
                color: Colors.black.withOpacity(0.4), 
              ),

              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
                ),
              ),

              Positioned(
                bottom: 12,
                left: 12,
                child: Wrap(
                  spacing: 8.0,
                  children: tags.map((tag) => Chip(label: Text(tag, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.black54)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}