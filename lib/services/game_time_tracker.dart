import 'dart:async';
import 'package:flutter/material.dart';
import 'playtime_manager.dart';
import 'package:provider/provider.dart';

class GameTimeTracker with ChangeNotifier {
  DateTime? _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  int get elapsedSeconds => _elapsedSeconds;

  void startTimer() {
    _startTime = DateTime.now();
    _elapsedSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void stopTimer(BuildContext context, List<String> gameTypes) {
    if (_startTime != null) {
      _timer?.cancel();
      int minutesPlayed = (_elapsedSeconds / 60).ceil();

      final playtimeManager = Provider.of<PlaytimeManager>(context, listen: false);
      playtimeManager.addPlaytime(minutesPlayed, gameTypes);
      
      _startTime = null;
      _elapsedSeconds = 0;
    }
  }
}
