import "package:flutter/material.dart";
import "package:get/get.dart";
import "../controllers/favorite_controller.dart";
import "games_page.dart";

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoris"),
      ),
      body: Obx(
        () {
          if (favoriteController.favoriteGames.isEmpty) {
            return const Center(
              child: Text(
                "Vous n'avez aucun jeu favoris",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: favoriteController.favoriteGames
                  .map((title) => GameCard(
                        title: title,
                        route: "/jeu1",
                        description: "Description du jeu favori $title.",
                        tags: ["Dyslexie", "Dyspraxie"],
                        imagePath: "assets/images/placeholder.png",
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
