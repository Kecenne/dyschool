import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import 'favorite_animation.dart';
import 'favorite_remove_popup.dart';
import 'tag_list.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String route;
  final String description;
  final List<String> tags;
  final String imagePath;
  final VoidCallback? onFavoriteRemove;
  final GlobalKey favoriteIconKey; 

  const GameCard({
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
    final GlobalKey iconKey = GlobalKey(); 

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
                borderRadius: BorderRadius.circular(22.0),
                child: Image.asset(
                  imagePath,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
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
                              key: iconKey, 
                              icon: Icon(
                                favoriteController.isFavorite(title)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              color: favoriteController.isFavorite(title)
                                  ? Colors.red
                                  : Colors.grey,
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