import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importez Cloud Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart'; // Importez GetX pour la navigation
import 'package:dyschool/main.dart'; // Importez votre MainPage

class ChoixTroubles extends StatefulWidget {
  const ChoixTroubles({Key? key}) : super(key: key);

  @override
  _ChoixTroublesState createState() => _ChoixTroublesState();
}

class _ChoixTroublesState extends State<ChoixTroubles> {
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
      // Créez un document pour l'utilisateur avec son nom, prénom et les troubles choisis
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

      // Naviguez vers la MainPage après l'enregistrement
      Get.off(() => const MainPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choix des Troubles"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Sélectionnez les troubles de l'enfant",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),

            // Liste des troubles avec des Checkbox
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: const Text("Dyslexie"),
                    value: dyslexie,
                    onChanged: (bool? value) {
                      setState(() {
                        dyslexie = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Dyscalculie"),
                    value: dyscalculie,
                    onChanged: (bool? value) {
                      setState(() {
                        dyscalculie = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Dysgraphie"),
                    value: dysgraphie,
                    onChanged: (bool? value) {
                      setState(() {
                        dysgraphie = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Dysphasie"),
                    value: dysphasie,
                    onChanged: (bool? value) {
                      setState(() {
                        dysphasie = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Dysorthographie"),
                    value: dysorthographie,
                    onChanged: (bool? value) {
                      setState(() {
                        dysorthographie = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Trouble de l'attention"),
                    value: troubleAttention,
                    onChanged: (bool? value) {
                      setState(() {
                        troubleAttention = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Champs pour le nom et le prénom
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),

            const SizedBox(height: 20),

            // Bouton pour valider
            ElevatedButton(
              onPressed: _saveTroubles,
              child: const Text("Valider"),
            ),
          ],
        ),
      ),
    );
  }
}
