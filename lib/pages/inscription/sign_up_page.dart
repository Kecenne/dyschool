import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importez Firebase Auth
import '../../theme/app_color.dart'; // Importez votre fichier de couleurs
import '../../controllers/auth_controller.dart'; // Importez votre contrôleur d'authentification
import 'choix_troubles.dart'; // Importez la page ChoixTroubles


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final double borderThickness = 4.0; // Largeur de la bordure

  Future<void> _signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Erreur", "Les mots de passe ne correspondent pas", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      await Auth().createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await Auth().sendVerificationEmail(user);
        Get.snackbar("Vérification", "Un email de vérification a été envoyé à ${user.email}.",
            snackPosition: SnackPosition.TOP);
      }

      Get.off(() => const ChoixTroubles());
    } catch (e) {
      Get.snackbar("Erreur", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Fond rectangulaire avec couleur primaire
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              color: AppColors.primaryColor,
              child: const Center(
                child: Text(
                  "DYSCHOOL",
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic',
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),

            // Champs de texte pour l'email, le mot de passe et la confirmation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 600, // Largeur augmentée
                    height: 100, // Hauteur augmentée
                    child:TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 24), // Texte plus grand
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30), // Plus d'espace
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: borderThickness,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: borderThickness,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 28, height: 1.5), // Police plus grande
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: 600, // Largeur augmentée
                    height: 100, // Hauteur augmentée
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 24), // Texte plus grand
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30), // Plus d'espace
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: borderThickness,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: borderThickness,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 28, height: 1.5), // Police plus grande
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: 600, // Largeur augmentée
                    height: 100, // Hauteur augmentée
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 24), // Texte plus grand
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30), // Plus d'espace
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: borderThickness,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: borderThickness,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 28, height: 1.5), // Police plus grande
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Bouton "Inscription" agrandi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _signUp, // Appeler la fonction _signUp
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textColor,
                  fixedSize: const Size(600, 100), // Taille augmentée
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "INSCRIPTION",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 36, // Taille de police augmentée
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
