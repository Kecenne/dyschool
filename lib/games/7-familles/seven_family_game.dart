import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/game_end_overlay.dart';
import '../../services/game_time_tracker.dart';
import 'package:provider/provider.dart';
import '../../services/playtime_manager.dart';
import '../../data/games_data.dart';
import '../../theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SevenFamilyGamePage extends StatefulWidget {
  @override
  _SevenFamilyGamePageState createState() => _SevenFamilyGamePageState();
}

class _SevenFamilyGamePageState extends State<SevenFamilyGamePage> with TickerProviderStateMixin {
  final List<String> familyMembers = ['Fils', 'Fille', 'Père', 'Mère', 'Grand-Père', 'Grand-Mère'];
  final List<String> families = ['Famille Bouffard', 'Famille Briola', 'Famille Carretero', 'Famille Charrier', 'Famille Dubois', 'Famille Durand', 'Famille Nottebaert'];

  List<String> deck = [];
  List<String> userDeck = [];
  List<String> leftDeck = [];
  List<String> topDeck = [];
  List<String> rightDeck = [];
  List<String> drawPile = [];

  String selectedFamily = '';
  String selectedCharacter = '';
  String? selectedPlayer;
  String currentPlayer = 'User'; 
  String statusMessage = '';

  bool showGameEndOverlay = false;
  String endMessage = '';

  int gameTime = 0; 
  Timer? gameTimer;

  PlaytimeManager? _playtimeManager;
  int _elapsedSeconds = 0;

  String playerName = '';
  int messageStep = 0;  // Pour gérer les étapes des messages
  bool waitingForContinue = false;  // Pour attendre le bouton Continuer

  // Mapping des membres pour correspondre aux noms de fichiers exacts
  final Map<String, String> memberMapping = {
    'Père': 'pere',
    'Mère': 'mere',
    'Grand-Père': 'grand-pere',
    'Grand-Mère': 'grand-mere',
    'Fils': 'fils',
    'Fille': 'fille',
  };

  // Mapping des familles pour correspondre aux noms de fichiers
  final Map<String, String> familyMapping = {
    'Famille Bouffard': 'bouffard',
    'Famille Briola': 'briola',
    'Famille Carretero': 'carretero',
    'Famille Charrier': 'charrier',
    'Famille Dubois': 'dubois',
    'Famille Durand': 'durand',
    'Famille Nottebaert': 'nottebaert',
  };

  // Variables pour l'animation de pioche
  AnimationController? _cardMoveController;
  Animation<Offset>? _cardMoveAnimation;
  AnimationController? _cardFlipController;
  String? _drawnCardImage;
  bool _isDrawing = false;
  Offset? _targetPosition;

  // Variables pour l'animation de transfert
  bool _isTransferring = false;
  String? _transferredCardImage;

  GameTimeTracker? _timeTracker;

