import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameMessageWidget extends StatefulWidget {
  final String gameName;
  final dynamic result;

  const GameMessageWidget({required this.gameName, required this.result, Key? key}) : super(key: key);

  @override
  _GameMessageWidgetState createState() => _GameMessageWidgetState();
}

class _GameMessageWidgetState extends State<GameMessageWidget> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['prenom'] ?? 'Joueur';
        });
      } else {
        setState(() {
          userName = 'Joueur';
        });
      }
    }
  }

  String getGameMessage() {
    String name = userName ?? 'Joueur';

    if (widget.gameName == 'Seven Families') {
      if (widget.result <= 30) return "Bravo $name ! Tu as excellé dans cette partie et remporté la victoire haut la main ! Ta capacité à reconnaître les bonnes associations entre les cartes a fait toute la différence. Ce résultat prouve que tu es attentif, méthodique et que tu sais analyser rapidement chaque situation. Continue sur cette lancée, chaque partie est une nouvelle opportunité de progresser. Tu es sur la bonne voie pour devenir un véritable maître du jeu !";
      if (widget.result <= 60) return "Très bien joué $name ! Tu as fait preuve d’une excellente mémoire et d’une grande logique pour compléter cette partie avec succès. Il y a eu quelques moments où tu aurais pu être plus rapide, mais dans l’ensemble, tu as démontré une belle persévérance. Avec encore un peu d’entraînement, tu pourras atteindre des sommets. Ne lâche rien, tu es proche de l’excellence !";
      if (widget.result <= 120) return "Bien joué $name ! Tu progresses bien et ta stratégie commence à porter ses fruits. Tu as réussi à faire de bonnes associations, même si certaines décisions auraient pu être prises plus rapidement. Ce qui compte, c’est que tu es sur la bonne voie. Chaque partie te rapproche un peu plus du succès, continue comme ça !";
      return "C'était une partie intéressante $name ! Essaye d'améliorer ton temps au prochain essai.";
    }

    switch (widget.gameName) {
      case 'Memory Game':
        if (widget.result <= 20) return "Excellent travail $name ! Tu as fait preuve d’une mémoire hors pair et d’une capacité de concentration impressionnante. Trouver les paires aussi rapidement démontre une excellente observation et une rapidité d’analyse. Tu es vraiment un expert du jeu de mémoire ! Continue ainsi, et aucun défi ne pourra te résister.";
        if (widget.result <= 40) return "Très bon score $name ! Tu as très bien joué, en restant attentif et en faisant preuve de logique. Quelques hésitations t’ont coûté du temps, mais ton esprit d’analyse est indéniable. Avec un peu plus de rapidité, la médaille d’or sera à ta portée. Ne baisse pas les bras, tu es tout proche du sommet !";
        return "Bien joué $name ! Tu as réussi à te souvenir de plusieurs paires et à garder ta concentration tout au long de la partie. Il y a encore des marges d’amélioration, mais ton entraînement porte ses fruits. Avec plus de pratique, tu deviendras un pro du Memory Game !";

      case 'Connect Four':
        if (widget.result <= 7) return "Superbe victoire $name ! Tu as su lire le jeu de ton adversaire et placer tes pions avec une grande intelligence. Cette victoire rapide prouve que tu maîtrises parfaitement la mécanique du Puissance 4. Continue ainsi et personne ne pourra t’arrêter. Tu es un vrai stratège !";
        if (widget.result <= 10) return "Très bonne partie $name ! Tu as su combiner réflexion et rapidité pour gagner, même si certains coups auraient pu être optimisés. L’important, c’est que tu montres une belle progression. Affûte encore plus ta tactique et la prochaine victoire sera éclatante !";
        if (widget.result <= 15) return "Belle partie $name ! Tu as réussi à aligner tes pions et à comprendre les bases du jeu. Parfois, il faut anticiper un peu plus les mouvements de l’adversaire, mais tu es sur la bonne voie. Chaque partie te rend plus fort, alors continue de jouer et d’apprendre !";
        break;

      case 'Guess Who':
        if (widget.result >= 9) return "Félicitations $name ! Tu as posé les bonnes questions et trouvé la bonne réponse en un temps record ! Ton esprit de déduction est affûté et ta logique est implacable. Avec cette rapidité d’analyse, rien ne peut t’échapper ! Continue ainsi et tu deviendras un expert du Guess Who !";
        if (widget.result >= 7) return "Très bon raisonnement $name ! Tu as su éliminer les mauvais choix avec une belle méthode, même si tu aurais pu gagner encore plus rapidement. L’important, c’est que ton analyse s’améliore à chaque partie. Avec un peu plus de rapidité, la médaille d’or sera bientôt à toi !";
        if (widget.result >= 5) return "Bien joué $name ! Tu as su faire preuve d’observation et de logique, même si certaines questions auraient pu être plus précises. L’important, c’est de continuer à progresser. Avec un peu plus de réflexion, tu deviendras imbattable !";
        break;

      case 'Simon':
        if (widget.result >= 20) return "Bravo $name ! Tu as suivi la séquence avec une précision incroyable. Ta concentration et ton sens du rythme sont impressionnants. Peu de joueurs atteignent ce niveau ! Tu es vraiment un champion du Simon ! Continue de t’entraîner, et tu pulvériseras tous les records.";
        if (widget.result >= 10) return "Très bon résultat $name ! Tu as bien suivi les séquences et montré une belle progression. Il ne manque pas grand-chose pour atteindre la médaille d’or. Affûte encore un peu ta concentration et tu deviendras imbattable !";
        if (widget.result >= 5) return "C'est un bon début $name ! Tu as su retenir plusieurs séquences et garder ton calme. Il y a encore de la marge pour progresser, mais chaque partie te rend plus fort. Continue sur cette lancée et tes performances vont exploser !";
        break;
    }

    return "Bien joué $name ! Chaque partie est une opportunité d'apprendre et de progresser.";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        getGameMessage(),
        style: const TextStyle(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.left,
      ),
    );
  }
}