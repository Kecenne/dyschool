import "dart:async";
import "package:flutter/material.dart";
import "home_page.dart"; // Importer la page d"accueil

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Démarre un Timer qui attend 2,2 secondes avant de rediriger
    Timer(Duration(seconds: 2, milliseconds: 200), () {
      // Redirection vers la HomePage après 2,2 secondes
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Choisis la couleur d"arrière-plan de ta splash screen
      body: Center(
        child: Image.asset(
          "assets/images/logo.png", // Chemin vers le logo
          width: 150, // Largeur du logo
          height: 150, // Hauteur du logo
        ),
      ),
    );
  }
}
