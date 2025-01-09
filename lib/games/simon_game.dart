import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SimonGamePage extends StatefulWidget {
  @override
  _SimonGamePageState createState() => _SimonGamePageState();
}

class _SimonGamePageState extends State<SimonGamePage> {
  final List<Color> colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
  final List<String> sounds = [
    "audio/simon/simon_rouge.mp3",
    "audio/simon/simon_vert.mp3",
    "audio/simon/simon_bleu.mp3",
    "audio/simon/simon_jaune.mp3"
  ];
  final Random random = Random();

  List<int> sequence = [];
  List<int> playerInput = [];
  int currentLevel = 0;
  bool isPlayerTurn = false;
  bool isAnimating = false;
  int speed = 800;
  int currentColor = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showReadyDialog();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showReadyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Prêt à jouer ?"),
        content: const Text("Appuyez sur 'Commencer' pour démarrer la partie."),
        actions: [
          TextButton(
            child: const Text("Commencer"),
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
          ),
        ],
      ),
    );
  }

  void _startGame() {
    setState(() {
      currentLevel = 0;
      sequence = [];
      playerInput = [];
      isPlayerTurn = false;
      _nextRound();
    });
  }

  Future<void> _playSound(int colorIndex) async {
    final player = AudioPlayer(); // Nouvelle instance pour chaque son
    await player.play(AssetSource(sounds[colorIndex]));
  }

  void _nextRound() async {
    if (!mounted) return;

    setState(() {
      playerInput.clear();
      isAnimating = true;
      isPlayerTurn = false;
    });

    // Add a new random color to the sequence
    sequence.add(random.nextInt(4));

    // Increase speed at certain levels
    if (currentLevel == 5 || currentLevel == 10 || currentLevel == 15) {
      speed = max(speed - 100, 300); // Reduce display time
    }

    // Animate the sequence
    for (int index in sequence) {
      await _flashColor(index); // Flash color and play sound
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      isAnimating = false;
      isPlayerTurn = true;
    });
  }

  Future<void> _flashColor(int colorIndex) async {
    if (!mounted) return;

    setState(() {
      currentColor = colorIndex; // Highlight the color
    });

    await _playSound(colorIndex); // Play sound at the same time

    await Future.delayed(Duration(milliseconds: speed)); // Wait for the flash duration
    if (!mounted) return;

    setState(() {
      currentColor = -1; // Reset the color
    });

    await Future.delayed(const Duration(milliseconds: 100)); // Pause between flashes
  }

  void _handlePlayerInput(int colorIndex) async {
    if (!isPlayerTurn || isAnimating) return;

    if (!mounted) return;

    setState(() {
      currentColor = colorIndex; // Highlight button briefly
    });

    await _playSound(colorIndex); // Play sound for the player's click

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    setState(() {
      currentColor = -1; // Reset button highlight
    });

    // Prevent invalid access
    if (playerInput.length >= sequence.length) return;

    playerInput.add(colorIndex);

    // Check if the player's input is correct
    if (playerInput[playerInput.length - 1] != sequence[playerInput.length - 1]) {
      _showEndDialog("Perdu ! Vous avez atteint le niveau ${currentLevel + 1}.");
      return;
    }

    // If the player completes the sequence
    if (playerInput.length == sequence.length) {
      if (currentLevel == 19) {
        _showEndDialog("Bravo ! Vous avez terminé les 20 manches !");
      } else {
        setState(() {
          currentLevel++;
          isPlayerTurn = false;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) _nextRound();
      }
    }
  }

  void _showEndDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('Recommencer'),
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
          ),
          TextButton(
            child: const Text('Quitter'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simon"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display level
          Text(
            "Niveau : ${currentLevel + 1}/20",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24.0),

          // Game board
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handlePlayerInput(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: currentColor == index
                          ? colors[index] // Highlight color
                          : Colors.grey[400], // Default color
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                );
              },
            ),
          ),

          // Instructions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isPlayerTurn ? "C'est à vous de jouer !" : "Regardez et mémorisez la séquence.",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}