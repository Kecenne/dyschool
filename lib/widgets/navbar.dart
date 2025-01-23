import "package:flutter/material.dart";
import "package:get/get.dart";
import "../controllers/nav_controller.dart";
import '../theme/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final GlobalKey favoriteIconKey;

  const CustomBottomNavBar({Key? key, required this.favoriteIconKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavController());

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(29),
        topRight: Radius.circular(29),
      ),
      child: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.density_medium_outlined),
              label: "Progression",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, key: favoriteIconKey, size: 30),
              label: "Favoris",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: "Jouer",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset, size: 30),
              label: "Jeux",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 30),
              label: "Profil",
            ),
          ],
          currentIndex: navController.selectedIndex.value,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          selectedFontSize: 20,
          unselectedFontSize: 20,
          onTap: navController.onItemTapped,
        ),
      ),
    );
  }
}