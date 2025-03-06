// widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../../theme/app_color.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final double width;
  final double height;

  const LoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.blueColor,
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.width = 600, // Ajusté la largeur par défaut à 600
    this.height = 100, // Hauteur constante
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: backgroundColor, width: 4),
              fixedSize: Size(width, height), // Appliquer la largeur et la hauteur
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(color: backgroundColor, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              fixedSize: Size(width, height), // Appliquer la largeur et la hauteur
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
  }
}
