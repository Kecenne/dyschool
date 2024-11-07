import 'package:flutter/material.dart';

class GameFilters extends StatelessWidget {
  final ValueChanged<String?> onTroubleChanged;
  final ValueChanged<String?> onGameTypeChanged;

  const GameFilters({
    Key? key,
    required this.onTroubleChanged,
    required this.onGameTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Type de troubles',
              border: OutlineInputBorder(),
            ),
            items: ["", "Dyslexie", "Dyspraxie", "Dysorthographie", "Dysgraphie", "Dyscalculie", "Dysphasie", "Dyséxécutif"]
                .map((trouble) => DropdownMenuItem(
                      value: trouble,
                      child: Text(
                          trouble.isEmpty ? "Tous les troubles" : trouble),
                    ))
                .toList(),
            onChanged: onTroubleChanged,
          ),
        ),
        const SizedBox(width: 16.0),

        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Type de jeux',
              border: OutlineInputBorder(),
            ),
            items: ["", "Type 1", "Type 2", "Type 3"]
                .map((gameType) => DropdownMenuItem(
                      value: gameType,
                      child: Text(
                          gameType.isEmpty ? "Tous les types" : gameType),
                    ))
                .toList(),
            onChanged: onGameTypeChanged,
          ),
        ),
      ],
    );
  }
}