import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/navbar.dart';
import 'controllers/nav_controller.dart';
import 'controllers/favorite_controller.dart';
import 'theme/app_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controllers/routes_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_state.dart';
import 'services/settings_service.dart';
import 'bloc/settings_event.dart';
import 'services/medal_manager.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(FavoriteController());
  final settingsService = SettingsService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MedalManager()), // 🔥 Ajout de MedalManager
        BlocProvider(create: (context) => SettingsBloc(settingsService)..add(LoadFontPreferenceEvent())),
      ],
      child: MyApp(settingsService: settingsService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SettingsService settingsService;
  const MyApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService();

    return BlocProvider(
      create: (context) => SettingsBloc(settingsService)..add(LoadFontPreferenceEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
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
                bodyLarge: TextStyle(
                  color: AppColors.textColor,
                  fontFamily: state.selectedFontChoice == 2
                      ? 'OpenDyslexic'
                      : 'Roboto',
                ),
                bodyMedium: TextStyle(
                  color: AppColors.textColor,
                  fontFamily: state.selectedFontChoice == 2
                      ? 'OpenDyslexic'
                      : 'Roboto',
                ),
                titleLarge: TextStyle(
                  color: AppColors.textColor,
                  fontFamily: state.selectedFontChoice == 2
                      ? 'OpenDyslexic'
                      : 'Roboto',
                ),
              ),
              useMaterial3: true,
              fontFamily: state.selectedFontChoice == 2
                  ? 'OpenDyslexic'
                  : 'Roboto',
            ),
            getPages: AppRoutes.routes,
            initialRoute: '/',
          );
        },
      ),
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.offNamed('/main');
      } else {
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

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NavController());

    final GlobalKey favoriteIconKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dyschool"),
      ),
      body: const BodyContent(),
      bottomNavigationBar: CustomBottomNavBar(favoriteIconKey: favoriteIconKey),
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