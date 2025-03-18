import 'dart:async';
import 'dart:math';
import 'package:dyschool/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../widgets/game_end_overlay.dart';
import '../../services/game_time_tracker.dart';
import 'package:provider/provider.dart';
import '../../services/playtime_manager.dart';
import '../../data/games_data.dart';


class SimonGamePage extends StatefulWidget {
  @override
  _SimonGamePageState createState() => _SimonGamePageState();
}

class _SimonGamePageState extends State<SimonGamePage> {
  final List<Color> colors = [AppColors.vifblueColor, AppColors.orangeColor, AppColors.lightPink, AppColors.blueColor];
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
  bool showGameEndOverlay = false;
  String endMessage = '';

  GameTimeTracker? _timeTracker;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
    gameTimeTracker.startTimer();
    _timeTracker = gameTimeTracker;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showReadyDialog();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timeTracker = Provider.of<GameTimeTracker>(context, listen: false);
  }

  @override
  void dispose() {
    if (_timeTracker != null) {
      List<String> gameTypes = _getGameTypes("Jeu du Simon");
      _timeTracker!.stopTimer(context, gameTypes);
    }
    super.dispose();
  }


  List<String> _getGameTypes(String gameTitle) {
    final game = gamesList.firstWhere(
      (g) => g["title"] == gameTitle,
      orElse: () => {"types": []}, 
    );

    return List<String>.from(game["types"] ?? []);
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
      showGameEndOverlay = false;
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
    if (!isPlayerTurn || isAnimating || showGameEndOverlay) return;

    setState(() {
      currentColor = colorIndex;
    });

    await _playSound(colorIndex);

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      currentColor = -1;
    });

    if (playerInput.length >= sequence.length) return;

    playerInput.add(colorIndex);

    if (playerInput[playerInput.length - 1] != sequence[playerInput.length - 1]) {
      _endGame("Perdu ! Vous avez atteint le niveau ${currentLevel + 1}.");
      return;
    }

    if (playerInput.length == sequence.length) {
      if (currentLevel == 19) {
        _endGame("Bravo ! Vous avez terminé les 20 manches !");
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

  void _endGame(String message) {
    setState(() {
      endMessage = message;
      showGameEndOverlay = true;
    });
  }

  Widget _buildMessageContainer(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simon"),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMessageContainer(
                "Niveau : ${currentLevel + 1}/20\n" +
                (isPlayerTurn
                    ? "C'est à vous de jouer !"
                    : "Regardez et mémorisez la séquence.")
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
              const SizedBox(height: 24.0),
            ],
          ),
          if (showGameEndOverlay) ...[
            ModalBarrier(color: Colors.black.withOpacity(0.5)),
            GameEndOverlay(
              message: endMessage,
              onRestart: _startGame,
              onQuit: () {
                final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);

                List<String> gameTypes = _getGameTypes("Jeu du Simon");
                gameTimeTracker.stopTimer(context, gameTypes);

                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
              },
              gameName: 'Simon',
              result: currentLevel + 1,
              playtime: _timeTracker?.elapsedSeconds ?? 0,
              strengths: ["Prise de décision", "Mémoire visuelle", "Concentration"],
            ),
          ],
        ],
      ),
    );
  }


}