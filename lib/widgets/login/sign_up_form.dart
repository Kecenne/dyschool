import 'package:flutter/material.dart';
import 'login_input.dart';
import 'login_button.dart';
import '/theme/app_color.dart';

class SignupForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSignupPressed;
  final VoidCallback onLoginLinkPressed;

  const SignupForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSignupPressed,
    required this.onLoginLinkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        // Champs de texte pour l'email, le mot de passe et la confirmation
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
                controller: passwordController,
                obscureText: true, // Masquer le texte saisi
              ),
              const SizedBox(height: 30),
              // Champ de confirmation du mot de passe
              LoginInput(
                label: 'Confirmer le mot de passe',
                controller: confirmPasswordController,
                obscureText: true, // Masquer le texte saisi
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Bouton "Inscription"
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoginButton(
            text: "INSCRIPTION",
            onPressed: onSignupPressed,
          ),
        ),
        const SizedBox(height: 20),
        // Texte "Déjà inscrit ? Connecte-toi"
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Déjà inscrit ? ",
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: onLoginLinkPressed,
              child: const Text(
                "Connecte-toi",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.blueColor,
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