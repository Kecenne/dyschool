import "package:flutter/material.dart";
import "package:get/get.dart";
import "../controllers/nav_controller.dart";

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.density_medium_outlined),
              label: "Progression",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30),
              label: "Favoris",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: "Jouer",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset, size: 30),
              label: "Jeux",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 30),
              label: "Profil",
            ),
          ],
          currentIndex: navController.selectedIndex.value,
          selectedItemColor: Colors.deepPurple,
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
