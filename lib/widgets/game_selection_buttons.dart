import 'package:flutter/material.dart';

class GameSelectionButtons extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const GameSelectionButtons({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTabButton("Les jeux"),
        const SizedBox(width: 24),
        _buildTabButton("Favoris"),
        const SizedBox(width: 24),
        _buildTabButton("Mes jeux"),
      ],
    );
  }

  Widget _buildTabButton(String title) {
    final bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => onTabSelected(title),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 32.0, // Assure que la taille ne change pas
              fontWeight: FontWeight.w700,
              color: isSelected ? const Color(0xFF565656) : const Color(0xFFD6D6D6),
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: _calculateTextWidth(title, const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
              )),
              color: const Color(0xFF565656),
            ),
        ],
      ),
    );
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }
}