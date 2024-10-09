import 'package:flutter/material.dart';

class AnimatedHeart extends StatelessWidget {
  final Offset startPosition;
  final Offset endPosition;

  const AnimatedHeart({
    Key? key,
    required this.startPosition,
    required this.endPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: startPosition, end: endPosition),
      duration: const Duration(milliseconds: 500),
      builder: (context, Offset position, _) {
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: const Icon(
            Icons.favorite,
            size: 24,
            color: Colors.red,
          ),
        );
      },
    );
  }
}
