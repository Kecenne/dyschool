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

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
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
                      Text(
                        "Accessibilité",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Theme.of(context).textTheme.bodyLarge?.color, size: 28),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // GridView des options
                  GridView.count(
                    crossAxisCount: isTablet ? 2 : 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isTablet ? 1.6 : 1.4,
                    children: [
                      _buildOptionCard(
                        context,
                        icon: Icons.text_fields,
                        title: "Taille de la police",
                        color: AppColors.orangeColor,
                        child: _buildStepper(context, state.fontSize, false),
                      ),
                      _buildOptionCard(
                        context,
                        icon: Icons.dark_mode,
                        title: "Thème sombre",
                        color: AppColors.vifblueColor,
                        child: _buildCustomSwitch(context, state.isDarkMode),
                      ),
                      _buildOptionCard(
                        context,
                        icon: Icons.font_download,
                        title: "Type de police",
                        color: AppColors.secondaryColor,
                        child: Column(
                          children: [
                            _buildRadioButton(context, "Poppins", state.selectedFontChoice == 1, 1, isFont: true),
                            const SizedBox(height: 4),
                            _buildRadioButton(context, "OpenDyslexic", state.selectedFontChoice == 2, 2, isFont: true),
                            const SizedBox(height: 4),
                            _buildRadioButton(context, "Roboto", state.selectedFontChoice == 3, 3, isFont: true),
                          ],
                        ),
                      ),
                      _buildOptionCard(
                        context,
                        icon: Icons.line_weight,
                        title: "Interlignage",
                        color: AppColors.lightPink,
                        child: _buildStepper(context, state.lineHeight, true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<SettingsBloc>().add(ResetSettingsEvent());
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        'Réinitialiser les paramètres',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required Widget child, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Contrôles centrés
          Center(child: child),
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context, double value, bool isLineHeight) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.remove_circle, size: 40, color: AppColors.orangeColor),
          onPressed: () {
            if (isLineHeight) {
              if (value > 1.0) {
                context.read<SettingsBloc>().add(ChangeLineHeightEvent(value - 0.1));
              }
            } else {
              if (value > 12) {
                context.read<SettingsBloc>().add(ChangeFontSizeEvent(value - 1));
              }
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.add_circle, size: 40, color: AppColors.orangeColor),
          onPressed: () {
            if (isLineHeight) {
              if (value < 2.0) {
                context.read<SettingsBloc>().add(ChangeLineHeightEvent(value + 0.1));
              }
            } else {
              if (value < 24) {
                context.read<SettingsBloc>().add(ChangeFontSizeEvent(value + 1));
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildRadioButton(BuildContext context, String title, bool isSelected, int value, {bool isFont = false}) {
    return GestureDetector(
      onTap: () {
        if (isFont) {
          context.read<SettingsBloc>().add(ChangeFontEvent(value));
        } else {
          context.read<SettingsBloc>().add(ToggleCheckbox(paramIndex: 2, choiceIndex: value));
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: isSelected ? AppColors.primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch(BuildContext context, bool isDarkMode) {
    return SizedBox(
      width: 120,
      height: 55,
      child: GestureDetector(
        onTap: () {
          context.read<SettingsBloc>().add(ToggleDarkModeEvent());
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(50),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(4),
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFCEDEE1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}