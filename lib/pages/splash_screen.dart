import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:get/get.dart'; // Use Get for navigation
import 'login_page.dart'; // Import LoginPage
import '../main.dart'; // Import MainPage
import '../theme/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState(); // Check authentication state
  }

  void _checkAuthState() async {
    // Wait for 2.2 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2, milliseconds: 200));

    // Check the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Navigate to LoginPage
      Get.off(() => const LoginPage());
    } else {
      // Navigate to MainPage
      Get.off(() => const MainPage());
    }
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