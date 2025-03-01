import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../theme/app_color.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre + bouton de fermeture
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Accessibilité",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.black, size: 28),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // GridView des options
                  GridView.count(
                    crossAxisCount: isTablet ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isTablet ? 2.0 : 2.5,
                    children: [
                      _buildOptionCard(
                        icon: Icons.text_fields,
                        title: "Taille de la police",
                        color: AppColors.orangeColor,
                        child: _buildStepper("18"), // ✅ Taille de police affichée à 18
                      ),
                      _buildOptionCard(
                        icon: Icons.palette,
                        title: "Thème de l'application",
                        color: AppColors.vifblueColor,
                        child: Column(
                          children: [
                            _buildRadioButton(context, "Clair", state.selectedParam2Choice == 1, 1),
                            _buildRadioButton(context, "Sombre", state.selectedParam2Choice == 2, 2),
                            _buildRadioButton(context, "Automatique", state.selectedParam2Choice == 3, 3),
                          ],
                        ),
                      ),
                      _buildOptionCard(
                        icon: Icons.font_download,
                        title: "Type de police",
                        color: AppColors.secondaryColor,
                        child: Column(
                          children: [
                            _buildRadioButton(context, "Poppins", state.selectedFontChoice == 1, 1, isFont: true),
                            _buildRadioButton(context, "OpenDyslexic", state.selectedFontChoice == 2, 2, isFont: true),
                          ],
                        ),
                      ),
                      _buildOptionCard(
                        icon: Icons.line_weight,
                        title: "Interlignage",
                        color: AppColors.lightPink,
                        child: _buildStepper("1.2"), // ✅ Interlignage affiché à 1.2
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

    /// ✅ Widget pour l'interlignage et la taille de police (boutons + / -)
    Widget _buildStepper(String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle, size: 32, color: AppColors.orangeColor),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              value, // ✅ Affiche la valeur factice
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textColor),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, size: 32, color: AppColors.orangeColor),
            onPressed: () {},
          ),
        ],
      );
    }

  /// ✅ Boutons radio stylisés
  Widget _buildRadioButton(BuildContext context, String title, bool isSelected, int value, {bool isFont = false}) {
    return GestureDetector(
      onTap: () {
        if (isFont) {
          context.read<SettingsBloc>().add(ChangeFontEvent(value));
        } else {
          context.read<SettingsBloc>().add(ToggleCheckbox(2, value, true));
        }
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: isFont ? context.read<SettingsBloc>().state.selectedFontChoice : context.read<SettingsBloc>().state.selectedParam2Choice,
            onChanged: (val) {
              if (isFont) {
                context.read<SettingsBloc>().add(ChangeFontEvent(value));
              } else {
                context.read<SettingsBloc>().add(ToggleCheckbox(2, value, true));
              }
            },
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({required IconData icon, required String title, required Widget child, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textColor),
                ),
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}