import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedalManager with ChangeNotifier {
  int _goldMedals = 0;
  int _silverMedals = 0;
  int _bronzeMedals = 0;
  DateTime? _firstMedalDate;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int get goldMedals => _goldMedals;
  int get silverMedals => _silverMedals;
  int get bronzeMedals => _bronzeMedals;
  DateTime? get firstMedalDate => _firstMedalDate;
  String? get currentUserId => _auth.currentUser?.uid;

  /// Référence vers le document total des médailles
  DocumentReference<Map<String, dynamic>> _getMedalCountsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('medals').doc('counts');
  }

  /// Référence vers la collection historique des médailles
  CollectionReference<Map<String, dynamic>> _getMedalHistoryRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('medals').doc('history').collection('entries');
  }

  /// Récupère les médailles totales et la date de la première médaille
  Future<void> loadMedals() async {
    String? userId = currentUserId;
    if (userId == null) return;

    // Charger le total des médailles
    DocumentSnapshot<Map<String, dynamic>> doc = await _getMedalCountsRef(userId).get();
    if (doc.exists) {
      _goldMedals = doc.data()?['gold'] ?? 0;
      _silverMedals = doc.data()?['silver'] ?? 0;
      _bronzeMedals = doc.data()?['bronze'] ?? 0;
    }

    // Charger la date de la première médaille
    QuerySnapshot<Map<String, dynamic>> snapshot = await _getMedalHistoryRef(userId)
        .orderBy('timestamp', descending: false)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Timestamp timestamp = snapshot.docs.first['timestamp'];
      _firstMedalDate = timestamp.toDate();
    }

    notifyListeners();
  }

  /// Sauvegarde les médailles totales dans Firestore
  Future<void> _updateMedalCounts() async {
    String? userId = currentUserId;
    if (userId == null) return;

    await _getMedalCountsRef(userId).set({
      'gold': _goldMedals,
      'silver': _silverMedals,
      'bronze': _bronzeMedals,
    }, SetOptions(merge: true));
  }

  /// Ajoute une médaille avec historique et date
  Future<void> _addMedalToHistory(String type) async {
    String? userId = currentUserId;
    if (userId == null) return;

    await _getMedalHistoryRef(userId).add({
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Mettre à jour la première médaille si besoin
    if (_firstMedalDate == null) {
      _firstMedalDate = DateTime.now();
    }
  }

  /// Ajoute une médaille d'or
  void addGoldMedal() {
    _goldMedals++;
    _updateMedalCounts();
    _addMedalToHistory('gold');
    notifyListeners();
  }

  /// Ajoute une médaille d'argent
  void addSilverMedal() {
    _silverMedals++;
    _updateMedalCounts();
    _addMedalToHistory('silver');
    notifyListeners();
  }

  /// Ajoute une médaille de bronze
  void addBronzeMedal() {
    _bronzeMedals++;
    _updateMedalCounts();
    _addMedalToHistory('bronze');
    notifyListeners();
  }

  /// Réinitialise les médailles totales (mais garde l’historique)
  void resetMedals() {
    _goldMedals = 0;
    _silverMedals = 0;
    _bronzeMedals = 0;
    _updateMedalCounts();
    notifyListeners();
  }

  /// Récupère les médailles totales
  Future<Map<String, int>> getTotalMedals() async {
    String? userId = currentUserId;
    if (userId == null) return {'gold': 0, 'silver': 0, 'bronze': 0};

    DocumentSnapshot<Map<String, dynamic>> doc = await _getMedalCountsRef(userId).get();
    if (doc.exists) {
      return {
        'gold': doc.data()?['gold'] ?? 0,
        'silver': doc.data()?['silver'] ?? 0,
        'bronze': doc.data()?['bronze'] ?? 0,
      };
    }

    return {'gold': 0, 'silver': 0, 'bronze': 0};
  }


  /// Récupère les médailles pour un mois donné
  Future<Map<String, int>> getMedalsByMonth(DateTime month) async {
    String? userId = currentUserId;
    if (userId == null) return {'gold': 0, 'silver': 0, 'bronze': 0};

    DateTime start = DateTime(month.year, month.month, 1);
    DateTime end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    QuerySnapshot<Map<String, dynamic>> snapshot = await _getMedalHistoryRef(userId)
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThanOrEqualTo: end)
        .get();

    return {
      'gold': snapshot.docs.where((doc) => doc['type'] == 'gold').length,
      'silver': snapshot.docs.where((doc) => doc['type'] == 'silver').length,
      'bronze': snapshot.docs.where((doc) => doc['type'] == 'bronze').length,
    };
  }
}
