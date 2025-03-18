import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_history.dart';
import '../data/games_data.dart';

class GameHistoryController extends GetxController {
  final _recentGames = <Map<String, dynamic>>[].obs;
  
  List<Map<String, dynamic>> get recentGames => _recentGames;
  
  @override
  void onInit() {
    super.onInit();
    loadRecentGames();
  }

  String _getGameIdFromRoute(String route) {
    String cleanRoute = route.startsWith('/') ? route.substring(1) : route;
    final parts = cleanRoute.split('/');
    
    if (parts.length > 1 && parts[0] == 'jeu') {
      return parts[1];
    }
    
    return parts.last;
  }

  Future<void> loadRecentGames() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _setRandomGames();
        return;
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('gameHistory')
          .orderBy('playedAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        _setRandomGames();
        return;
      }

      final List<Map<String, dynamic>> recentGamesList = [];
      
      for (var doc in snapshot.docs) {
        final gameId = doc.data()['gameId'] as String;
        final game = gamesList.firstWhere(
          (g) => g['id'] == gameId,
          orElse: () => {} as Map<String, dynamic>,
        );
        
        if (game.isNotEmpty && !recentGamesList.contains(game)) {
          recentGamesList.add(game);
          if (recentGamesList.length >= 5) break;
        }
      }

      if (recentGamesList.length < 5) {
        final remainingGames = gamesList
            .where((g) => !recentGamesList.contains(g))
            .toList()..shuffle();
        
        recentGamesList.addAll(
          remainingGames.take(5 - recentGamesList.length)
        );
      }

      _recentGames.value = recentGamesList;
    } catch (e) {
      _setRandomGames();
    }
  }

  void _setRandomGames() {
    final shuffledGames = List<Map<String, dynamic>>.from(gamesList)..shuffle();
    _recentGames.value = shuffledGames.take(5).toList();
  }

  Future<void> addGameToHistory(String route) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final gameId = _getGameIdFromRoute(route);
      final game = gamesList.firstWhere(
        (g) => g['id'] == gameId,
        orElse: () => {} as Map<String, dynamic>
      );

      if (game.isEmpty) return;

      final gameHistoryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('gameHistory');

      await gameHistoryRef.add({
        'gameId': gameId,
        'playedAt': FieldValue.serverTimestamp(),
      });

      final snapshot = await gameHistoryRef
          .orderBy('playedAt', descending: true)
          .get();

      if (snapshot.docs.length > 5) {
        final docsToDelete = snapshot.docs.sublist(5);
        
        final batch = FirebaseFirestore.instance.batch();
        for (var doc in docsToDelete) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      await loadRecentGames();
    } catch (e) {
      // Silently handle error
    }
  }
} 