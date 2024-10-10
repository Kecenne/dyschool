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
}
