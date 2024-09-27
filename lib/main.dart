import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "widgets/navbar.dart";
import "../controllers/nav_controller.dart";
import "pages/login_page.dart";
import "theme/app_color.dart"; // Importez votre fichier de couleurs

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Dyschool",
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textColor), // Mise à jour ici
          bodyMedium: TextStyle(color: AppColors.textColor), // Mise à jour ici
        ),
        useMaterial3: true,
        fontFamily: 'OpenDyslexic',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2, milliseconds: 200), () {
      // Redirection vers la page de connexion
      Get.off(() => const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Utilisation de la couleur de fond
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

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NavController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dyschool"),
      ),
      body: const BodyContent(),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavController>();
    return Obx(() => navController.pages[navController.selectedIndex.value]);
  }
}
