import 'package:flutter/material.dart';
import 'animated_heart.dart';

void startFavoriteAnimation(GlobalKey iconKey, GlobalKey favoriteIconKey, BuildContext context) { // ✅ Accept favoriteIconKey as a parameter
  final overlay = Overlay.of(context);
  final iconBox = iconKey.currentContext?.findRenderObject() as RenderBox?;
  final navBox = favoriteIconKey.currentContext?.findRenderObject() as RenderBox?;

  if (iconBox != null && navBox != null) {
    final iconPosition = iconBox.localToGlobal(Offset.zero);
    final navPosition = navBox.localToGlobal(Offset.zero);

    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return AnimatedHeart(
          startPosition: iconPosition,
          endPosition: navPosition,
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 500), () {
      entry.remove();
    });
  }
}