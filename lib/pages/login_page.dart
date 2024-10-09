import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_color.dart'; // Importez votre fichier de couleurs
import 'inscription/sign_up_page.dart'; // Importez la page d'inscription
import './connexion/connexion_page.dart'; // Importe la page ConnexionPage
import './inscription/choix_troubles.dart'; // Importez la page ChoixTroubles
import '../main.dart'; // Importe la page MainPage

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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

          const SizedBox(height: 20), // Espace au-dessus des boutons

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton "Se connecter"
                    ElevatedButton(
                      onPressed: () {
                        // Redirection directe vers ConnexionPage
                        Get.to(() => const ConnexionPage());
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
                        "SE CONNECTER",
                        style: TextStyle(
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.bold, // Mettre le texte en gras
                          fontSize: 30, // Taille de police augmentée
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // Espace entre les boutons

                    // Bouton "S'inscrire"
                    OutlinedButton(
                      onPressed: () {
                        // Redirection vers la page d'inscription
                        Get.to(() => const SignUpPage()); // Rediriger vers la page SignUpPage
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.primaryColor,
                          width: 4, // Épaisseur de la bordure augmentée
                        ),
                        fixedSize: const Size(475, 100), // Taille fixe, largeur 475 et hauteur 100
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordure arrondie
                        ),
                      ),
                      child: Text(
                        "S'INSCRIRE",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold, // Mettre le texte en gras
                          fontSize: 30, // Taille de police augmentée
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // Espace entre les boutons

                    // Nouveau bouton pour accéder directement à ChoixTroubles
                    ElevatedButton(
                      onPressed: () {
                        // Redirection vers ChoixTroubles
                        Get.to(() => const ChoixTroubles());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Couleur de fond pour différencier le bouton
                        foregroundColor: Colors.white, // Couleur du texte
                        fixedSize: const Size(475, 100), // Taille fixe, largeur 475 et hauteur 100
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordure arrondie
                        ),
                      ),
                      child: const Text(
                        "CHOISIR LES TROUBLES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Mettre le texte en gras
                          fontSize: 30, // Taille de police augmentée
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // Espace entre les boutons

                    // Bouton pour accéder directement à MainPage
                    ElevatedButton(
                      onPressed: () {
                        // Redirection vers MainPage
                        Get.to(() => const MainPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Couleur de fond pour différencier le bouton
                        foregroundColor: Colors.white, // Couleur du texte
                        fixedSize: const Size(475, 100), // Taille fixe, largeur 475 et hauteur 100
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordure arrondie
                        ),
                      ),
                      child: const Text(
                        "ACCÉDER À LA MAIN PAGE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Mettre le texte en gras
                          fontSize: 30, // Taille de police augmentée
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
