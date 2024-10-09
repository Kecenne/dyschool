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
      body: SingleChildScrollView(
        child: Column(
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
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Champ email agrandi
                  SizedBox(
                    width: 600, // Largeur augmentée
                    height: 100, // Hauteur augmentée
                    child: TextFormField(
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
                  // Champ mot de passe agrandi
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Bouton "Connexion" agrandi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textColor,
                  fixedSize: const Size(600, 100), // Taille augmentée
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "CONNEXION",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 36, // Police augmentée
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
