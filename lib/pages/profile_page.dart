import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:math'; // Pour générer un identifiant aléatoire
import '../theme/app_color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Méthode pour gérer la déconnexion
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login'); // Naviguer vers LoginPage et supprimer toutes les routes précédentes
  }

  // Méthode pour générer un identifiant aléatoire
  String _generateRandomId() {
    var rng = Random();
    return 'User_${rng.nextInt(100000)}'; // Génère un nombre aléatoire entre 0 et 99999
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Vérifier si l'utilisateur est connecté
    if (user == null) {
      // Si l'utilisateur n'est pas connecté, rediriger vers la page de connexion
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          // Gérer les états de la future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // En attente des données
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // En cas d'erreur
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Les données sont disponibles
            var userData = snapshot.data!.data() as Map<String, dynamic>?;

            String displayName;
            if (userData != null && userData.containsKey('nom') && userData.containsKey('prenom')) {
              String nom = userData['nom'] ?? '';
              String prenom = userData['prenom'] ?? '';
              displayName = '$prenom $nom';
            } else {
              // Générer un identifiant aléatoire si le nom n'est pas disponible
              displayName = _generateRandomId();
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.person, size: 60, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    displayName,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        buildMenuOption(context, "Paiement"),
                        const SizedBox(height: 20),
                        buildMenuOption(context, "Informations personnelles"),
                        const SizedBox(height: 20),
                        buildMenuOption(context, "Personnalisation de l'interface"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _logout, // Appel de la méthode _logout lors du clic
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Se déconnecter",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          } else {
            // Aucune donnée disponible
            return Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }

  Widget buildMenuOption(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }
}