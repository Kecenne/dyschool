import 'dart:math';
import 'package:flutter/material.dart';

class SevenFamilyGamePage extends StatefulWidget {
  @override
  _SevenFamilyGamePageState createState() => _SevenFamilyGamePageState();
}

class _SevenFamilyGamePageState extends State<SevenFamilyGamePage> {
  final List<String> familyMembers = ['Fils', 'Fille', 'Père', 'Mère', 'Grand-Mère', 'Grand-Père'];
  final List<String> families = ['Famille A', 'Famille B', 'Famille C', 'Famille D', 'Famille E', 'Famille F', 'Famille G'];

  List<String> deck = [];
  List<String> userDeck = [];
  List<String> leftDeck = [];
  List<String> topDeck = [];
  List<String> rightDeck = [];
  List<String> drawPile = [];

  String selectedFamily = 'Famille A';
  String selectedCharacter = 'Fils';
  String currentPlayer = 'User'; 
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    deck = [];
    for (var family in families) {
      for (var member in familyMembers) {
        deck.add('$family - $member');
      }
    }

    deck.shuffle();

    userDeck = deck.sublist(0, 6);
    leftDeck = deck.sublist(6, 12);
    topDeck = deck.sublist(12, 18);
    rightDeck = deck.sublist(18, 24);

    drawPile = deck.sublist(24);

