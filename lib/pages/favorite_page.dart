import 'package:flutter/material.dart';
import '../widgets/favorite_page_body.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoris"),
      ),
      body: const FavoritePageBody(),
    );
  }
}
