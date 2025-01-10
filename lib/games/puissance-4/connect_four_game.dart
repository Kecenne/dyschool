import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme/app_color.dart';
import '../../widgets/game_end_overlay.dart';

class ConnectFourGamePage extends StatefulWidget {
  @override
  _ConnectFourGamePageState createState() => _ConnectFourGamePageState();
}

class _ConnectFourGamePageState extends State<ConnectFourGamePage> {
  static const int rows = 6;
  static const int cols = 7;

  List<List<String>> grid = List.generate(rows, (_) => List.filled(cols, ''));
  String currentPlayer = 'Orange';
  bool isGameOver = false;
  bool isTwoPlayer = false;
  String endMessage = '';
  bool showGameEndOverlay = false;

  @override
  void initState() {
    super.initState();
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

    for (int row = rows - 1; row >= 0; row--) {
      if (grid[row][col] == '') {
        setState(() {
          grid[row][col] = currentPlayer == 'Orange' ? 'X' : 'O';
        });
        if (checkVictory(row, col)) {
          _endGame('${currentPlayer} a gagné !');
        } else if (isGridFull()) {
          _endGame('Égalité !');
        } else {
          switchTurn();
        }
        break;
      }
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
    });
    _showGameModeDialog();
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
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
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
                        margin: const EdgeInsets.all(4),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isGameOver
                      ? 'Partie terminée !'
                      : isTwoPlayer
                          ? currentPlayer
                          : (currentPlayer == 'Orange' ? "Votre tour" : "Tour de l'ordinateur"),
                  style: const TextStyle(fontSize: 24),
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/main',
                  (route) => false,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}