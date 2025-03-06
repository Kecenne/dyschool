import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../pages/games_page.dart';
import '../pages/template_jeu.dart';
import '../pages/splash_screen.dart';
import '../main.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/games', page: () => const GamesPage()),
    GetPage(name: '/main', page: () => const MainPage()),
    GetPage(
      name: '/jeu/:id',
      page: () => const TemplateJeuPage(),
    ),
  ];
}