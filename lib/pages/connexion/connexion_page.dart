import 'package:dyschool/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assurez-vous d'importer GetX
import '../../theme/app_color.dart'; // Importez votre fichier de couleurs
import '../../controllers/auth_controller.dart'; // Importez votre service d'authentification

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({Key? key}) : super(key: key);

  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Auth _auth = Auth(); // Instance de votre service d'authentification
  final double borderThickness = 4.0;

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      // Si la connexion est réussie, redirigez vers HomePage
      Get.off(() => const MainPage()); // Remplacez la page actuelle par HomePage
    } catch (e) {
      // Gérez les erreurs de connexion (affichez une alerte, par exemple)
      Get.snackbar('Erreur', 'Connexion échouée : ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: Column(
        children: [
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
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness,
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                // Champ mot de passe
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
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: borderThickness,
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Bouton "Connexion"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _login, // Liez à la fonction _login
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.textColor,
                fixedSize: const Size(475, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "CONNEXION",
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
