import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../data/games_data.dart';
import '../widgets/game_card.dart';
import '../widgets/favorite_remove_popup.dart';

class FavoritePageBody extends StatelessWidget {
  const FavoritePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Obx(
      () {
        if (favoriteController.favoriteGames.isEmpty) {
          return const Center(
            child: Text(
              "Vous n'avez aucun jeu favoris",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        } else {
          final favoriteGames = gamesList
              .where((game) => favoriteController.favoriteGames.contains(game["title"]))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: favoriteGames
                .map(
                  (game) => GameCard(
                    title: game["title"],
                    route: game["route"],
                    description: game["description"],
                    tags: game["tags"].cast<String>(),
                    imagePath: game["imagePath"],
                    onFavoriteRemove: () {
                      showRemoveFavoriteDialog(
                        context: context,
                        title: game["title"],
                        onConfirm: () {
                          favoriteController.toggleFavorite(game["title"]);
                        },
                      );
                    },
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }
}
