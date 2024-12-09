import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/search_bar.dart' as custom_widgets;
import '../widgets/game_filters.dart';
import '../widgets/game_selection_buttons.dart';
import '../widgets/game_list.dart';
import '../widgets/page_header.dart';
import '../controllers/favorite_controller.dart';
import '../data/games_data.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final favoriteController = Get.find<FavoriteController>();

  String searchQuery = "";
  String selectedTrouble = "";
  String selectedGameType = "";
  bool showFavoritesOnly = false;

  List<Map<String, dynamic>> get filteredGames {
    final gamesToShow = showFavoritesOnly
        ? gamesList.where((game) => favoriteController.favoriteGames.contains(game["title"])).toList()
        : gamesList;

    return gamesToShow.where((game) {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const PageHeader(title: "Liste des Jeux"),
            const SizedBox(height: 16),
            GameSelectionButtons(
              showFavoritesOnly: showFavoritesOnly,
              onShowAll: () {
                setState(() {
                  showFavoritesOnly = false;
                });
              },
              onShowFavorites: () {
                setState(() {
                  showFavoritesOnly = true;
                });
              },
            ),
            const SizedBox(height: 16),
            custom_widgets.SearchBar(
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Expanded(
              child: GameList(games: filteredGames),
            ),
          ],
        ),
      ),
    );
  }
}