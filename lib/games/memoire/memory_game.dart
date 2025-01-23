import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/game_end_overlay.dart';
import '../../services/game_time_tracker.dart';
import 'package:provider/provider.dart';
import '../../services/playtime_manager.dart';

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<String> images = [
    'assets/images/memory-1.png',
    'assets/images/memory-2.png',
    'assets/images/memory-3.jpeg',
    'assets/images/memory-4.jpeg',
    'assets/images/memory-5.png',
    'assets/images/memory-6.png',
    'assets/images/memory-7.png',
    'assets/images/memory-8.jpeg',
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
    setState(() {
      timer?.cancel();
      showGameEndOverlay = true;
      endMessage = message;
    });
  }

  void resetGame() {
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
      setState(() {
        score++;
      });
      if (score == cardData.length ~/ 2) {
        endGame('Bravo ! Vous avez gagné.');
      }
    } else {
      setState(() {
        isProcessing = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

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
    if (_playtimeManager != null) {
      int minutesPlayed = (_elapsedSeconds / 60).ceil();
      Future.delayed(Duration.zero, () {
        _playtimeManager!.addPlaytime(minutesPlayed);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jeu de Mémoire"),
      ),
      body: Stack(
        children: [
          // Main game content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Temps restant : $timeLeft secondes',
                  style: const TextStyle(fontSize: 24),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: cardFlips[index]
                            ? Image.asset(cardData[index], fit: BoxFit.cover)
                            : const Center(
                                child: Text(
                                  "?",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Overlay
          if (showGameEndOverlay) ...[
            ModalBarrier(color: Colors.black.withOpacity(0.5)),
            GameEndOverlay(
              message: endMessage,
              onRestart: resetGame,
              onQuit: () {
                final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
                gameTimeTracker.stopTimer(context);
                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
              },
              gameName: 'Memory Game',
              result: 60 - timeLeft,
            ),
          ],
        ],
      ),
    );
  }
}