import 'package:flutter/material.dart';
import '../../theme/app_color.dart'; // Importez votre fichier de couleurs
import 'choix_troubles.dart';
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  // Définir une constante pour la largeur de la bordure
  final double borderThickness = 4.0; // Change cette valeur pour ajuster la taille de la bordure

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: Column(
        children: [
          // Grand fond rectangulaire en couleur primaire, collé aux bords
          Container(
            height: MediaQuery.of(context).size.height / 3, // Prendre 1/3 de la hauteur de l'écran
            width: double.infinity, // Largeur de 100%
            color: AppColors.primaryColor, // Couleur de fond primaire
            child: const Center(
              child: Text(
                "DYSCHOOL",
                style: TextStyle(
                  fontFamily: 'OpenDyslexic', // Appliquer la police Open Dyslexic
                  color: Colors.white, // Couleur du texte
                  fontSize: 60, // Taille de police
                  fontWeight: FontWeight.bold, // Mettre le texte en gras
                ),
              ),
            ),
          ),

          const SizedBox(height: 100), // Espace au-dessus des inputs

          // Champs de texte pour l'email, le mot de passe et la confirmation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: 475, // Même largeur que le bouton
                  height: 100, // Même hauteur que le bouton
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 30, bottom: 30), // Ajoute du padding à gauche
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500]), // Change la couleur du placeholder
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bordure arrondie
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness, // Utiliser la variable pour la largeur de la bordure
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bordure arrondie
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness, // Utiliser la variable pour la largeur de la bordure
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5), // Ajuster la taille et hauteur du texte
                  ),
                ),
                const SizedBox(height: 20), // Espace entre les champs

                SizedBox(
                  width: 475, // Même largeur que le bouton
                  height: 100, // Même hauteur que le bouton
                  child: TextField(
                    obscureText: true, // Cache le mot de passe
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 30, bottom: 30), // Ajoute du padding à gauche
                      hintText: 'Mot de passe',
                      hintStyle: TextStyle(color: Colors.grey[500]), // Change la couleur du placeholder
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness, // Utiliser la variable pour la largeur de la bordure
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness, // Utiliser la variable pour la largeur de la bordure
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5), // Ajuster la taille et hauteur du texte
                  ),
                ),
                const SizedBox(height: 20), // Espace entre les champs

                SizedBox(
                  width: 475, // Même largeur que le bouton
                  height: 100, // Même hauteur que le bouton
                  child: TextField(
                    obscureText: true, // Cache le mot de passe
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 30, bottom: 30), // Ajoute du padding à gauche
                      hintText: 'Confirmer le mot de passe',
                      hintStyle: TextStyle(color: Colors.grey[500]), // Change la couleur du placeholder
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness, // Utiliser la variable pour la largeur de la bordure
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness, // Utiliser la variable pour la largeur de la bordure
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5), // Ajuster la taille et hauteur du texte
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20), // Espace entre les champs et le bouton

          // Bouton "Inscription"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChoixTroubles()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor, // Couleur de fond
                foregroundColor: AppColors.textColor, // Couleur du texte
                fixedSize: const Size(475, 100), // Taille fixe, largeur 475 et hauteur 100
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordure arrondie
                ),
              ),
              child: const Text(
                "INSCRIPTION",
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold, // Mettre le texte en gras
                  fontSize: 30, // Taille de police augmentée
                ), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
