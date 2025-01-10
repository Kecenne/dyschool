import 'package:flutter/material.dart';
import '../../theme/app_color.dart';
import '../../widgets/game_end_overlay.dart';

class GuessWhoGamePage extends StatefulWidget {
  @override
  _GuessWhoGamePageState createState() => _GuessWhoGamePageState();
}

class _GuessWhoGamePageState extends State<GuessWhoGamePage> {
  final List<Map<String, dynamic>> questions = [
    {
      "question": "Je suis un jeune homme passionné et travailleur. Au point que je ne prends pas de vacances... De toute façon je suis déjà bronzé naturellement !",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": true},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis une femme aux cheveux blonds et je rêve de devenir chanteuse.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": true},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "J'aime la lecture et on me voit souvent avec des lunettes. Mon rêve est de devenir écrivain.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": true},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis une femme toujours souriante. Je porte souvent des vêtements colorés et je suis une artiste peintre.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": true},
      ]
    },
    {
      "question": "Je suis un homme barbu qui adore voyager. Mon sac à dos est toujours prêt pour de nouvelles aventures.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": true},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis une femme brune avec des lunettes. Je travaille comme scientifique et je passe beaucoup de temps en laboratoire.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": true},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis un enfant avec un sourire malicieux. J'adore jouer au football avec mes amis.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": true},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis une jeune fille aux cheveux roux. J'aime les animaux et je passe mes journées à dessiner des paysages.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": true},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis un homme d'affaires en costume. On me voit toujours avec une mallette à la main.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": true},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": false},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
    {
      "question": "Je suis une femme âgée aux cheveux gris. J'adore raconter des histoires de mon enfance à mes petits-enfants.",
      "choices": [
        {"name": "Jeune homme bronzé", "correct": false},
        {"name": "Femme blonde", "correct": false},
        {"name": "Homme à lunettes", "correct": false},
        {"name": "Homme barbu", "correct": false},
        {"name": "Femme rousse", "correct": false},
        {"name": "Homme en costume", "correct": false},
        {"name": "Femme scientifique", "correct": false},
        {"name": "Garçon joueur de football", "correct": false},
        {"name": "Femme âgée", "correct": true},
        {"name": "Artiste en couleurs", "correct": false},
      ]
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  bool showGameEndOverlay = false;
  String endMessage = '';

  void handleAnswer(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        score++;
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
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

  void resetGame() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      showGameEndOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Qui-est-ce ?"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1}/${questions.length}",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  question["question"],
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: question["choices"].length,
                    itemBuilder: (context, index) {
                      final choice = question["choices"][index];
                      return GestureDetector(
                        onTap: () {
                          if (!showGameEndOverlay) {
                            handleAnswer(choice["correct"]);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              choice["name"],
                              style: const TextStyle(fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
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