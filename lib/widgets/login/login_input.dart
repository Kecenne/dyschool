import 'package:flutter/material.dart';
import '../../../theme/app_color.dart'; // Importez votre fichier de couleurs

class LoginInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText; // Ajout du paramètre obscureText
  final double width;
  final double height;
  final double borderRadius;

  const LoginInput({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText = false, // Valeur par défaut à false
    this.width = 600, // Valeur par défaut pour la largeur
    this.height = 100, // Valeur par défaut pour la hauteur
    this.borderRadius = 15.0, // Valeur par défaut pour le borderRadius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Largeur personnalisable
      height: height, // Hauteur personnalisable
      child: TextFormField(
        controller: controller,
        obscureText: obscureText, // Utilisation du paramètre pour masquer le texte
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.primaryColor, // Couleur du label
            fontSize: 24,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 20,
          ),
          filled: true, // Remplir l'arrière-plan
          fillColor: Colors.grey[200], // Couleur de fond légère
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Bordure arrondie
            borderSide: BorderSide.none, // Pas de bordure visible
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Bordure arrondie
            borderSide: BorderSide.none, // Pas de bordure lorsque activé
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Bordure arrondie
            borderSide: BorderSide.none, // Pas de bordure lorsque focus
          ),
        ),
        style: const TextStyle(fontSize: 28, height: 1.5), // Police plus grande
      ),
    );
  }
}