    setState(() {
      statusMessage = 'Votre tour de jouer !';
    });
  }

  void nextTurn() {
    setState(() {
      if (currentPlayer == 'User') {
        currentPlayer = 'Left';
        statusMessage = "C'est au tour de l'ordinateur de gauche de jouer...";
      } else if (currentPlayer == 'Left') {
        currentPlayer = 'Top';
        statusMessage = "C'est au tour de l'ordinateur du haut de jouer...";
      } else if (currentPlayer == 'Top') {
        currentPlayer = 'Right';
        statusMessage = "C'est au tour de l'ordinateur de droite de jouer...";
      } else {
        currentPlayer = 'User';
        statusMessage = 'Votre tour de jouer !';
      }
    });
  }

  void computerPlay(String player) {
    String family = families[Random().nextInt(families.length)];
    String member = familyMembers[Random().nextInt(familyMembers.length)];
    String targetCard = '$family - $member';

    String opponent = ['User', 'Left', 'Top', 'Right'][Random().nextInt(4)];
    while (opponent == player) {
      opponent = ['User', 'Left', 'Top', 'Right'][Random().nextInt(4)];
    }

    handleComputerRequest(player, opponent, targetCard);
  }

  void handleComputerRequest(String player, String opponent, String card) {
    setState(() {
      List<String> opponentDeck;
      if (opponent == 'User') {
        opponentDeck = userDeck;
      } else if (opponent == 'Left') {
        opponentDeck = leftDeck;
      } else if (opponent == 'Top') {
        opponentDeck = topDeck;
      } else {
        opponentDeck = rightDeck;
      }

      if (opponentDeck.contains(card)) {
        statusMessage = "$player a pris $card à $opponent !";
        opponentDeck.remove(card);
        if (player == 'Left') leftDeck.add(card);
        if (player == 'Top') topDeck.add(card);
        if (player == 'Right') rightDeck.add(card);

        if (checkForCompleteFamily(player == 'Left' ? leftDeck : player == 'Top' ? topDeck : rightDeck)) {
          return; // Stop the game if a family is completed
        }
      } else {
        statusMessage = "$player a demandé $card à $opponent, mais il ne l'a pas. $player pioche une carte.";
        drawCard(player);
      }
    });
  }

  void drawCard(String player) {
    if (drawPile.isNotEmpty) {
      String drawnCard = drawPile.removeLast();
      setState(() {
        if (player == 'User') {
          userDeck.add(drawnCard);
        } else if (player == 'Left') {
          leftDeck.add(drawnCard);
        } else if (player == 'Top') {
          topDeck.add(drawnCard);
        } else if (player == 'Right') {
          rightDeck.add(drawnCard);
        }
      });
    }
  }

  List<String> getAvailableFamilies(List<String> deck) {
    return families.where((family) {
      return deck.any((card) => card.startsWith(family));
    }).toList();
  }

  List<String> getAvailableMembers(List<String> deck, String family) {
    return familyMembers.where((member) {
      String card = '$family - $member';
      return !deck.contains(card);
    }).toList();
  }

  bool checkForCompleteFamily(List<String> deck) {
    for (var family in families) {
      if (familyMembers.every((member) => deck.contains('$family - $member'))) {
        setState(() {
          statusMessage = '$family complétée par ${currentPlayer == 'User' ? "Vous" : "l\'ordinateur $currentPlayer"} !';
        });
        return true;
      }
    }
    return false;
  }

  void handleUserRequest(String opponent) {
    String requestedCard = '$selectedFamily - $selectedCharacter';
    setState(() {
      List<String> opponentDeck;

      if (opponent == 'Gauche') {
        opponentDeck = leftDeck;
      } else if (opponent == 'Haut') {
        opponentDeck = topDeck;
      } else {
        opponentDeck = rightDeck;
      }

      if (opponentDeck.contains(requestedCard)) {
        statusMessage = "Vous avez pris $requestedCard de l'ordinateur $opponent !";
        userDeck.add(requestedCard);
        opponentDeck.remove(requestedCard);

        if (checkForCompleteFamily(userDeck)) {
          return;
        }
      } else {
        statusMessage = "L'ordinateur $opponent n'a pas $requestedCard. Vous piochez une carte.";
        drawCard('User');
      }
    });
  }

  void showSelectionPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            List<String> availableFamilies = getAvailableFamilies(userDeck);
            List<String> availableMembers = selectedFamily.isNotEmpty ? getAvailableMembers(userDeck, selectedFamily) : [];

            if (!availableFamilies.contains(selectedFamily) && availableFamilies.isNotEmpty) {
              selectedFamily = availableFamilies.first;
            } else if (availableFamilies.isEmpty) {
              selectedFamily = '';
            }

            if (!availableMembers.contains(selectedCharacter) && availableMembers.isNotEmpty) {
              selectedCharacter = availableMembers.first;
            } else if (availableMembers.isEmpty) {
              selectedCharacter = '';
            }

            return AlertDialog(
              title: const Text("Choisissez une carte"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedFamily.isNotEmpty ? selectedFamily : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFamily = newValue!;
                        selectedCharacter = getAvailableMembers(userDeck, selectedFamily).first;
                      });
                    },
                    items: availableFamilies.map<DropdownMenuItem<String>>((String family) {
                      return DropdownMenuItem<String>(
                        value: family,
                        child: Text(family),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedCharacter.isNotEmpty ? selectedCharacter : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCharacter = newValue!;
                      });
                    },
                    items: availableMembers.map<DropdownMenuItem<String>>((String character) {
                      return DropdownMenuItem<String>(
                        value: character,
                        child: Text(character),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showChooseOpponentPopup();
                  },
                  child: const Text("Confirmer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showChooseOpponentPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choisissez un adversaire"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildOpponentButton('Gauche'),
              buildOpponentButton('Haut'),
              buildOpponentButton('Droite'),
            ],
          ),
        );
      },
    );
  }

  Widget buildOpponentButton(String opponent) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        handleCardRequest(opponent);
      },
      child: Text(opponent),
    );
  }

  void handleCardRequest(String opponent) {
    String requestedCard = '$selectedFamily - $selectedCharacter';
    setState(() {
      List<String> opponentDeck;

      if (opponent == 'Gauche') {
        opponentDeck = leftDeck;
      } else if (opponent == 'Haut') {
        opponentDeck = topDeck;
      } else {
        opponentDeck = rightDeck;
      }

      if (opponentDeck.contains(requestedCard)) {
        statusMessage = "Vous avez pris $requestedCard de l'ordinateur $opponent !";
        userDeck.add(requestedCard);
        opponentDeck.remove(requestedCard);

        if (checkForCompleteFamily(userDeck)) {
          return;
        }
      } else {
        statusMessage = "L'ordinateur $opponent n'a pas $requestedCard. Vous piochez une carte.";
        drawCard('User');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu des 7 Familles'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 20,
            child: buildDeck('Ordi Gauche', leftDeck, true),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 100, 
              width: MediaQuery.of(context).size.width * 0.6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topDeck.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: 50,
                      height: 75,
                      color: Colors.blueGrey,
                      child: const Center(
                        child: Text(
                          "?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            right: 20,
            child: buildDeck('Ordi Droit', rightDeck, true),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width * 0.8, 
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userDeck.length,
                itemBuilder: (context, index) {
                  String card = userDeck[index];
                  List<String> cardParts = card.split(' - '); 

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cardParts[0],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cardParts[1],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6, 
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      statusMessage,
                      textAlign: TextAlign.center,
                      maxLines: 3, 
                      softWrap: true, 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (statusMessage != 'Votre tour de jouer !') // Affiche le bouton "Continuer" sauf si c'est le tour du joueur
                    ElevatedButton(
                      onPressed: () {
                        if (currentPlayer != 'User') {
                          computerPlay(currentPlayer);
                        }
                        nextTurn();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Continuer", style: TextStyle(fontSize: 18)),
                    ),
                ],
              ),
            ),
          ),
          if (currentPlayer == 'User')
            Positioned(
              bottom: 200,
              left: MediaQuery.of(context).size.width / 2 - 75,
              child: ElevatedButton(
                onPressed: () {
                  showSelectionPopup();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Sélectionner une carte", style: TextStyle(fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDeck(String player, List<String> deck, bool isHidden) {
    return Column(
      children: [
        Text(player, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: deck
              .map((card) => Container(
                    width: 50,
                    height: 75,
                    color: Colors.blueGrey,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Center(
                      child: Text(
                        isHidden ? '?' : card.split(' - ')[1],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}