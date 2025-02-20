import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/game_end_overlay.dart';
import '../../services/game_time_tracker.dart';
import '../../services/playtime_manager.dart';
import '../../data/games_data.dart';

class GuessWhoGamePage extends StatefulWidget {
  @override
  _GuessWhoGamePageState createState() => _GuessWhoGamePageState();
}

class _GuessWhoGamePageState extends State<GuessWhoGamePage> {
  final List<Map<String, dynamic>> _originalQuestions = [
    {"question": "Je suis un homme au crâne rasé et je porte une chemise orange. Mon expression est sérieuse, et je peux sembler un peu strict, mais je suis en réalité très réfléchi. Dans la vie, j’aime analyser les choses avant de prendre une décision.", "image": "benjamin.png"},
    {"question": "Je suis une jeune femme aux cheveux roux et bouclés, avec un serre-tête perlé. Je porte un haut clair et j’ai un sourire chaleureux. J’aime la douceur et le calme, et je suis toujours prête à aider mes amis.", "image": "camille.png"},
    {"question": "Je suis un homme souriant avec la peau foncée et des cheveux courts. Je porte une chemise orange avec un petit insigne. Mon air joyeux montre que je suis toujours de bonne humeur. J’aime travailler en équipe et encourager les autres.", "image": "daniel.png"},
    {"question": "Je suis une femme aux cheveux gris et aux lunettes noires. Je porte des vêtements sombres et j’ai un air bienveillant. J’aime lire et apprendre de nouvelles choses. Les gens viennent souvent me demander conseil.", "image": "fabienne.png"},
    {"question": "Je suis un homme blond avec des lunettes noires et une chemise marron. Mon sourire discret montre que je suis quelqu’un de réfléchi et posé. Dans la vie, j’aime discuter et partager mes connaissances avec les autres.", "image": "jean.png"},
    {"question": "Je suis un homme chauve avec des lunettes rondes et une chemise bleue. Mon sourire calme montre que je suis une personne posée et rassurante. J’aime la logique et résoudre des problèmes.", "image": "jerome.png"},
    {"question": "Je suis une femme brune avec un bandeau jaune et un air un peu sérieux. Je porte un haut bleu foncé et j’aime que les choses soient bien organisées. Dans la vie, je suis déterminée et persévérante.", "image": "lea.png"},
    {"question": "Je suis une femme souriante avec des lunettes rondes et de longs cheveux bruns. Je porte une chemise orange et j’adore discuter avec les autres. Je suis curieuse et toujours à la recherche de nouvelles aventures.", "image": "maya.png"},
    {"question": "Je suis un homme brun avec une expression un peu boudeuse et une chemise claire. J’ai parfois l’air sérieux, mais au fond, j’aime bien plaisanter et faire rire mes amis. Je suis aussi quelqu’un de très loyal.", "image": "thierry.png"},
    {"question": "Je suis une femme aux cheveux courts, bruns et aux lunettes noires. Mon expression sérieuse montre que j’aime que les choses soient bien faites. J’ai un grand sens des responsabilités et j’aime aider les autres à s’améliorer.", "image": "valerie.png"},
  ];

  final List<String> _allImages = [
    "benjamin.png",
    "camille.png",
    "daniel.png",
    "fabienne.png",
    "jean.png",
    "jerome.png",
    "lea.png",
    "maya.png",
    "thierry.png",
    "valerie.png"
  ];

  late List<Map<String, dynamic>> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool showGameEndOverlay = false;
  String endMessage = '';
  List<String> remainingChoices = [];
  int mistakeCount = 0;
  Map<String, String> cardStates = {};
  Set<String> permanentlyRevealed = {};
  String _currentMessage = "";
  bool _showContinueButton = false;

  late PlaytimeManager _playtimeManager;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playtimeManager = Provider.of<PlaytimeManager>(context, listen: false);
  }

  @override
  void dispose() {
    int minutesPlayed = (_elapsedSeconds / 60).ceil();

    List<String> gameTypes = _getGameTypes("Qui-est-ce ?");

    Future.delayed(Duration.zero, () {
      _playtimeManager.addPlaytime(minutesPlayed, gameTypes);
    });

    super.dispose();
  }


  List<String> _getGameTypes(String gameTitle) {
    final game = gamesList.firstWhere(
      (g) => g["title"] == gameTitle,
      orElse: () => {"types": []}, 
    );

    return List<String>.from(game["types"] ?? []);
  }


  void _shuffleQuestions() {
    setState(() {
      questions = List.from(_originalQuestions)..shuffle();
      _resetQuestionState();
    });
  }

  void _resetQuestionState() {
    remainingChoices = List.from(_allImages)..shuffle();
    cardStates = {for (var img in remainingChoices) img: img};
    mistakeCount = 0;
  }

