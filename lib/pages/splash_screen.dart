import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Démarrer un timer pour simuler un écran de chargement
    Timer(const Duration(seconds: 2, milliseconds: 200), () {
      // Vérifier l'état de l'utilisateur
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // L'utilisateur est connecté, naviguer vers MainPage
        Get.offNamed('/main');
      } else {
        // L'utilisateur n'est pas connecté, naviguer vers LoginPage
        Get.offNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}