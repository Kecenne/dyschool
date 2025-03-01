import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dyschool/controllers/favorite_controller.dart';

void main() {
  group('FavoriteController Tests', () {
    late FavoriteController favoriteController;

    setUp(() {
      favoriteController = FavoriteController();
    });

    test('Ajout d\'un jeu aux favoris', () {
      favoriteController.toggleFavorite('Chess');

      expect(favoriteController.favoriteGames.contains('Chess'), true);
    });

    test('Suppression d\'un jeu des favoris', () {
      favoriteController.toggleFavorite('Chess'); 
      favoriteController.toggleFavorite('Chess'); 

      expect(favoriteController.favoriteGames.contains('Chess'), false);
    });

    test('Vérification si un jeu est en favori', () {
      favoriteController.toggleFavorite('Checkers');

      expect(favoriteController.isFavorite('Checkers'), true);
      expect(favoriteController.isFavorite('Poker'), false);
    });

    test('Animation d\'ajout aux favoris', () async {
      const gameTitle = 'Go';
      const startOffset = Offset(100, 200);

      favoriteController.animateFavoriteIcon(gameTitle, startOffset);

      expect(favoriteController.animatedHeartPosition.value, startOffset);
      expect(favoriteController.showAnimatedHeart.value, true);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(favoriteController.animatedHeartPosition.value, const Offset(300, 750));

      await Future.delayed(const Duration(milliseconds: 600));
      expect(favoriteController.showAnimatedHeart.value, false);
      expect(favoriteController.isFavorite(gameTitle), true);
    });
  });
}