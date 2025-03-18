import 'dart:async';
import 'package:flutter/material.dart';
import 'playtime_manager.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../data/games_data.dart';

class GameTimeTracker with ChangeNotifier {
  DateTime? _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, int> _weeklyPlaytime = {
    "Lun": 0, "Mar": 0, "Mer": 0, "Jeu": 0, "Ven": 0, "Sam": 0, "Dim": 0
  };

  GameTimeTracker() {
    _loadWeeklyData(); // Charger les données au démarrage
  }

  int get elapsedSeconds => _elapsedSeconds;

  void startTimer() {
    _startTime = DateTime.now();
    _elapsedSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void stopTimer(BuildContext context, List<String> gameTypes) async {
    if (_startTime != null) {
      _timer?.cancel();
      
      // Centraliser la mise à jour du temps de jeu
      await _updateAllPlaytime(_elapsedSeconds, gameTypes);
      
      _startTime = null;
      _elapsedSeconds = 0;
    }
  }

  // Charger les données hebdomadaires depuis Firestore
  Future<void> _loadWeeklyData() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      DocumentSnapshot weeklySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('weekly')
          .get();

      if (weeklySnapshot.exists) {
        Map<String, dynamic> weeklyData = weeklySnapshot.data() as Map<String, dynamic>;
        _weeklyPlaytime = Map<String, int>.from(weeklyData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading weekly data: $e');
    }
  }

  // Méthode centralisée pour mettre à jour tout le temps de jeu
  Future<void> _updateAllPlaytime(int seconds, List<String> gameTypes) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final now = DateTime.now();
    final monthKey = DateFormat('yyyy-MM').format(now);
    final batch = _firestore.batch();

    // 1. Mise à jour du temps hebdomadaire
    String today = _getCurrentDay();
    DocumentReference weeklyRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('playtime')
        .doc('weekly');

    DocumentSnapshot weeklySnapshot = await weeklyRef.get();
    Map<String, dynamic> weeklyData = weeklySnapshot.exists ? weeklySnapshot.data() as Map<String, dynamic> : {};
    
    // Mettre à jour le temps pour aujourd'hui
    if (!weeklyData.containsKey(today)) {
      weeklyData[today] = 0;
    }
    weeklyData[today] = (weeklyData[today] as num).toInt() + seconds;
    
    // Mettre à jour _weeklyPlaytime localement avec le bon format
    _weeklyPlaytime = Map<String, int>.from(weeklyData);
    debugPrint('Updated weekly playtime: $_weeklyPlaytime'); // Pour le débogage
    
    batch.set(weeklyRef, weeklyData);

    // 2. Mise à jour du temps total global
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'totalPlaytime': FieldValue.increment(seconds / 60), // Garder en minutes pour compatibilité
    });

    // 3. Mise à jour du temps mensuel
    DocumentReference monthRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('playtime')
        .doc('monthly')
        .collection('months')
        .doc(monthKey);

    batch.set(monthRef, {
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 4. Identifier le jeu et mettre à jour son temps
    String gameId = _getGameIdFromTypes(gameTypes);
    if (gameId.isNotEmpty) {
      // Mise à jour du temps pour le jeu spécifique (mensuel)
      DocumentReference monthlyGameRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('monthly')
          .collection(monthKey)
          .doc('games')
          .collection('details')
          .doc(gameId);

      batch.set(monthlyGameRef, {
        'duration': FieldValue.increment(seconds),
        'lastUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Mise à jour du temps pour le jeu spécifique (total)
      DocumentReference totalGameRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('total')
          .collection('games')
          .doc(gameId);

      batch.set(totalGameRef, {
        'duration': FieldValue.increment(seconds),
        'lastUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Mise à jour du temps pour le jeu spécifique (hebdomadaire)
      DocumentReference weeklyGameRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('games');

      DocumentSnapshot gameSnapshot = await weeklyGameRef.get();
      Map<String, dynamic> gamePlaytimeData = gameSnapshot.exists ? gameSnapshot.data() as Map<String, dynamic> : {};

      if (!gamePlaytimeData.containsKey(gameId)) {
        gamePlaytimeData[gameId] = 0;
      }
      gamePlaytimeData[gameId] += seconds;

      batch.set(weeklyGameRef, gamePlaytimeData);
    }

    await batch.commit();
    await _loadWeeklyData(); // Recharger les données après la mise à jour
    notifyListeners();
  }

  /// Retourne le jour actuel sous le format "Lun", "Mar", etc.
  String _getCurrentDay() {
    Map<int, String> dayMap = {
      1: "Lun", 2: "Mar", 3: "Mer", 4: "Jeu",
      5: "Ven", 6: "Sam", 7: "Dim"
    };

    String day = dayMap[DateTime.now().weekday] ?? "Lun";
    debugPrint('Current day: $day'); // Pour le débogage
    return day;
  }

  // Identifier le jeu à partir des types
  String _getGameIdFromTypes(List<String> gameTypes) {
    if (gameTypes.isEmpty) return '';
    
    // Parcourir tous les jeux pour trouver celui qui correspond exactement aux types fournis
    for (var game in gamesList) {
      List<String> types = List<String>.from(game['types']);
      if (types.length == gameTypes.length && 
          types.every((type) => gameTypes.contains(type)) &&
          gameTypes.every((type) => types.contains(type))) {
        return game['id'];
      }
    }
    
    // Si aucun jeu exact n'est trouvé, retourner vide
    return '';
  }

  // Obtenir la liste des mois disponibles
  Future<List<String>> getAvailableMonths() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    QuerySnapshot monthsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('playtime')
        .doc('monthly')
        .collection('months')
        .orderBy('timestamp', descending: true)
        .get();

    List<String> months = [];
    final DateFormat inputFormatter = DateFormat('yyyy-MM');
    final DateFormat outputFormatter = DateFormat('MMMM yyyy', 'fr_FR');

    for (var doc in monthsSnapshot.docs) {
      try {
        DateTime date = inputFormatter.parse(doc.id);
        String formattedMonth = outputFormatter.format(date).toUpperCase();
        months.add(formattedMonth);
      } catch (e) {
        debugPrint('Error parsing date: ${doc.id}');
      }
    }

    return months;
  }

  // Obtenir le temps total pour un jeu
  Future<Duration> getTotalPlaytime(String gameId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return Duration.zero;

    // Récupérer directement la durée pour ce jeu spécifique
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('total')
          .collection('games')
          .doc(gameId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final seconds = (data['duration'] as num?)?.toInt() ?? 0;
        return Duration(seconds: seconds);
      }
    } catch (e) {
      debugPrint('Error getting total playtime: $e');
    }
    
    return Duration.zero;
  }

  // Obtenir le temps de jeu pour un mois spécifique
  Future<Duration> getMonthlyPlaytime(String gameId, String month) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return Duration.zero;

    // Convertir le format du mois (ex: "JANVIER 2024" -> "2024-01")
    final inputFormatter = DateFormat('MMMM yyyy', 'fr_FR');
    final outputFormatter = DateFormat('yyyy-MM');
    final DateTime date = inputFormatter.parse(month.toLowerCase());
    final String monthKey = outputFormatter.format(date);

    // Récupérer directement la durée pour ce jeu spécifique dans ce mois
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('monthly')
          .collection(monthKey)
          .doc('games')
          .collection('details')
          .doc(gameId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final seconds = (data['duration'] as num?)?.toInt() ?? 0;
        return Duration(seconds: seconds);
      }
    } catch (e) {
      debugPrint('Error getting monthly playtime: $e');
    }
    
    return Duration.zero;
  }

  // Récupère le temps de jeu hebdomadaire
  Map<String, int> getWeeklyPlaytime() {
    return _weeklyPlaytime;
  }

  // Récupère le temps de jeu d'aujourd'hui en secondes
  int getTodayPlaytime() {
    String today = _getCurrentDay();
    return _weeklyPlaytime[today] ?? 0;
  }

  // Récupère le temps de jeu d'aujourd'hui formaté (ex: "2 min 30 sec")
  String getTodayPlaytimeFormatted() {
    int seconds = getTodayPlaytime();
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return "$minutes min ${remainingSeconds > 0 ? '$remainingSeconds sec' : ''}";
    } else {
      return "$seconds sec";
    }
  }
}
