import "package:flutter/material.dart";
import "package:get/get.dart";
import "../controllers/favorite_controller.dart";

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Jeux"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          GameCard(
            title: "Jeu de fou",
            route: "/jeu1",
            description:
                "C’est un jeu de cartes où le but est de collecter des ensembles de cartes représentant différentes familles. Les joueurs demandent des cartes spécifiques aux autres pour compléter leurs familles.",
            tags: ["Dyslexie", "Dyspraxie"],
            imagePath: "assets/images/placeholder.png",
          ),
          GameCard(
            title: "Jeu de zinzin",
            route: "/jeu1",
            description:
                "C’est un jeu de cartes où le but est de collecter des ensembles de cartes représentant différentes familles. Les joueurs demandent des cartes spécifiques aux autres pour compléter leurs familles.",
            tags: ["Dyslexie", "Dyspraxie"],
            imagePath: "assets/images/placeholder.png",
          ),
          GameCard(
            title: "Jeu de maso",
            route: "/jeu1",
            description:
                "C’est un jeu de cartes où le but est de collecter des ensembles de cartes représentant différentes familles. Les joueurs demandent des cartes spécifiques aux autres pour compléter leurs familles.",
            tags: ["Dyslexie", "Dyspraxie"],
            imagePath: "assets/images/placeholder.png",
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String route;
  final String description;
  final List<String> tags;
  final String imagePath;

  const GameCard({
    Key? key,
    required this.title,
    required this.route,
    required this.description,
    required this.tags,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  imagePath,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() => IconButton(
                              icon: Icon(
                                favoriteController.isFavorite(title)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              color: favoriteController.isFavorite(title)
                                  ? Colors.red
                                  : Colors.grey,
                              onPressed: () {
                                favoriteController.toggleFavorite(title);
                              },
                            )),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor: Colors.purple.shade100,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
