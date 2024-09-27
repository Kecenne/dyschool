import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Jeux"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          GameCard(title: "Jeu 1", route: "/jeu1"),
          GameCard(title: "Jeu 2", route: "/jeu1"),
          GameCard(title: "Jeu 3", route: "/jeu1"),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String route;

  const GameCard({Key? key, required this.title, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 20)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Get.toNamed(route);
        },
      ),
    );
  }
}