void handleAnswer(String selectedImage) {
  final correctImage = questions[currentQuestionIndex]["image"];
  final correctAnswer = correctImage.split('.').first;
  final formattedAnswer = correctAnswer[0].toUpperCase() + correctAnswer.substring(1);

  if (selectedImage == correctImage) {
    setState(() {
      score++;
      _currentMessage = "Bravo ! Bonne réponse !";
    });
    Future.delayed(Duration(seconds: 1), _nextQuestion); 
  } else {
    mistakeCount++;
    if (mistakeCount == 1) {
      _turnWrongChoices(5);
      setState(() {
        _currentMessage = "Mauvaise réponse ! 5 cartes retournées.";
        _showContinueButton = true;
      });
    } else if (mistakeCount == 2) {
      _turnWrongChoices(3);
      setState(() {
        _currentMessage = "Encore raté ! Il ne reste plus que 2 cartes !";
        _showContinueButton = true;
      });
    } else {
      setState(() {
        _currentMessage = "La bonne réponse était $formattedAnswer !";
      });
      Future.delayed(Duration(seconds: 2), _nextQuestion);
    }
  }
}

  void _turnWrongChoices(int count) {
    final wrongChoices = remainingChoices
        .where((img) => img != questions[currentQuestionIndex]["image"] && cardStates[img] != "who-is-returned-card.png")
        .toList();

    wrongChoices.shuffle();
    final toTurn = wrongChoices.take(count).toList();

    for (int i = 0; i < toTurn.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        setState(() {
          cardStates[toTurn[i]] = "who-is-returned-card.png";
        });
      });
    }
  }

  void _showMessage(String message, [VoidCallback? onComplete]) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onComplete != null) onComplete();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    
    if (currentQuestionIndex < questions.length - 1) {
      cardStates = {for (var img in _allImages) img: img}; 
      setState(() {
        currentQuestionIndex++;
        mistakeCount = 0;
        _currentMessage = "";
        _showContinueButton = false;

        cardStates = {for (var img in _allImages) img: img};
      });
    } else {
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Partie terminée !"),
        content: Text("Votre score : $score/${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _triggerGameEndOverlay();
            },
            child: const Text("Continuer"),
          ),
        ],
      ),
    );
  }

  void _triggerGameEndOverlay() {
    setState(() {
      endMessage = "Votre score : $score/${questions.length}";
      showGameEndOverlay = true;
    });
  }

@override
Widget build(BuildContext context) {
  final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);
  gameTimeTracker.startTimer();

  return Scaffold(
    appBar: AppBar(title: const Text("Qui-est-ce ?")),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentMessage.isNotEmpty
                      ? _currentMessage
                      : questions[currentQuestionIndex]["question"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 12),

              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.6,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), 
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: remainingChoices.length,
                      itemBuilder: (context, index) {
                        final imageName = remainingChoices[index];
                        final imageToShow = cardStates[imageName]!;
                        final isClickable = !_showContinueButton && imageToShow != "who-is-returned-card.png";

                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: cardStates[imageName] == "who-is-returned-card.png" ? 1 : 0),
                          duration: Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            final isFlipped = value >= 0.5;
                            return GestureDetector(
                              onTap: isClickable ? () => handleAnswer(imageName) : null,
                              child: AspectRatio(
                                aspectRatio: 0.75,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(value * 3.1416), 
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0), 
                                      child: Image.asset(
                                        "assets/images/who/${isFlipped ? "who-is-returned-card.png" : imageName}",
                                        fit: BoxFit.contain, 
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    if (_showContinueButton)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentMessage = "";
                            _showContinueButton = false;
                          });
                        },
                        child: Text("Continuer"),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showGameEndOverlay) ...[
          ModalBarrier(color: Colors.black.withOpacity(0.5)),
          GameEndOverlay(
            message: endMessage,
            onRestart: _shuffleQuestions,
            onQuit: () {
              final gameTimeTracker = Provider.of<GameTimeTracker>(context, listen: false);

              List<String> gameTypes = _getGameTypes("Qui-est-ce ?");
              gameTimeTracker.stopTimer(context, gameTypes);

              Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
            },
            gameName: 'Guess Who',
            result: score,
          ),
        ],
      ],
    ),
  );
}
}