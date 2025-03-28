import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme/app_color.dart';
import '../../widgets/game_end_overlay.dart';
import '../../services/game_time_tracker.dart';
import 'package:provider/provider.dart';
import '../../services/playtime_manager.dart';
import '../../data/games_data.dart';


class ConnectFourGamePage extends StatefulWidget {
  @override
  _ConnectFourGamePageState createState() => _ConnectFourGamePageState();
}

class _ConnectFourGamePageState extends State<ConnectFourGamePage> {
  static const int rows = 6;
  static const int cols = 7;
  int playerMoveCount = 0;
  int computerMoveCount = 0; 

  List<List<String>> grid = List.generate(rows, (_) => List.filled(cols, ''));
  String currentPlayer = 'Orange';
  bool isGameOver = false;
  bool isTwoPlayer = false;
  String endMessage = '';
  bool showGameEndOverlay = false;

  GameTimeTracker? _timeTracker;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
    gameTimeTracker.startTimer();
    _showGameModeDialog();
  }

  void _showGameModeDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choisissez le mode de jeu'),
            content: const Text('Voulez-vous jouer contre un ordinateur ou un autre joueur ?'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isTwoPlayer = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Contre l\'ordinateur'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isTwoPlayer = true;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Contre un joueur'),
              ),
            ],
          );
        },
      );
    });
  }

  void dropPiece(int col) {
    if (isGameOver || grid[0][col] != '') return;

    int finalRow = -1;
    for (int row = rows - 1; row >= 0; row--) {
      if (grid[row][col] == '') {
        finalRow = row;
        break;
      }
    }

    if (finalRow == -1) return;

    _animateDrop(finalRow, col);
  }

  void _animateDrop(int finalRow, int col) async {
    for (int row = 0; row <= finalRow; row++) {
      setState(() {
        grid[row][col] = currentPlayer == 'Orange' ? 'X' : 'O';
      });
      await Future.delayed(const Duration(milliseconds: 100));
      if (row != finalRow) {
        setState(() {
          grid[row][col] = '';
        });
      }
    }

    setState(() {
      grid[finalRow][col] = currentPlayer == 'Orange' ? 'X' : 'O';

      if (currentPlayer == 'Orange') {
        playerMoveCount++;
      } else if (!isTwoPlayer && currentPlayer == 'Computer') {
        computerMoveCount++;
      } else if (isTwoPlayer && currentPlayer == 'Bleu') {
        playerMoveCount++;
      }
    });

    if (checkVictory(finalRow, col)) {
      _endGame('$currentPlayer a gagné en $playerMoveCount coups !');
    } else if (isGridFull()) {
      _endGame('Égalité !');
    } else {
      switchTurn();
    }
  }


  void switchTurn() {
    if (isTwoPlayer) {
      currentPlayer = currentPlayer == 'Orange' ? 'Bleu' : 'Orange';
    } else {
      if (currentPlayer == 'Orange') {
        currentPlayer = 'Computer';
        Future.delayed(const Duration(milliseconds: 500), () {
          computerMove();
        });
      } else {
        currentPlayer = 'Orange';
      }
    }
  }

  void computerMove() {
    if (isGameOver) return;

    Random random = Random();
    int col;
    do {
      col = random.nextInt(cols);
    } while (grid[0][col] != '');

    dropPiece(col);
  }

  bool isGridFull() {
    return grid[0].every((cell) => cell != '');
  }

  bool checkVictory(int row, int col) {
    String symbol = grid[row][col];
    return checkDirection(row, col, 1, 0, symbol) || // Horizontal
        checkDirection(row, col, 0, 1, symbol) || // Vertical
        checkDirection(row, col, 1, 1, symbol) || // Diagonal /
        checkDirection(row, col, 1, -1, symbol); // Diagonal \
  }

  bool checkDirection(int row, int col, int dRow, int dCol, String symbol) {
    int count = 1;
    for (int i = 1; i < 4; i++) {
      int newRow = row + i * dRow;
      int newCol = col + i * dCol;
      if (newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols || grid[newRow][newCol] != symbol) {
        break;
      }
      count++;
    }
    for (int i = 1; i < 4; i++) {
      int newRow = row - i * dRow;
      int newCol = col - i * dCol;
      if (newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols || grid[newRow][newCol] != symbol) {
        break;
      }
      count++;
    }
    return count >= 4;
  }

  void _endGame(String message) {
    setState(() {
      isGameOver = true;
      endMessage = message;
      showGameEndOverlay = true;
    });
  }

  void resetGame() {
    setState(() {
      grid = List.generate(rows, (_) => List.filled(cols, ''));
      currentPlayer = 'Orange';
      isGameOver = false;
      showGameEndOverlay = false;
      playerMoveCount = 0;
      computerMoveCount = 0;
    });
    _showGameModeDialog();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timeTracker ??= Provider.of<GameTimeTracker>(context, listen: false);
  }

  @override
  void dispose() {
    if (_timeTracker != null) {
      List<String> gameTypes = _getGameTypes("Puissance 4");
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puissance 4'),
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
                    isGameOver
                        ? 'Partie terminée !'
                        : isTwoPlayer
                            ? "Tour de $currentPlayer"
                            : (currentPlayer == 'Orange' ? "Votre tour" : "Tour de l'ordinateur"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 8.0, 
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: rows * cols,
                    itemBuilder: (context, index) {
                      int row = index ~/ cols;
                      int col = index % cols;
                      return GestureDetector(
                        onTap: () {
                          if ((currentPlayer == 'Orange' || (isTwoPlayer && currentPlayer == 'Bleu')) &&
                              !showGameEndOverlay) {
                            dropPiece(col);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: grid[row][col] == ''
                                ? Colors.grey[300]
                                : (grid[row][col] == 'X'
                                    ? AppColors.orangeColor
                                    : AppColors.blueColor),
                          ),
                        ),
                      );
                    },
                  ),
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

                List<String> gameTypes = _getGameTypes("Puissance 4");
                gameTimeTracker.stopTimer(context, gameTypes);

                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
              },
              gameName: 'Connect Four',
              result: playerMoveCount,
              playtime: _timeTracker?.elapsedSeconds ?? 0,
              strengths: ["Prise de décision", "Mémoire visuelle", "Concentration"],
            ),
          ],
        ],
      ),
    );
  }
}