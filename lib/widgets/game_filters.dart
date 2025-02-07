import 'package:flutter/material.dart';

class GameFilters extends StatelessWidget {
  final String selectedTrouble;
  final String selectedGameType;
  final ValueChanged<String?> onTroubleChanged;
  final ValueChanged<String?> onGameTypeChanged;

  const GameFilters({
    Key? key,
    required this.selectedTrouble,
    required this.selectedGameType,
    required this.onTroubleChanged,
    required this.onGameTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFilterButton(
          label: selectedTrouble.isEmpty ? "Troubles" : selectedTrouble,
          selectedValue: selectedTrouble,
          onChanged: onTroubleChanged,
          items: [
            "",
            "Dyslexie",
            "Dyspraxie",
            "Dysorthographie",
            "Dysgraphie",
            "Dyscalculie",
            "Dysphasie",
            "Dyséxécutif"
          ],
        ),
        const SizedBox(width: 16.0),
        _buildFilterButton(
          label: selectedGameType.isEmpty ? "Type de jeux" : selectedGameType,
          selectedValue: selectedGameType,
          onChanged: onGameTypeChanged,
          items: [
            "",
            "Type 1",
            "Type 2",
            "Type 3"
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required String label,
    required String selectedValue,
    required ValueChanged<String?> onChanged,
    required List<String> items,
  }) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (context) => List.generate(items.length, (index) {
        final item = items[index];
        return PopupMenuItem(
          value: item,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: index.isEven
                  ? Colors.grey.shade200 
                  : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.isEmpty ? "Tous" : item,
                  style: const TextStyle(fontSize: 16.0),
                ),
                if (selectedValue == item)
                  const Icon(Icons.check, color: Color(0xFF6B9DA4)),
              ],
            ),
          ),
        );
      }),
      offset: const Offset(0, 60),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF6B9DA4),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list, color: Colors.white, size: 20),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}