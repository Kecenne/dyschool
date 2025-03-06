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
import 'services/playtime_manager.dart';
import 'services/game_time_tracker.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_auth/firebase_auth.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('fr_FR', null);

  Get.put(FavoriteController());
  final settingsService = SettingsService();
  final gameTimeTracker = GameTimeTracker();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MedalManager()),
        ChangeNotifierProvider<GameTimeTracker>.value(
          value: gameTimeTracker,
        ),
        ChangeNotifierProvider<PlaytimeManager>(
          create: (context) => PlaytimeManager(gameTimeTracker),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(settingsService),
        ),
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
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        return previous.fontSize != current.fontSize ||
               previous.lineHeight != current.lineHeight ||
               previous.selectedFontChoice != current.selectedFontChoice ||
               previous.isDarkMode != current.isDarkMode;
      },
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final backgroundColor = isDark ? const Color(0xFF121212) : AppColors.backgroundColor;
        final textColor = isDark ? Colors.white : AppColors.textColor;
        final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

        return GetMaterialApp(
          title: "Dyschool",
          theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
              primary: AppColors.primaryColor,
              secondary: AppColors.secondaryColor,
              background: backgroundColor,
              surface: surfaceColor,
              onBackground: textColor,
            ),
            scaffoldBackgroundColor: backgroundColor,
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize,
                height: state.lineHeight,
              ),
              bodyMedium: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize,
                height: state.lineHeight,
              ),
              titleLarge: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize * 1.5,
                height: state.lineHeight,
              ),
              displayLarge: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize * 2.0,
                height: state.lineHeight,
              ),
              displayMedium: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize * 1.75,
                height: state.lineHeight,
              ),
              displaySmall: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize * 1.5,
                height: state.lineHeight,
              ),
              labelLarge: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize * 0.875,
                height: state.lineHeight,
              ),
            ),
            useMaterial3: true,
            fontFamily: state.selectedFontChoice == 2
                ? 'OpenDyslexic'
                : 'Roboto',
            appBarTheme: AppBarTheme(
              backgroundColor: surfaceColor,
              foregroundColor: textColor,
            ),
            cardTheme: CardTheme(
              color: surfaceColor,
            ),
            dialogTheme: DialogTheme(
              backgroundColor: surfaceColor,
              titleTextStyle: TextStyle(
                color: textColor,
                fontFamily: state.selectedFontChoice == 2
                    ? 'OpenDyslexic'
                    : 'Roboto',
                fontSize: state.fontSize * 1.25,
                height: state.lineHeight,
              ),
            ),
          ),
          getPages: AppRoutes.routes,
          initialRoute: '/',
        );
      },
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