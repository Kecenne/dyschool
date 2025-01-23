import 'package:flutter/material.dart';

class PlaytimeManager with ChangeNotifier {
  final Map<String, int> _weeklyPlaytime = {
    "Lun": 0, "Mar": 0, "Mer": 0, "Jeu": 0, "Ven": 0, "Sam": 0, "Dim": 0,
  };

void addPlaytime(int minutes) {
  String today = _getCurrentDay();

  if (!_weeklyPlaytime.containsKey(today)) {
    _weeklyPlaytime[today] = 0;
  }

  _weeklyPlaytime[today] = _weeklyPlaytime[today]! + minutes;

  notifyListeners();
}

  Map<String, int> getWeeklyPlaytime() => _weeklyPlaytime;

  int getTodayPlaytime() {
    return _weeklyPlaytime[_getCurrentDay()] ?? 0;
  }

  int getTotalWeeklyPlaytime() {
    return _weeklyPlaytime.values.fold(0, (sum, minutes) => sum + minutes);
  }

  void resetWeeklyPlaytime() {
    _weeklyPlaytime.updateAll((key, value) => 0);
    notifyListeners();
  }

  String _getCurrentDay() {
    Map<int, String> dayMap = {
      1: "Lun", 2: "Mar", 3: "Mer", 4: "Jeu",
      5: "Ven", 6: "Sam", 7: "Dim"
    };

    return dayMap[DateTime.now().weekday] ?? "Lun";
  }
}