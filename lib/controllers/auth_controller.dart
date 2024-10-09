import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Inscription de l'utilisateur avec email et mot de passe
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enregistre l'utilisateur dans Firestore avec des champs de base
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
        'createdAt': FieldValue.serverTimestamp(),
        'nom': '',  // Initialisé vide, à remplir plus tard
        'prenom': '',  // Initialisé vide, à remplir plus tard
        'dyslexie': false,
        'dyscalculie': false,
        'dysgraphie': false,
        'dysphasie': false,
        'dysorthographie': false,
        'troubleAttention': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Mise à jour des informations après la saisie du nom, prénom, et troubles
  Future<void> updateUserProfile(String userId, String nom, String prenom, Map<String, bool> troublesDys) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'nom': nom,
        'prenom': prenom,
        'dyslexie': troublesDys['dyslexie'] ?? false,
        'dyscalculie': troublesDys['dyscalculie'] ?? false,
        'dysgraphie': troublesDys['dysgraphie'] ?? false,
        'dysphasie': troublesDys['dysphasie'] ?? false,
        'dysorthographie': troublesDys['dysorthographie'] ?? false,
        'troubleAttention': troublesDys['troubleAttention'] ?? false,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Connexion de l'utilisateur
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Envoi d'un email de vérification
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
