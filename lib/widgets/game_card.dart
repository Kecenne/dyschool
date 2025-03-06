import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import 'favorite_animation.dart';
import 'favorite_remove_popup.dart';
import 'tag_list.dart';
import '../theme/app_color.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String route;
  final String description;
  final List<String> tags;
  final String imagePath;
  final VoidCallback? onFavoriteRemove;
  final GlobalKey favoriteIconKey;
  final GlobalKey iconKey = GlobalKey();

  GameCard({
    Key? key,
    required this.title,
    required this.route,
    required this.description,
    required this.tags,
    required this.imagePath,
    required this.favoriteIconKey,
    this.onFavoriteRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed(route, arguments: {
          'title': title,
          'description': description,
          'tags': tags,
          'imagePath': imagePath,
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBDFD2),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      imagePath,
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 24.0), 

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.all(2.0), 
                            decoration: BoxDecoration(
                              color: const Color(0xFF9DBEC2), 
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              key: iconKey,
                              iconSize: 28.0,
                              icon: Icon(
                                favoriteController.isFavorite(title)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              color: favoriteController.isFavorite(title)
                                  ? Colors.red
                                  : Colors.white,
                              onPressed: () {
                                if (favoriteController.isFavorite(title)) {
                                  showRemoveFavoriteDialog(
                                    context: context,
                                    title: title,
                                    onConfirm: () {
                                      favoriteController.toggleFavorite(title);
                                    },
                                  );
                                } else {
                                  startFavoriteAnimation(iconKey, favoriteIconKey, context);
                                  favoriteController.toggleFavorite(title);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8.0),

                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textColor,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 40.0),

                    TagList(tags: tags),
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