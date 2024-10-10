import 'package:flutter/material.dart';
import 'login_input.dart';
import 'login_button.dart';
import '/theme/app_color.dart';

class ConnexionForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignupLinkPressed;

  const ConnexionForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onSignupLinkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 150),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Champ email
              LoginInput(
                label: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 30),
              // Champ mot de passe
              LoginInput(
                label: 'Mot de passe',
                obscureText: true, // Masquer le texte saisi
                controller: passwordController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Bouton "Connexion"
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoginButton(
            text: "CONNEXION",
            onPressed: onLoginPressed,
          ),
        ),
        const SizedBox(height: 20),
        // Texte "Pas encore inscrit ? Inscris-toi"
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Pas encore inscrit ? ",
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: onSignupLinkPressed,
              child: const Text(
                "Inscris-toi",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.primaryColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}