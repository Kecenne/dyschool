import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final GlobalKey favoriteIconKey = GlobalKey(); 

  String searchQuery = "";
  String selectedTrouble = "";
  String selectedGameType = "";
  String selectedTab = "Les jeux";
  List<String> userTroubles = []; 

  @override
  void initState() {
    super.initState();
    _loadUserTroubles();
  }

Future<void> _loadUserTroubles() async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (userDoc.exists) {
    Map<String, dynamic>? userData = userDoc.data();
    if (userData != null && userData.containsKey("troubles")) {
      Map<String, dynamic> troublesMap = userData["troubles"];

      List<String> troubles = troublesMap.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();

      setState(() {
        userTroubles = troubles;
      });
    } 
    }
}


List<Map<String, dynamic>> get filteredGames {
  final List<Map<String, dynamic>> gamesToShow;

  if (selectedTab == "Favoris") {
    gamesToShow = gamesList.where((game) => favoriteController.favoriteGames.contains(game["title"])).toList();
  } else if (selectedTab == "Mes jeux") {
    gamesToShow = gamesList.where((game) {
      List<String> gameTagsLower = (game["tags"] as List<dynamic>).map((tag) => tag.toString().toLowerCase()).toList();
      List<String> userTroublesLower = userTroubles.map((trouble) => trouble.toLowerCase()).toList();

      bool match = gameTagsLower.any((tag) => userTroublesLower.contains(tag));
      return match;
    }).toList();

  } else {
    gamesToShow = gamesList;
  }

  return gamesToShow.where((game) {
    final matchesSearchQuery = game["title"].toLowerCase().contains(searchQuery.toLowerCase());
    final matchesTrouble = selectedTrouble.isEmpty || (game["tags"] as List<dynamic>).map((tag) => tag.toString()).contains(selectedTrouble);
    final matchesGameType = selectedGameType.isEmpty || (game["types"] as List).contains(selectedGameType);
    return matchesSearchQuery && matchesTrouble && matchesGameType;
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
            custom_widgets.SearchBar(
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 32),
            GameSelectionButtons(
              selectedTab: selectedTab,
              onTabSelected: (String tab) {
                setState(() {
                  selectedTab = tab;
                });
              },
            ),
            const SizedBox(height: 16),
            GameFilters(
              selectedTrouble: selectedTrouble, 
              selectedGameType: selectedGameType, 
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
            const SizedBox(height: 32),
            Expanded(
              child: GameList(
                games: filteredGames,
                favoriteIconKey: favoriteIconKey, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
