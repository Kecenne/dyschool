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
          TextStyle dynamicTextStyle = state.selectedFontChoice == 1
              ? const TextStyle(fontFamily: 'Roboto', color: AppColors.primaryColor)
              : const TextStyle(fontFamily: 'OpenDyslexic', color: AppColors.primaryColor);

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "POP - UP ACCESSIBILITÉ",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: isTablet ? 2 : 1,
                    crossAxisSpacing: isTablet ? 20 : 0,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isTablet ? 2.0 : 2.5,
                    children: [
                      _buildOptionCard(
                        icon: Icons.text_fields,
                        title: "Paramètre 1",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add, size: 32),
                              onPressed: () {
                                // Logique pour augmenter l'unité
                              },
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Unité",
                              style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.remove, size: 32),
                              onPressed: () {
                                // Logique pour diminuer l'unité
                              },
                            ),
                          ],
                        ),
                      ),
                      _buildOptionCard(
                        icon: Icons.palette,
                        title: "Paramètre 2",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCheckboxRow(
                              context: context,
                              title: "Choix 1",
                              value: state.selectedParam2Choice == 1,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(ToggleCheckbox(2, 1, value!));
                              },
                            ),
                            _buildCheckboxRow(
                              context: context,
                              title: "Choix 2",
                              value: state.selectedParam2Choice == 2,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(ToggleCheckbox(2, 2, value!));
                              },
                            ),
                            _buildCheckboxRow(
                              context: context,
                              title: "Choix 3",
                              value: state.selectedParam2Choice == 3,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(ToggleCheckbox(2, 3, value!));
                              },
                            ),
                          ],
                        ),
                      ),
                      _buildOptionCard(
                        icon: Icons.format_size,
                        title: "Type de police",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: state.selectedParam3Choice == 1,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(ToggleCheckbox(3, 1, value!));
                                context.read<SettingsBloc>().add(ChangeFontEvent(1));
                              },
                            ),
                            Text(
                              "Roboto",
                              style: dynamicTextStyle,
                            ),
                            const SizedBox(width: 16),
                            Checkbox(
                              value: state.selectedParam3Choice == 2,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(ToggleCheckbox(3, 2, value!));
                                context.read<SettingsBloc>().add(ChangeFontEvent(2)); 
                              },
                            ),
                            Text(
                              "OpenDyslexic", 
                              style: dynamicTextStyle,
                            ),
                          ],
                        ),
                      ),
                      _buildOptionCard(
                        icon: Icons.line_weight,
                        title: "Paramètre 4",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add, size: 32),
                              onPressed: () {
                                // Logique pour augmenter l'unité
                              },
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Unité",
                              style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.remove, size: 32),
                              onPressed: () {
                                // Logique pour diminuer l'unité
                              },
                            ),
                          ],
                        ),
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

  Widget _buildCheckboxRow({required BuildContext context, required String title, required bool value, required Function(bool?) onChanged}) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(title, style: const TextStyle(color: AppColors.primaryColor)),
      ],
    );
  }

  Widget _buildOptionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
