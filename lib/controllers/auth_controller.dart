import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> createUserWithEmailAndPassword(String email, String password, SettingsBloc settingsBloc) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
        'createdAt': FieldValue.serverTimestamp(),
        'nom': '',
        'prenom': '',
        'dyslexie': false,
        'dyspraxie': false,
        'dyscalculie': false,
        'dysgraphie': false,
        'dysphasie': false,
        'dysorthographie': false,
        'dysexecutif': false,
      });

      await _firestore.collection('settings').doc(userCredential.user?.uid).set({
        'fontPreference': 'Roboto',
      });

      settingsBloc.add(LoadFontPreferenceEvent());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfile(String userId, String nom, String prenom, Map<String, bool> troublesDys) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'nom': nom,
        'prenom': prenom,
        'dyslexie': troublesDys['dyslexie'] ?? false,
        'dyspraxie': troublesDys['dyspraxie'] ?? false,
        'dyscalculie': troublesDys['dyscalculie'] ?? false,
        'dysgraphie': troublesDys['dysgraphie'] ?? false,
        'dysphasie': troublesDys['dysphasie'] ?? false,
        'dysorthographie': troublesDys['dysorthographie'] ?? false,
        'dysexecutif': troublesDys['dysexecutif'] ?? false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password, SettingsBloc settingsBloc) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      settingsBloc.add(LoadFontPreferenceEvent());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut(SettingsBloc settingsBloc) async {
    print("Tentative de déconnexion..."); 
    try {
      await _firebaseAuth.signOut();
      print("Déconnexion effectuée");

      settingsBloc.add(ResetSettingsEvent()); 
      print("ResetSettingsEvent envoyé"); 
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
      rethrow;
    }
  }




  Future<void> sendVerificationEmail(User user) async {
    if (!user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print("Un email de vérification a été envoyé.");
      } catch (e) {
        print("Erreur lors de l'envoi de l'email de vérification: $e");
      }
    }
  }
}
