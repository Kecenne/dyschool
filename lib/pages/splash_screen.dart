import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/dyschool-splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}