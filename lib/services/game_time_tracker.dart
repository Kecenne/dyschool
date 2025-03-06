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

      final playtimeManager = Provider.of<PlaytimeManager>(context, listen: false);
      playtimeManager.addPlaytime((_elapsedSeconds / 60).ceil(), gameTypes);
      
      // Mettre à jour les statistiques mensuelles avec les secondes exactes
      await _updateMonthlyPlaytime(_elapsedSeconds, gameTypes);
      
      _startTime = null;
      _elapsedSeconds = 0;
    }
  }

  // Mettre à jour les statistiques mensuelles
  Future<void> _updateMonthlyPlaytime(int seconds, List<String> gameTypes) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final now = DateTime.now();
    final monthKey = DateFormat('yyyy-MM').format(now);
    
    final batch = _firestore.batch();

    // Ajouter le mois à la collection des mois disponibles
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
    
    // Mise à jour des totaux mensuels
    for (String gameType in gameTypes) {
      DocumentReference monthlyRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('monthly')
          .collection(monthKey)
          .doc(gameType);

      batch.set(monthlyRef, {
        'duration': FieldValue.increment(seconds), // Sauvegarder directement en secondes
        'lastUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Mise à jour des totaux globaux
      DocumentReference totalRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('playtime')
          .doc('total')
          .collection('games')
          .doc(gameType);

      batch.set(totalRef, {
        'duration': FieldValue.increment(seconds), // Sauvegarder directement en secondes
        'lastUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
    notifyListeners();
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

    // Récupérer les types de jeu pour ce gameId
    List<String> gameTypes = [];
    for (var game in gamesList) {
      if (game['id'] == gameId) {
        gameTypes = List<String>.from(game['types']);
        break;
      }
    }

    // Récupérer tous les documents en une seule requête
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('playtime')
        .doc('total')
        .collection('games')
        .where(FieldPath.documentId, whereIn: gameTypes)
        .get();

    Duration totalDuration = Duration.zero;
    for (var doc in querySnapshot.docs) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final seconds = (data['duration'] as num).toInt();
        totalDuration += Duration(seconds: seconds);
      }
    }

    return totalDuration;
  }

  // Obtenir le temps de jeu pour un mois spécifique
  Future<Duration> getMonthlyPlaytime(String gameId, String month) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return Duration.zero;

    // Récupérer les types de jeu pour ce gameId
    List<String> gameTypes = [];
    for (var game in gamesList) {
      if (game['id'] == gameId) {
        gameTypes = List<String>.from(game['types']);
        break;
      }
    }

    // Convertir le format du mois (ex: "JANVIER 2024" -> "2024-01")
    final inputFormatter = DateFormat('MMMM yyyy', 'fr_FR');
    final outputFormatter = DateFormat('yyyy-MM');
    final DateTime date = inputFormatter.parse(month.toLowerCase());
    final String monthKey = outputFormatter.format(date);

    // Récupérer tous les documents en une seule requête
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('playtime')
        .doc('monthly')
        .collection(monthKey)
        .where(FieldPath.documentId, whereIn: gameTypes)
        .get();

    Duration totalDuration = Duration.zero;
    for (var doc in querySnapshot.docs) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final seconds = (data['duration'] as num).toInt();
        totalDuration += Duration(seconds: seconds);
      }
    }

    return totalDuration;
  }
}
