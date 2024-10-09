import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../login/login_input.dart';
import '../login/login_button.dart';

class TroublesForm extends StatefulWidget {
  final VoidCallback onTroublesSaved;

  const TroublesForm({Key? key, required this.onTroublesSaved}) : super(key: key);

  @override
  _TroublesFormState createState() => _TroublesFormState();
}

class _TroublesFormState extends State<TroublesForm> {
  // Variables pour les troubles
  bool dyslexie = false;
  bool dyscalculie = false;
  bool dysgraphie = false;
  bool dysphasie = false;
  bool dysorthographie = false;
  bool troubleAttention = false;

  // Contrôleurs pour le nom et le prénom
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();

  Future<void> _saveTroubles() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Enregistrer les informations dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'nom': nomController.text,
        'prenom': prenomController.text,
        'troubles': {
          'dyslexie': dyslexie,
          'dyscalculie': dyscalculie,
          'dysgraphie': dysgraphie,
          'dysphasie': dysphasie,
          'dysorthographie': dysorthographie,
          'troubleAttention': troubleAttention,
        },
      });

      // Appeler le callback pour notifier que les troubles ont été enregistrés
      widget.onTroublesSaved();
    } else {
      Get.snackbar("Erreur", "Utilisateur non connecté", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center( // Centre le formulaire entier
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
          crossAxisAlignment: CrossAxisAlignment.center, // Centre horizontalement
          children: [
            // Titre pour les informations de l'enfant
            const Text(
              "Entrer les informations de l'enfant",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Champs pour le nom et le prénom
            LoginInput(
              label: "Nom",
              controller: nomController,
            ),
            const SizedBox(height: 20),
            LoginInput(
              label: "Prénom",
              controller: prenomController,
            ),
            const SizedBox(height: 20),

            // Titre pour le choix des troubles
            const Text(
              "Choisissez les troubles de l'enfant",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Container pour centrer les checkboxes et limiter la largeur
            Container(
              width: 600, // Assure que la largeur est la même que les inputs et boutons
              child: Wrap(
                alignment: WrapAlignment.center, // Centre horizontalement
                runAlignment: WrapAlignment.center, // Centre verticalement
                spacing: 10.0, // Espace horizontal entre les checkboxes
                runSpacing: 10.0, // Espace vertical entre les checkboxes
                children: [
                  _buildCheckbox("Dyslexie", dyslexie, (value) {
                    setState(() {
                      dyslexie = value ?? false;
                    });
                  }),
                  _buildCheckbox("Dyscalculie", dyscalculie, (value) {
                    setState(() {
                      dyscalculie = value ?? false;
                    });
                  }),
                  _buildCheckbox("Dysgraphie", dysgraphie, (value) {
                    setState(() {
                      dysgraphie = value ?? false;
                    });
                  }),
                  _buildCheckbox("Dysphasie", dysphasie, (value) {
                    setState(() {
                      dysphasie = value ?? false;
                    });
                  }),
                  _buildCheckbox("Dysorthographie", dysorthographie, (value) {
                    setState(() {
                      dysorthographie = value ?? false;
                    });
                  }),
                  _buildCheckbox("Trouble de l'attention", troubleAttention, (value) {
                      setState(() {
                        troubleAttention = value ?? false;
                      });
                    }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bouton pour valider
            LoginButton(
              text: "Valider",
              onPressed: _saveTroubles,
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer des Checkbox avec une largeur ajustée
  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      width: 280, // Largeur ajustée pour permettre plusieurs checkboxes par ligne
      child: CheckboxListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 24), // Taille de police cohérente
        ),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading, // Place la case à cocher à gauche
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0), // Enlever le padding par défaut
      ),
    );
  }
}