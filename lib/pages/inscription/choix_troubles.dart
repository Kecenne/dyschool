import 'package:flutter/material.dart';
import '/theme/app_color.dart'; // Importez votre fichier de couleurs

class ChoixTroubles extends StatelessWidget {
  const ChoixTroubles({Key? key}) : super(key: key);

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
            const SizedBox(height: 20), // Espace au-dessus des choix

            Expanded(
              child: ListView(
                children: const [
                  CheckboxListTile(
                    title: Text("Dyslexie"),
                    value: false,
                    onChanged: null, // Ajoutez votre logique ici
                  ),
                  CheckboxListTile(
                    title: Text("Dyscalculie"),
                    value: false,
                    onChanged: null, // Ajoutez votre logique ici
                  ),
                  CheckboxListTile(
                    title: Text("Dysgraphie"),
                    value: false,
                    onChanged: null, // Ajoutez votre logique ici
                  ),
                  CheckboxListTile(
                    title: Text("Dysphasie"),
                    value: false,
                    onChanged: null, // Ajoutez votre logique ici
                  ),
                  CheckboxListTile(
                    title: Text("Dysorthographie"),
                    value: false,
                    onChanged: null, // Ajoutez votre logique ici
                  ),
                  CheckboxListTile(
                    title: Text("Trouble de l'attention"),
                    value: false,
                    onChanged: null, // Ajoutez votre logique ici
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Espace au-dessus de la flèche

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Logique pour continuer ou valider les choix
                },
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
