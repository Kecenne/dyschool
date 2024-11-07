import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class GameSelectionButtons extends StatelessWidget {
  final bool showFavoritesOnly;
  final VoidCallback onShowAll;
  final VoidCallback onShowFavorites;

  const GameSelectionButtons({
    Key? key,
    required this.showFavoritesOnly,
    required this.onShowAll,
    required this.onShowFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onShowAll,
          style: ElevatedButton.styleFrom(
            backgroundColor: showFavoritesOnly
                ? AppColors.backgroundColor
                : AppColors.primaryColor,
            foregroundColor: showFavoritesOnly
                ? AppColors.primaryColor
                : AppColors.backgroundColor,
            side: const BorderSide(color: AppColors.primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            "Tous les jeux",
            style: TextStyle(
              color: showFavoritesOnly
                  ? AppColors.primaryColor
                  : AppColors.backgroundColor,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onShowFavorites,
          style: ElevatedButton.styleFrom(
            backgroundColor: showFavoritesOnly
                ? AppColors.primaryColor
                : AppColors.backgroundColor,
            foregroundColor: showFavoritesOnly
                ? AppColors.backgroundColor
                : AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            "Favoris",
            style: TextStyle(
              color: showFavoritesOnly
                  ? AppColors.backgroundColor
                  : AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}