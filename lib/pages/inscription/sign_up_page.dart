import 'package:dyschool/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importez Firebase Auth
import '../../theme/app_color.dart'; // Importez votre fichier de couleurs
import 'choix_troubles.dart'; // Importez votre page de choix
import '../../controllers/auth_controller.dart'; // Importez votre contrôleur d'authentification


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Définir une constante pour la largeur de la bordure
  final double borderThickness = 4.0;

  Future<void> _signUp() async {
  if (passwordController.text != confirmPasswordController.text) {
    // Afficher un message d'erreur si les mots de passe ne correspondent pas
    Get.snackbar("Erreur", "Les mots de passe ne correspondent pas", snackPosition: SnackPosition.BOTTOM);
    return;
  }

  try {
    // Créer un utilisateur avec l'email et le mot de passe
    await Auth().createUserWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    // Récupérer l'utilisateur courant
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Envoyer l'email de vérification
      await Auth().sendVerificationEmail(user);
      
      // Afficher une notification indiquant que l'email de vérification a été envoyé
      Get.snackbar("Vérification", "Un email de vérification a été envoyé à ${user.email}. Veuillez vérifier votre boîte de réception.",
          snackPosition: SnackPosition.BOTTOM);
    }

    // Rediriger vers la page principale après l'enregistrement
    Get.off(() => const MainPage());

  } catch (e) {
    // Afficher un message d'erreur
    Get.snackbar("Erreur", e.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: Column(
        children: [
          // Grand fond rectangulaire en couleur primaire
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
          const SizedBox(height: 100),

          // Champs de texte pour l'email, le mot de passe et la confirmation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: 475,
                  height: 100,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: borderThickness),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: borderThickness),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 475,
                  height: 100,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                      hintText: 'Mot de passe',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: borderThickness),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: borderThickness),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 475,
                  height: 100,
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                      hintText: 'Confirmer le mot de passe',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: borderThickness),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: borderThickness),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bouton "Inscription"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _signUp, // Appeler la fonction _signUp
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.textColor,
                fixedSize: const Size(475, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "INSCRIPTION",
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
