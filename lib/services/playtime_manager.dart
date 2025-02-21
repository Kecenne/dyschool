import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaytimeManager with ChangeNotifier {
  final Map<String, int> _weeklyPlaytime = {
    "Lun": 0, "Mar": 0, "Mer": 0, "Jeu": 0, "Ven": 0, "Sam": 0, "Dim": 0,
  };

  PlaytimeManager() {
    loadWeeklyPlaytime();
    checkForNewWeek();
  }

  /// Charge le temps de jeu de la semaine depuis Firestore
  Future<void> loadWeeklyPlaytime() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('playtime').doc('weekly').get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      _weeklyPlaytime.clear();

      data.forEach((key, value) {
        _weeklyPlaytime[key] = (value as num).toInt();
      });

      notifyListeners();
    }
  }

  /// Met à jour Firestore après chaque modification du temps de jeu
  Future<void> _updateFirestoreWeeklyPlaytime() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).collection('playtime').doc('weekly').set(_weeklyPlaytime);
  }

  /// Ajoute du temps de jeu pour aujourd’hui et enregistre dans Firestore
  void addPlaytime(int minutes, List<String> gameTypes) async {
    String today = _getCurrentDay();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (!_weeklyPlaytime.containsKey(today)) {
      _weeklyPlaytime[today] = 0;
    }

    _weeklyPlaytime[today] = _weeklyPlaytime[today]! + minutes;
    await _updateFirestoreWeeklyPlaytime();

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

  /// Vérifie si une nouvelle semaine a commencé et réinitialise uniquement le graphe si nécessaire
  void checkForNewWeek() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DateTime now = DateTime.now();
    String lastResetKey = "lastResetWeek";

    FirebaseFirestore.instance.collection('users').doc(userId).get().then((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey(lastResetKey)) {
        DateTime lastReset = (snapshot.data()![lastResetKey] as Timestamp).toDate();
        if (now.difference(lastReset).inDays >= 7) {
          _resetWeeklyPlaytime();
          FirebaseFirestore.instance.collection('users').doc(userId).update({
            lastResetKey: FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Première initialisation
        FirebaseFirestore.instance.collection('users').doc(userId).set({
          lastResetKey: FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }

  /// Réinitialise uniquement l'affichage du graphe (pas Firestore)
  void _resetWeeklyPlaytime() {
    _weeklyPlaytime.updateAll((key, value) => 0);
    notifyListeners();
  }

  Map<String, int> getWeeklyPlaytime() => _weeklyPlaytime;

  /// Retourne le temps de jeu d’aujourd’hui
  int getTodayPlaytime() {
    return _weeklyPlaytime[_getCurrentDay()] ?? 0;
  }

  /// Retourne le total du temps joué sur les 7 derniers jours
  int getTotalWeeklyPlaytime() {
    return _weeklyPlaytime.values.fold(0, (sum, minutes) => sum + minutes);
  }

  

  /// Retourne le jour actuel sous le format "Lun", "Mar", etc.
  String _getCurrentDay() {
    Map<int, String> dayMap = {
      1: "Lun", 2: "Mar", 3: "Mer", 4: "Jeu",
      5: "Ven", 6: "Sam", 7: "Dim"
    };

    return dayMap[DateTime.now().weekday] ?? "Lun";
  }
}
