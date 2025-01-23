import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../data/games_data.dart';
import '../widgets/game_card.dart';
import '../widgets/favorite_remove_popup.dart';
import '../widgets/search_bar.dart' as custom_widgets;
import '../widgets/game_filters.dart';

class FavoritePageBody extends StatefulWidget {
  const FavoritePageBody({Key? key}) : super(key: key);

  @override
  _FavoritePageBodyState createState() => _FavoritePageBodyState();
}

class _FavoritePageBodyState extends State<FavoritePageBody> {
  final favoriteController = Get.find<FavoriteController>();
  final GlobalKey favoriteIconKey = GlobalKey();

  String searchQuery = "";
  String selectedTrouble = "";
  String selectedGameType = "";

  List<Map<String, dynamic>> get filteredFavoriteGames {
    final favoriteGames = gamesList.where((game) {
      return favoriteController.favoriteGames.contains(game["title"]);
    }).toList();

    return favoriteGames.where((game) {
      final matchesSearchQuery = game["title"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesTrouble = selectedTrouble.isEmpty ||
          game["tags"].contains(selectedTrouble);
      return matchesSearchQuery && matchesTrouble;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), 
      child: Column(
        children: [
          custom_widgets.SearchBar(
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          GameFilters(
            onTroubleChanged: (value) {
              setState(() {
                selectedTrouble = value ?? "";
              });
            },
            onGameTypeChanged: (value) {
              setState(() {
                selectedGameType = value ?? "";
              });
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(
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
                    children: filteredFavoriteGames
                        .map(
                          (game) => GameCard(
                            title: game["title"],
                            route: game["route"],
                            description: game["description"],
                            tags: game["tags"].cast<String>(),
                            imagePath: game["imagePath"],
                            favoriteIconKey: favoriteIconKey,
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
            ),
          ),
        ],
      ),
    );
  }
}