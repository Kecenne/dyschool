import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favoriteGames = <String>[].obs;

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
}
