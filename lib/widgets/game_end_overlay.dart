import 'package:flutter/material.dart';
import 'game_reward_widget.dart';

class GameEndOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final String gameName;
  final dynamic result;

  const GameEndOverlay({
    required this.message,
    required this.onRestart,
    required this.onQuit,
    required this.gameName,
    required this.result,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.5)),
        Positioned(
          bottom: 0, 
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)), 
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GameRewardWidget(gameName: gameName, result: result),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: onRestart, child: const Text("Rejouer")),
                    ElevatedButton(onPressed: onQuit, child: const Text("Quitter")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}