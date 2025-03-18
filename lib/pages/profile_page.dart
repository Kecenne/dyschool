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
import '../widgets/custom_accordion.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  String _formatTroubles(Map<String, dynamic>? troubles) {
    if (troubles == null) return 'Non renseigné';
    
    List<String> activeTroubles = [];
    troubles.forEach((key, value) {
      if (value == true) {
        String capitalizedTrouble = key[0].toUpperCase() + key.substring(1);
        activeTroubles.add(capitalizedTrouble);
      }
    });
    
    return activeTroubles.isEmpty ? 'Aucun trouble' : activeTroubles.join(', ');
  }

  String _formatAbonnement(Map<String, dynamic>? abonnement) {
    if (abonnement == null) return 'Non renseigné';
    return abonnement['type']?.toString() ?? 'Non renseigné';
  }

  Future<void> _updateParentalControl(bool value) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'controleParental': value,
        });
        setState(() {});
      }
    } catch (e) {
      print("Erreur lors de la mise à jour du contrôle parental: $e");
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(title: "Mon compte"),
              const SizedBox(height: 32),
              FutureBuilder<List<DocumentSnapshot>>(
                future: Future.wait([
                  FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                  FirebaseFirestore.instance.collection('settings').doc(user.uid).get(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var userData = snapshot.data?[0].data() as Map<String, dynamic>?;
                  var settingsData = snapshot.data?[1].data() as Map<String, dynamic>?;
                  String prenom = userData?['prenom'] ?? '';
                  String nom = userData?['nom'] ?? '';
                  String displayName = '$prenom $nom'.trim();
                  if (displayName.isEmpty) {
                    displayName = _generateRandomId();
                  }
                  String? photoUrl = userData?['photoURL'];
                  bool parentalControl = userData?['controleParental'] ?? false;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                            child: photoUrl == null ? const Icon(Icons.person) : null,
                          ),
                          const SizedBox(width: 24),
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      const Text(
                        "Paramètres",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomAccordion(
                        title: "Informations personnelles",
                        content: Column(
                          children: [
                            _buildInfoRow("Nom", userData?['nom']?.toString() ?? 'Non renseigné'),
                            _buildInfoRow("Prénom", userData?['prenom']?.toString() ?? 'Non renseigné'),
                            _buildInfoRow("Âge", userData?['age']?.toString() ?? 'Non renseigné'),
                            _buildInfoRow(
                              "Troubles", 
                              _formatTroubles(userData?['troubles'] as Map<String, dynamic>?),
                            ),
                            _buildInfoRow(
                              "Abonnement", 
                              _formatAbonnement(userData?['abonnement'] as Map<String, dynamic>?),
                            ),
                          ],
                        ),
                      ),
                      CustomAccordion(
                        title: "Accessibilité",
                        content: Column(
                          children: [
                            _buildInfoRow(
                              "Taille de la police", 
                              "${settingsData?['fontSize']?.toString() ?? '16'}"
                            ),
                            _buildInfoRow(
                              "Thème sombre", 
                              (settingsData?['isDarkMode'] ?? false) ? "Activé" : "Désactivé"
                            ),
                            _buildInfoRow(
                              "Type de police", 
                              settingsData?['selectedFontChoice'] == 2 ? "OpenDyslexic" : "Poppins"
                            ),
                            _buildInfoRow(
                              "Interlignage", 
                              "${settingsData?['lineHeight']?.toString() ?? '1.0'}"
                            ),
                          ],
                        ),
                      ),
                      CustomAccordion(
                        title: "Login et Sécurité",
                        content: Column(
                          children: [
                            _buildInfoRow("Email", user.email ?? 'Non renseigné'),
                            _buildInfoRow("Mot de passe", "••••••••"),
                          ],
                        ),
                      ),
                      CustomAccordion(
                        title: "Contrôle parental",
                        isToggle: true,
                        value: parentalControl,
                        onChanged: (value) {
                          _updateParentalControl(value);
                        },
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _logout(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.black),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "SE DÉCONNECTER",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}