import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/page_one.dart';
import 'pages/page_two.dart';
import 'pages/page_three.dart';
import 'pages/page_four.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;  // Index 2 pour la page d'accueil

  static const List<Widget> _pages = <Widget>[
    PageOne(),
    PageTwo(),
    HomePage(),
    PageThree(),
    PageFour(),
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
      body: Center(
        child: _pages.elementAt(_selectedIndex),  // Afficher la page sélectionnée
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Page 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Page 3',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Page 4',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,  // Couleur de l'icône sélectionnée
        unselectedItemColor: Colors.grey,  // Couleur des icônes non sélectionnées
        backgroundColor: Colors.white,  // Couleur du fond de la barre de navigation
        onTap: _onItemTapped,
      ),
    );
  }
}
