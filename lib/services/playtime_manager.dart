import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'game_time_tracker.dart';

class PlaytimeManager with ChangeNotifier {
  final GameTimeTracker _timeTracker;

  PlaytimeManager(this._timeTracker);

  // Récupère le temps de jeu d'aujourd'hui en secondes
  Duration getTodayPlaytimeDuration() {
    final today = _getCurrentDay();
    return Duration(seconds: _timeTracker.getWeeklyPlaytime()[today] ?? 0);
  }

  // Récupère le temps de jeu total de la semaine en secondes
  Duration getTotalWeeklyPlaytimeDuration() {
    final weeklyPlaytime = _timeTracker.getWeeklyPlaytime();
    int totalSeconds = weeklyPlaytime.values.fold(0, (sum, seconds) => sum + seconds);
    return Duration(seconds: totalSeconds);
  }

  // Récupère le temps de jeu d'aujourd'hui en minutes
  int getTodayPlaytime() {
    return getTodayPlaytimeDuration().inMinutes;
  }

  // Récupère le temps de jeu total de la semaine en minutes
  int getTotalWeeklyPlaytime() {
    return getTotalWeeklyPlaytimeDuration().inMinutes;
  }

  // Récupère les données de temps de jeu hebdomadaire
  Map<String, int> getWeeklyPlaytime() {
    return _timeTracker.getWeeklyPlaytime();
  }

  // Obtenir la liste des mois disponibles
  Future<List<String>> getAvailableMonths() async {
    return _timeTracker.getAvailableMonths();
  }

  // Obtenir le temps total pour un jeu
  Future<Duration> getTotalPlaytime(String gameId) async {
    return _timeTracker.getTotalPlaytime(gameId);
  }

  // Obtenir le temps de jeu pour un mois spécifique
  Future<Duration> getMonthlyPlaytime(String gameId, String month) async {
    return _timeTracker.getMonthlyPlaytime(gameId, month);
  }

  // Récupère le jour actuel au format "Lun", "Mar", etc.
  String _getCurrentDay() {
    Map<int, String> dayMap = {
      1: "Lun", 2: "Mar", 3: "Mer", 4: "Jeu",
      5: "Ven", 6: "Sam", 7: "Dim"
    };
    return dayMap[DateTime.now().weekday] ?? "Lun";
  }
}
