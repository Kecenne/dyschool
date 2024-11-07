import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../theme/app_color.dart';
import '../controllers/auth_controller.dart';
import '../bloc/settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/page_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    final authController = Auth();

    await authController.signOut(BlocProvider.of<SettingsBloc>(context));
    print("Déconnexion réussie");
    Get.offAllNamed('/login');
  }

  String _generateRandomId() {
    var rng = Random();
    return 'User_${rng.nextInt(100000)}';
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const PageHeader(title: "Profil"),
            const SizedBox(height: 16),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  var userData = snapshot.data!.data() as Map<String, dynamic>?;

                  String displayName;
                  if (userData != null && userData.containsKey('nom') && userData.containsKey('prenom')) {
                    String nom = userData['nom'] ?? '';
                    String prenom = userData['prenom'] ?? '';
                    displayName = '$prenom $nom';
                  } else {
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
                          onPressed: () => _logout(context),
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
                  return Center(child: Text('Aucune donnée disponible'));
                }
              },
            ),
          ],
        ),
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