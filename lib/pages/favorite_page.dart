import 'package:flutter/material.dart';
import '../widgets/favorite_page_body.dart';
import '../widgets/page_header.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            PageHeader(title: "Favoris"),
            SizedBox(height: 16),
            Expanded(child: FavoritePageBody()),
          ],
        ),
      ),
    );
  }
}