  @override
  void initState() {
    super.initState();
    final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
    gameTimeTracker.startTimer();
    _timeTracker = gameTimeTracker;
    _loadPlayerName();
    initializeGame();

    // Initialisation des contrôleurs d'animation
    _cardMoveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardFlipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _cardMoveController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_isDrawing) {
            _isDrawing = false;
            _drawnCardImage = null;
          }
          if (_isTransferring) {
            _isTransferring = false;
            _transferredCardImage = null;
          }
        });
        _cardMoveController!.reset();
        _cardFlipController!.reset();
      }
    });
  }

  Future<void> _loadPlayerName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          playerName = '${userData['prenom']} ${userData['nom']}';
        });
      }
    }
  }

  // Fonction pour déterminer l'article en fonction du genre
  String getArticle(String member) {
    return ['Mère', 'Grand-Mère', 'Fille'].contains(member) ? 'la' : 'le';
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

    selectedFamily = '';
    selectedCharacter = '';
    selectedPlayer = null;

    gameTime = 0;
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          gameTime++;
        });
      } else {
        timer.cancel(); 
      }
    });

    setState(() {
      statusMessage = "C'est à toi de jouer. Que veux-tu demander ?";
    });
  }

  void nextTurn() {
    setState(() {
      if (currentPlayer == 'User') {
        currentPlayer = 'Left';
        statusMessage = "C'est au tour du joueur 2...";
      } else if (currentPlayer == 'Left') {
        currentPlayer = 'Top';
        statusMessage = "C'est au tour du joueur 3...";
      } else if (currentPlayer == 'Top') {
        currentPlayer = 'Right';
        statusMessage = "C'est au tour du joueur 4...";
      } else {
        currentPlayer = 'User';
        statusMessage = "C'est à toi de jouer. Que veux-tu demander ?";
      }
    });
  }

  void computerPlay(String player) {
    // Sélectionner une famille et un membre au hasard
    List<String> playerDeck = player == 'Left' ? leftDeck :
                             player == 'Top' ? topDeck : rightDeck;
    
    // Trouver les familles incomplètes dans le deck du joueur
    Set<String> incompleteFamilies = {};
    for (String card in playerDeck) {
      String family = card.split(' - ')[0];
      if (!familyMembers.every((member) => playerDeck.contains('$family - $member'))) {
        incompleteFamilies.add(family);
      }
    }

    String family;
    String member;
    
    if (incompleteFamilies.isEmpty) {
      // Si pas de famille incomplète, choisir au hasard
      family = families[Random().nextInt(families.length)];
      member = familyMembers[Random().nextInt(familyMembers.length)];
    } else {
      // Choisir une famille incomplète
      family = incompleteFamilies.elementAt(Random().nextInt(incompleteFamilies.length));
      // Trouver les membres manquants de cette famille
      List<String> missingMembers = familyMembers.where((m) => 
        !playerDeck.contains('$family - $m')).toList();
      member = missingMembers[Random().nextInt(missingMembers.length)];
    }

    // Choisir un adversaire qui n'est pas le joueur actuel
    List<String> possibleOpponents = ['User', 'Left', 'Top', 'Right'];
    possibleOpponents.remove(player);
    String opponent = possibleOpponents[Random().nextInt(possibleOpponents.length)];

    handleComputerRequest(player, opponent, '$family - $member');
  }

  void handleComputerRequest(String player, String opponent, String card) {
    List<String> opponentDeck;
    String playerName = player == 'Left' ? 'Le joueur 2' : 
                       player == 'Top' ? 'Le joueur 3' : 'Le joueur 4';
    String opponentName = opponent == 'User' ? this.playerName :
                         opponent == 'Left' ? 'joueur 2' :
                         opponent == 'Top' ? 'joueur 3' : 'joueur 4';
    List<String> cardParts = card.split(' - ');
    String familyName = cardParts[0];
    String memberName = cardParts[1];
    String article = getArticle(memberName);

    if (opponent == 'User') {
      opponentDeck = userDeck;
    } else if (opponent == 'Left') {
      opponentDeck = leftDeck;
    } else if (opponent == 'Top') {
      opponentDeck = topDeck;
    } else {
      opponentDeck = rightDeck;
    }

    setState(() {
      messageStep = 1;
      waitingForContinue = true;
      statusMessage = "$playerName demande $article ${memberName.toLowerCase()} de $familyName à $opponentName !";
    });
  }

  Function? _nextMessage;

  void handleCardRequest(String opponent) {
    String requestedCard = '$selectedFamily - $selectedCharacter';
    List<String> opponentDeck;
    String opponentName = opponent == 'Gauche' ? 'joueur 2' :
                         opponent == 'Haut' ? 'joueur 3' : 'joueur 4';
    String article = getArticle(selectedCharacter);

    String opponentPlayer = opponent == 'Gauche' ? 'Left' :
                          opponent == 'Haut' ? 'Top' : 'Right';

    if (opponent == 'Gauche') {
      opponentDeck = leftDeck;
    } else if (opponent == 'Haut') {
      opponentDeck = topDeck;
    } else {
      opponentDeck = rightDeck;
    }

    setState(() {
      messageStep = 1;
      waitingForContinue = true;
      statusMessage = "Dans $selectedFamily, tu demandes $article ${selectedCharacter.toLowerCase()} au $opponentName !";
    });

    if (opponentDeck.contains(requestedCard)) {
      _nextMessage = () {
        opponentDeck.remove(requestedCard);
        animateCardTransfer(opponentPlayer, 'User', requestedCard);
        setState(() {
          userDeck.add(requestedCard);
          statusMessage = "Le $opponentName te donne $article ${selectedCharacter.toLowerCase()} de $selectedFamily !";
        });
        if (checkForCompleteFamily(userDeck)) {
          return;
        }
      };
    } else {
      _nextMessage = () {
        statusMessage = "Le $opponentName n'a pas $article ${selectedCharacter.toLowerCase()} de $selectedFamily. Tu pioches une carte.";
        drawCard('User');
      };
    }
  }

  void continueGame() {
    if (currentPlayer != 'User') {
      if (messageStep == 0) {
        computerPlay(currentPlayer);
      } else if (messageStep == 1) {
        String player = currentPlayer;
        List<String> cardParts = statusMessage.split(' demande ')[1].split(' de ');
        String memberWithArticle = cardParts[0];
        String familyAndTarget = cardParts[1];
        String family = familyAndTarget.split(' à ')[0];
        String target = familyAndTarget.split(' à ')[1].replaceAll(' !', '');

        List<String> sourceDeck = target == playerName ? userDeck :
                                 target == 'joueur 2' ? leftDeck :
                                 target == 'joueur 3' ? topDeck : rightDeck;
        List<String> destDeck = player == 'Left' ? leftDeck :
                               player == 'Top' ? topDeck : rightDeck;

        String memberName = memberWithArticle.split(' ')[1];
        String requestedCard = '$family - ${memberName.substring(0, 1).toUpperCase()}${memberName.substring(1)}';

        String sourcePlayer = target == playerName ? 'User' :
                            target == 'joueur 2' ? 'Left' :
                            target == 'joueur 3' ? 'Top' : 'Right';

        setState(() {
          if (sourceDeck.contains(requestedCard)) {
            sourceDeck.remove(requestedCard);
            animateCardTransfer(sourcePlayer, player, requestedCard);
            setState(() {
              destDeck.add(requestedCard);
              statusMessage = "${player == 'Left' ? 'Le joueur 2' : player == 'Top' ? 'Le joueur 3' : 'Le joueur 4'} a récupéré $memberWithArticle de $family !";
            });
            
            if (checkForCompleteFamily(destDeck)) {
              return;
            }
          } else {
            statusMessage = "Le $target n'a pas $memberWithArticle de $family. ${player == 'Left' ? 'Le joueur 2' : player == 'Top' ? 'Le joueur 3' : 'Le joueur 4'} pioche une carte.";
            drawCard(player);
          }
          messageStep = 2;
        });
      } else {
        setState(() {
          messageStep = 0;
          waitingForContinue = false;
          nextTurn();
        });
      }
    } else {
      if (messageStep == 1 && _nextMessage != null) {
        setState(() {
          _nextMessage!();
          _nextMessage = null;
          messageStep = 2;
        });
      } else {
        setState(() {
          messageStep = 0;
          waitingForContinue = false;
          nextTurn();
        });
      }
    }
  }

  void drawCard(String player) {
    if (drawPile.isNotEmpty) {
      String drawnCard = drawPile.removeLast();
      animateCardDraw(player, drawnCard);
      
      _cardMoveController!.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
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
          _cardMoveController!.removeStatusListener((status) {});
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
        gameTimer?.cancel();
        setState(() {
          endMessage = '$family complétée par ${currentPlayer == 'User' ? "Vous" : "l\'ordinateur $currentPlayer"} en $gameTime secondes !';
          showGameEndOverlay = true;
        });
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    gameTimer?.cancel();
    initializeGame();
    setState(() {
      showGameEndOverlay = false;
    });
  }

  void showSelectionPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            List<String> availableFamilies = getAvailableFamilies(userDeck);
            String? localSelectedFamily = selectedFamily.isNotEmpty && availableFamilies.contains(selectedFamily) ? selectedFamily : null;
            List<String> availableMembers = localSelectedFamily != null ? getAvailableMembers(userDeck, localSelectedFamily) : [];
            String? localSelectedCharacter = selectedCharacter.isNotEmpty && availableMembers.contains(selectedCharacter) ? selectedCharacter : null;

            bool canValidate = localSelectedCharacter != null && 
                             localSelectedFamily != null && 
                             selectedPlayer != null;

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pour quelle famille ?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButton<String>(
                                  hint: const Text(
                                    'Choix de la famille',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  value: localSelectedFamily,
                                  onChanged: availableFamilies.isEmpty ? null : (String? newValue) {
                                    setState(() {
                                      localSelectedFamily = newValue;
                                      selectedFamily = newValue!;
                                      localSelectedCharacter = null;
                                      selectedCharacter = getAvailableMembers(userDeck, selectedFamily).first;
                                    });
                                  },
                                  items: availableFamilies.map<DropdownMenuItem<String>>((String family) {
                                    return DropdownMenuItem<String>(
                                      value: family,
                                      child: Text(
                                        family,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  dropdownColor: AppColors.primaryColor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 36),
                                  isExpanded: true,
                                  underline: Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quel membre veux-tu demander ?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButton<String>(
                                  hint: const Text(
                                    'Choix du membre',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  value: localSelectedCharacter,
                                  onChanged: availableMembers.isEmpty ? null : (String? newValue) {
                                    setState(() {
                                      localSelectedCharacter = newValue;
                                      selectedCharacter = newValue!;
                                    });
                                  },
                                  items: availableMembers.map<DropdownMenuItem<String>>((String character) {
                                    return DropdownMenuItem<String>(
                                      value: character,
                                      child: Text(
                                        character,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  dropdownColor: AppColors.primaryColor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 36),
                                  isExpanded: true,
                                  underline: Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'A quel joueur ?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButton<String>(
                                  hint: const Text(
                                    'Choix du joueur',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  value: selectedPlayer,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedPlayer = newValue;
                                    });
                                  },
                                  items: ['Joueur 2', 'Joueur 3', 'Joueur 4'].map<DropdownMenuItem<String>>((String player) {
                                    return DropdownMenuItem<String>(
                                      value: player,
                                      child: Text(
                                        player,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  dropdownColor: AppColors.primaryColor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 36),
                                  isExpanded: true,
                                  underline: Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: canValidate ? () {
                          Navigator.of(context).pop();
                          String opponent = selectedPlayer == 'Joueur 2' ? 'Gauche' :
                                         selectedPlayer == 'Joueur 3' ? 'Haut' : 'Droite';
                          handleCardRequest(opponent);
                          setState(() {
                            selectedPlayer = null;
                          });
                        } : null,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color: canValidate ? Colors.white : Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          disabledBackgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          'Valider',
                          style: TextStyle(
                            color: canValidate ? Colors.white : Colors.white.withOpacity(0.5),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playtimeManager ??= Provider.of<PlaytimeManager>(context, listen: false);
    _timeTracker = Provider.of<GameTimeTracker>(context, listen: false);
  }

  @override
  void dispose() {
    _cardMoveController?.dispose();
    _cardFlipController?.dispose();
    if (_timeTracker != null) {
      List<String> gameTypes = _getGameTypes("Jeu des 7 familles");
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
    final cardWidth = 100.0;
    final cardHeight = 140.0;
    final cardSpacing = 8.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu des 7 Familles'),
      ),
      body: Container(
        child: Stack(
          children: [
            // Section gauche
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 40,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: buildDeck('Joueur 2', leftDeck, true, cardWidth, cardHeight, cardSpacing / 2),
              ),
            ),

            // Section droite
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              right: 40,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: buildDeck('Joueur 4', rightDeck, true, cardWidth, cardHeight, cardSpacing / 2),
              ),
            ),

            // Section du haut
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: cardHeight + 60,
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Joueur 3', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: cardHeight,
                      child: Center(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: topDeck.length > 7 ? 7 : topDeck.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: cardSpacing),
                              child: Container(
                                width: cardWidth,
                                height: cardHeight,
                                child: Image.asset(
                                  'assets/images/seven-family/who-is-returned-card.png',
                                  fit: BoxFit.contain,
                                  cacheWidth: 180,
                                  cacheHeight: 260,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (topDeck.length > 7)
                      Container(
                        height: 28,
                        padding: const EdgeInsets.only(top: 4),
                        alignment: Alignment.center,
                        child: Text(
                          '+${topDeck.length - 7}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Section message central
            SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusMessage,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                      ),
                      if (currentPlayer == 'User' && statusMessage == "C'est à toi de jouer. Que veux-tu demander ?")
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showSelectionPopup();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                              ),
                              child: const Text(
                                "Jouer",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (statusMessage != "C'est à toi de jouer. Que veux-tu demander ?")
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                continueGame();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                              ),
                              child: const Text(
                                "Continuer",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Section cartes du joueur
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: cardHeight * 1.8,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: userDeck.length,
                        itemBuilder: (context, index) {
                          String card = userDeck[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: cardSpacing),
                            child: Container(
                              width: cardWidth * 1.8,
                              height: cardHeight * 1.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/seven-family/${_getCardImage(card)}',
                                  fit: BoxFit.contain,
                                  cacheWidth: 360,
                                  cacheHeight: 504,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section du deck de pioche
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),

                ),
                child: Column(
                  children: [
                    const Text(
                      'Pioche',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          width: cardWidth,
                          height: cardHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/seven-family/who-is-returned-card.png',
                              fit: BoxFit.contain,
                              cacheWidth: 200,
                              cacheHeight: 280,
                            ),
                          ),
                        ),
                        if (drawPile.length > 1)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                '${drawPile.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Carte en cours de pioche
            if (_isDrawing && _cardMoveAnimation != null)
              AnimatedBuilder(
                animation: _cardMoveController!,
                builder: (context, child) {
                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.5 + 
                         _cardMoveAnimation!.value.dy * MediaQuery.of(context).size.height * 0.4,
                    left: MediaQuery.of(context).size.width * 0.5 + 
                         _cardMoveAnimation!.value.dx * MediaQuery.of(context).size.width * 0.4,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      tween: Tween<double>(
                        begin: currentPlayer == 'User' ? 0 : 1,
                        end: currentPlayer == 'User' && _cardFlipController!.value == 1 ? 1 : 0,
                      ),
                      builder: (context, value, child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(value * 3.14),
                          child: Container(
                            width: cardWidth,
                            height: cardHeight,
                            child: value >= 0.5
                              ? Image.asset(
                                  'assets/images/seven-family/${_drawnCardImage}',
                                  fit: BoxFit.contain,
                                  cacheWidth: 180,
                                  cacheHeight: 260,
                                )
                              : Image.asset(
                                  'assets/images/seven-family/who-is-returned-card.png',
                                  fit: BoxFit.contain,
                                  cacheWidth: 180,
                                  cacheHeight: 260,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

            // Carte en cours de transfert
            if (_isTransferring && _cardMoveAnimation != null)
              AnimatedBuilder(
                animation: _cardMoveController!,
                builder: (context, child) {
                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.5 + 
                         _cardMoveAnimation!.value.dy * MediaQuery.of(context).size.height * 0.4,
                    left: MediaQuery.of(context).size.width * 0.5 + 
                         _cardMoveAnimation!.value.dx * MediaQuery.of(context).size.width * 0.4,
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      child: Image.asset(
                        'assets/images/seven-family/${_transferredCardImage}',
                        fit: BoxFit.contain,
                        cacheWidth: 180,
                        cacheHeight: 260,
                      ),
                    ),
                  );
                },
              ),

            if (showGameEndOverlay) ...[
              ModalBarrier(color: Colors.black.withOpacity(0.5)),
              GameEndOverlay(
                message: endMessage,
                onRestart: resetGame,
                onQuit: () {
                  final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
                  List<String> gameTypes = _getGameTypes("Jeu des 7 familles");
                  gameTimeTracker.stopTimer(context, gameTypes);
                  Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                },
                gameName: 'Seven Families',
                result: gameTime,
                playtime: (_elapsedSeconds / 60).ceil(),
                strengths: ["Prise de décision", "Mémoire visuelle", "Concentration"],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDeck(String player, List<String> deck, bool isHidden, double cardWidth, double cardHeight, double spacing) {
    bool isLeft = player == 'Joueur 2';
    bool isRight = player == 'Joueur 4';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(player, style: const TextStyle(fontWeight: FontWeight.bold)),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...deck.take(6).map((card) => SizedBox(
              width: isLeft || isRight ? cardWidth * 0.9 : cardWidth,
              height: isLeft || isRight ? cardHeight * 0.84 : cardHeight,
              child: Container(
                margin: isLeft || isRight ? EdgeInsets.zero : EdgeInsets.symmetric(vertical: spacing / 2),
                child: Transform.rotate(
                  angle: isLeft ? -pi/2 : (isRight ? pi/2 : 0),
                  child: Image.asset(
                    'assets/images/seven-family/who-is-returned-card.png',
                    fit: BoxFit.contain,
                    cacheWidth: 200,
                    cacheHeight: 280,
                  ),
                ),
              ),
            )),
            if (deck.length > 6)
              Text(
                '+${deck.length - 6}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _getCardImage(String card) {
    // Format de la carte: "Famille X - Membre"
    List<String> parts = card.split(' - ');
    String familyName = familyMapping[parts[0]] ?? '';
    String memberName = memberMapping[parts[1]] ?? parts[1].toLowerCase();
    return '$familyName-$memberName.png';
  }

  // Fonction pour animer la pioche d'une carte
  void animateCardDraw(String player, String drawnCard) {
    setState(() {
      _isDrawing = true;
      _drawnCardImage = player == 'User' ? _getCardImage(drawnCard) : 'who-is-returned-card.png';
    });

    // Calculer la position cible en fonction du joueur
    double targetX = 0.0;
    double targetY = 0.0;

    switch (player) {
      case 'User':
        targetX = 0.0;
        targetY = 1.0;
        break;
      case 'Left':
        targetX = -1.0;
        targetY = 0.0;
        break;
      case 'Top':
        targetX = 0.0;
        targetY = -1.0;
        break;
      case 'Right':
        targetX = 1.0;
        targetY = 0.0;
        break;
    }

    // Animation identique pour tous les joueurs
    _cardMoveAnimation = Tween<Offset>(
      begin: const Offset(0.5, -0.7),
      end: Offset(targetX, targetY),
    ).animate(CurvedAnimation(
      parent: _cardMoveController!,
      curve: Curves.easeInOut,
    ));
    _cardMoveController!.forward();
  }

  void animateCardTransfer(String fromPlayer, String toPlayer, String card) {
    setState(() {
      _isTransferring = true;
      _transferredCardImage = 'who-is-returned-card.png';
    });

    // Calculer la position de départ en fonction du joueur source
    double startX = 0.0;
    double startY = 0.0;

    switch (fromPlayer) {
      case 'User':
        startX = 0.0;
        startY = 1.0;
        break;
      case 'Left':
        startX = -1.0;
        startY = 0.0;
        break;
      case 'Top':
        startX = 0.0;
        startY = -1.0;
        break;
      case 'Right':
        startX = 1.0;
        startY = 0.0;
        break;
    }

    // Calculer la position cible en fonction du joueur destination
    double targetX = 0.0;
    double targetY = 0.0;

    switch (toPlayer) {
      case 'User':
        targetX = 0.0;
        targetY = 1.0;
        break;
      case 'Left':
        targetX = -1.0;
        targetY = 0.0;
        break;
      case 'Top':
        targetX = 0.0;
        targetY = -1.0;
        break;
      case 'Right':
        targetX = 1.0;
        targetY = 0.0;
        break;
    }

    _cardMoveAnimation = Tween<Offset>(
      begin: Offset(startX, startY),
      end: Offset(targetX, targetY),
    ).animate(CurvedAnimation(
      parent: _cardMoveController!,
      curve: Curves.easeInOut,
    ));

    _cardMoveController!.forward().then((_) {
      setState(() {
        _isTransferring = false;
        _transferredCardImage = null;
      });
    });
  }
}