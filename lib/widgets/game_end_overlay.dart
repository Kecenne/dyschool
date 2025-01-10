import 'package:flutter/material.dart';

class GameEndOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const GameEndOverlay({
    Key? key,
    required this.message,
    required this.onRestart,
    required this.onQuit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.75,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onRestart,
                  child: const Text('Recommencer'),
                ),
                ElevatedButton(
                  onPressed: onQuit,
                  child: const Text('Quitter'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}