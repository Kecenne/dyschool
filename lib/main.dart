import 'dart:async';  // Pour utiliser Timer
import 'package:flutter/material.dart';
import 'widgets/navbar.dart';
import 'pages/home_page.dart';
import 'pages/progression_page.dart';
import 'pages/favorite_page.dart';
import 'pages/games_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyschool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Lancer le splash screen en premier
    );
  }
}

// SplashScreen Widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer pour attendre 2,2 secondes avant de rediriger vers MainPage
    Timer(const Duration(seconds: 2, milliseconds: 200), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()), // Rediriger vers MainPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Couleur d'arrière-plan
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Remplace par le chemin de ton logo
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

// MainPage Widget inchangé
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

  static const List<Widget> _pages = <Widget>[
    ProgressionPage(),
    FavoritePage(),
    HomePage(),
    GamesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyschool'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
