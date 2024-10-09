import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FavoriteController extends GetxController {
  var favoriteGames = <String>[].obs;
  var animatedHeartPosition = Offset.zero.obs;
  var showAnimatedHeart = false.obs;

  void toggleFavorite(String title) {
    if (favoriteGames.contains(title)) {
      favoriteGames.remove(title);
    } else {
      favoriteGames.add(title);
    }
  }

  bool isFavorite(String title) {
    return favoriteGames.contains(title);
  }

  void animateFavoriteIcon(String title, Offset startPosition) {
    animatedHeartPosition.value = startPosition;
    showAnimatedHeart.value = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      animatedHeartPosition.value = const Offset(300, 750);
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      showAnimatedHeart.value = false;
      toggleFavorite(title);
    });
  }
}
