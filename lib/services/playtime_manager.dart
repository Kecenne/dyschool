import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaytimeManager with ChangeNotifier {
  final Map<String, int> _weeklyPlaytime = {
    "Lun": 0, "Mar": 0, "Mer": 0, "Jeu": 0, "Ven": 0, "Sam": 0, "Dim": 0,
  };

  void addPlaytime(int minutes, List<String> gameTypes) async {
    String today = _getCurrentDay();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (!_weeklyPlaytime.containsKey(today)) {
      _weeklyPlaytime[today] = 0;
    }

    _weeklyPlaytime[today] = _weeklyPlaytime[today]! + minutes;

    // Mise à jour du temps de jeu global
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'totalPlaytime': FieldValue.increment(minutes),
    });

    // Mise à jour du temps de jeu par type de jeu
    DocumentReference playtimeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('playtime')
        .doc('types');

    DocumentSnapshot snapshot = await playtimeRef.get();
    Map<String, dynamic> playtimeData = snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};

    for (String type in gameTypes) {
      if (!playtimeData.containsKey(type)) {
        playtimeData[type] = 0;
      }
      playtimeData[type] += minutes;
    }

    await playtimeRef.set(playtimeData);

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
