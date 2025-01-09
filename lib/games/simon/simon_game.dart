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
    final player = AudioPlayer();
    await player.play(AssetSource(sounds[colorIndex]));
  }

  void _nextRound() async {
    if (!mounted) return;

    setState(() {
      playerInput.clear();
      isAnimating = true;
      isPlayerTurn = false;
    });

    sequence.add(random.nextInt(4));

    if (currentLevel == 5 || currentLevel == 10 || currentLevel == 15) {
      speed = max(speed - 100, 300); 
    }

    for (int index in sequence) {
      await _flashColor(index); 
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
      currentColor = colorIndex; 
    });

    await _playSound(colorIndex);

    await Future.delayed(Duration(milliseconds: speed));
    if (!mounted) return;

    setState(() {
      currentColor = -1;
    });

    await Future.delayed(const Duration(milliseconds: 100)); 
  }

  void _handlePlayerInput(int colorIndex) async {
    if (!isPlayerTurn || isAnimating) return;

    if (!mounted) return;

    setState(() {
      currentColor = colorIndex; 
    });

    await _playSound(colorIndex);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    setState(() {
      currentColor = -1; 
    });

    if (playerInput.length >= sequence.length) return;

    playerInput.add(colorIndex);

    if (playerInput[playerInput.length - 1] != sequence[playerInput.length - 1]) {
      _showEndDialog("Perdu ! Vous avez atteint le niveau ${currentLevel + 1}.");
      return;
    }

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
          Text(
            "Niveau : ${currentLevel + 1}/20",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24.0),

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
                          ? colors[index] 
                          : Colors.grey[400], 
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                );
              },
            ),
          ),

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