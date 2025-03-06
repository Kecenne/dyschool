import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Récupère les paramètres de l'utilisateur depuis Firestore
  Future<String> getUserFontPreference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('settings').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot['fontPreference'] ?? 'Roboto';
      }
    }
    return 'Roboto';  // Valeur par défaut si non connecté ou préférence non définie
  }

  // Sauvegarde les préférences de police dans Firestore
  Future<void> saveUserFontPreference(String font) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('settings').doc(user.uid).set({
        'fontPreference': font,
      }, SetOptions(merge: true));
    }
  }

  // Récupère la taille de police depuis Firestore
  Future<double> getUserFontSize() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('settings').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return (snapshot['fontSize'] ?? 16.0).toDouble();
      }
    }
    return 16.0;  // Valeur par défaut
  }

  // Sauvegarde la taille de police dans Firestore
  Future<void> saveUserFontSize(double size) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('settings').doc(user.uid).set({
        'fontSize': size,
      }, SetOptions(merge: true));
    }
  }

  // Récupère l'interlignage depuis Firestore
  Future<double> getUserLineHeight() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('settings').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return (data['lineHeight'] ?? 1.5).toDouble();
      }
    }
    return 1.5;  // Valeur par défaut
  }

  // Sauvegarde l'interlignage dans Firestore
  Future<void> saveUserLineHeight(double height) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('settings').doc(user.uid).set({
        'lineHeight': height,
      }, SetOptions(merge: true));
    }
  }

  // Récupère l'état du thème sombre depuis Firestore
  Future<bool> getUserDarkMode() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('settings').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data['isDarkMode'] ?? false;
      }
    }
    return false;  // Valeur par défaut
  }

  // Sauvegarde l'état du thème sombre dans Firestore
  Future<void> saveUserDarkMode(bool isDarkMode) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('settings').doc(user.uid).set({
        'isDarkMode': isDarkMode,
      }, SetOptions(merge: true));
    }
  }
}
