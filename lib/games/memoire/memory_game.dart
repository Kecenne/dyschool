import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/game_end_overlay.dart';
import '../../services/game_time_tracker.dart';
import 'package:provider/provider.dart';
import '../../services/playtime_manager.dart';
import '../../data/games_data.dart';

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<String> images = [
    'assets/images/memory/memory-carte-1.png',
    'assets/images/memory/memory-carte-2.png',
    'assets/images/memory/memory-carte-3.png',
    'assets/images/memory/memory-carte-4.png',
    'assets/images/memory/memory-carte-5.png',
    'assets/images/memory/memory-carte-6.png',
    'assets/images/memory/memory-carte-7.png',
    'assets/images/memory/memory-carte-8.png',
  ];

  List<bool> cardFlips = [];
  List<String> cardData = [];
  List<int> selectedCards = [];
  int score = 0;
  int timeLeft = 60;
  Timer? timer;
  bool isProcessing = false;
  bool showGameEndOverlay = false;
  String endMessage = '';

  PlaytimeManager? _playtimeManager;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
    gameTimeTracker.startTimer();
    
    List<String> tempImages = List.from(images);
    images.addAll(tempImages);
    images.shuffle();

    cardData = List<String>.from(images);
    cardFlips = List<bool>.filled(cardData.length, false);

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; 
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          endGame('Temps écoulé ! Réessayez.');
        }
      });
    });
  }

  void endGame(String message) {
    if (!mounted) return;
    setState(() {
      timer?.cancel();
      showGameEndOverlay = true;
      endMessage = message;
    });
  }

  void resetGame() {
    if (!mounted) return;
    setState(() {
      cardFlips = List<bool>.filled(cardData.length, false);
      images.shuffle();
      score = 0;
      timeLeft = 60;
      showGameEndOverlay = false;
      startTimer();
    });
  }

  void checkMatch() async {
    if (selectedCards.length < 2) return;

    if (cardData[selectedCards[0]] == cardData[selectedCards[1]]) {
      if (!mounted) return;
      setState(() {
        score++;
      });
      if (score == cardData.length ~/ 2) {
        endGame('Bravo ! Vous avez gagné.');
      }
    } else {
      if (!mounted) return;
      setState(() {
        isProcessing = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      setState(() {
        cardFlips[selectedCards[0]] = false;
        cardFlips[selectedCards[1]] = false;
        isProcessing = false;
      });
    }
    selectedCards.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playtimeManager ??= Provider.of<PlaytimeManager>(context, listen: false);
  }

  @override
  void dispose() {
    timer?.cancel(); 
    if (_playtimeManager != null) {
      int minutesPlayed = (_elapsedSeconds / 60).ceil();

      List<String> gameTypes = _getGameTypes("Jeu de mémoire");

      Future.delayed(Duration.zero, () {
        if (mounted) {
          _playtimeManager!.addPlaytime(minutesPlayed, gameTypes);
        }
      });
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jeu de Mémoire"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
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
                    'Temps restant : $timeLeft secondes',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (isProcessing ||
                            cardFlips[index] ||
                            selectedCards.length >= 2 ||
                            showGameEndOverlay) {
                          return;
                        }

                        setState(() {
                          cardFlips[index] = true;
                          selectedCards.add(index);

                          if (selectedCards.length == 2) {
                            checkMatch();
                          }
                        });
                      },
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween<double>(
                          begin: cardFlips[index] ? 0 : 1,
                          end: cardFlips[index] ? 1 : 0,
                        ),
                        builder: (context, value, child) {
                          final isFront = value >= 0.5;

                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(value * 3.14),
                            child: isFront
                                ? Image.asset(cardData[index], fit: BoxFit.cover)
                                : Image.asset(
                                    'assets/images/memory/memory-returned-card.png',
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          if (showGameEndOverlay) ...[
            ModalBarrier(color: Colors.black.withOpacity(0.5)),
            GameEndOverlay(
              message: endMessage,
              onRestart: resetGame,
              onQuit: () {
                final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);

                List<String> gameTypes = _getGameTypes("Jeu de mémoire");
                gameTimeTracker.stopTimer(context, gameTypes);

                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
              },
              gameName: 'Memory Game',
              result: 60 - timeLeft,
              playtime: (_elapsedSeconds / 60).ceil(),
              strengths: ["Prise de décision", "Mémoire visuelle", "Concentration"],
            ),
          ],
        ],
      ),
    );
  }
}