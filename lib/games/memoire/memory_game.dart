import 'dart:async';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    List<String> tempImages = List.from(images);
    images.addAll(tempImages);
    images.shuffle();

    if (images.isEmpty) {
      throw Exception("La liste des images est vide. Vérifie les chemins des fichiers.");
    }

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
          showEndDialog('Temps écoulé ! Réessayez.');
        }
      });
    });
  }

  void showEndDialog(String message) {
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
              resetGame();
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


  void resetGame() {
    setState(() {
      cardFlips = List<bool>.filled(cardData.length, false);
      images.shuffle();
      score = 0;
      timeLeft = 60;
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
        timer?.cancel();
        showEndDialog('Bravo ! Vous avez gagné.');
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jeu de Mémoire"),
      ),
      body: Column(
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
                    if (isProcessing || cardFlips[index] || selectedCards.length >= 2) {
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
    );
  }
}
