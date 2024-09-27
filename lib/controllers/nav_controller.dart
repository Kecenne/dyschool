import "package:get/get.dart";
import "package:flutter/material.dart";
import "../pages/progression_page.dart";
import "../pages/favorite_page.dart";
import "../pages/home_page.dart";
import "../pages/games_page.dart";
import "../pages/profile_page.dart";

class NavController extends GetxController {
  var selectedIndex = 2.obs;

  final List<Widget> pages = const [
    ProgressionPage(),
    FavoritePage(),
    HomePage(),
    GamesPage(),
    ProfilePage(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
