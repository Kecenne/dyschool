import 'package:flutter/material.dart';
import 'game_reward_widget.dart';
import 'game_message_widget.dart';

class GameEndOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final String gameName;
  final dynamic result;
  final int playtime;
  final List<String> strengths;

  const GameEndOverlay({
    required this.message,
    required this.onRestart,
    required this.onQuit,
    required this.gameName,
    required this.result,
    required this.playtime,
    required this.strengths,
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
              color: Color(0xFF3A7D85),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A7D85),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: GameRewardWidget(gameName: gameName, result: result),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),

                // Temps de jeu
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "$playtime min",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Atouts
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: strengths.map((strength) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_up, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            strength,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                GameMessageWidget(gameName: gameName, result: result),
                const SizedBox(height: 30),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: onRestart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3A7D85),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Rejouer"),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: onQuit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.white, width: 2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Quitter"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}