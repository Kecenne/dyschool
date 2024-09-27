import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: BlocProvider(
        create: (context) => SettingsBloc(),
        child: Center(
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    return GridView.count(
                      crossAxisCount: isTablet ? 2 : 1,
                      crossAxisSpacing: isTablet ? 20 : 0,
                      mainAxisSpacing: 20,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isTablet ? 2.0 : 2.5,
                      children: [
                        // Paramètre 1
                        _buildOptionCard(
                          icon: Icons.text_fields,
                          title: "Paramètre 1",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, size: 32),
                                onPressed: () {
                                  // Logique augmenter unité
                                },
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                "Unité",
                                style: TextStyle(fontSize: 16), 
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.remove, size: 32),
                                onPressed: () {
                                  // Logique diminuer unité
                                },
                              ),
                            ],
                          ),
                        ),

                        // Paramètre 2
                        _buildOptionCard(
                          icon: Icons.palette,
                          title: "Paramètre 2",
                          child: isTablet
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCheckboxRow(
                                      context: context,
                                      title: "Choix 1",
                                      value: state.selectedParam2Choice == 1,
                                      onChanged: (value) => context.read<SettingsBloc>().add(
                                          ToggleCheckbox(2, 1, value!)),
                                    ),
                                    _buildCheckboxRow(
                                      context: context,
                                      title: "Choix 2",
                                      value: state.selectedParam2Choice == 2,
                                      onChanged: (value) => context.read<SettingsBloc>().add(
                                          ToggleCheckbox(2, 2, value!)),
                                    ),
                                    _buildCheckboxRow(
                                      context: context,
                                      title: "Choix 3",
                                      value: state.selectedParam2Choice == 3,
                                      onChanged: (value) => context.read<SettingsBloc>().add(
                                          ToggleCheckbox(2, 3, value!)),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildCheckboxColumn(
                                      context: context,
                                      title: "Choix 1",
                                      value: state.selectedParam2Choice == 1,
                                      onChanged: (value) => context.read<SettingsBloc>().add(
                                          ToggleCheckbox(2, 1, value!)),
                                    ),
                                    const SizedBox(width: 40),
                                    _buildCheckboxColumn(
                                      context: context,
                                      title: "Choix 2",
                                      value: state.selectedParam2Choice == 2,
                                      onChanged: (value) => context.read<SettingsBloc>().add(
                                          ToggleCheckbox(2, 2, value!)),
                                    ),
                                    const SizedBox(width: 40),
                                    _buildCheckboxColumn(
                                      context: context,
                                      title: "Choix 3",
                                      value: state.selectedParam2Choice == 3,
                                      onChanged: (value) => context.read<SettingsBloc>().add(
                                          ToggleCheckbox(2, 3, value!)),
                                    ),
                                  ],
                                ),
                        ),

                        // Paramètre 3
                        _buildOptionCard(
                          icon: Icons.format_size,
                          title: "Paramètre 3",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: state.selectedParam3Choice == 1,
                                onChanged: (value) {
                                  context.read<SettingsBloc>().add(
                                      ToggleCheckbox(3, 1, value!));
                                },
                              ),
                              const Text("Choix 1"),
                              const SizedBox(width: 16),
                              Checkbox(
                                value: state.selectedParam3Choice == 2,
                                onChanged: (value) {
                                  context.read<SettingsBloc>().add(
                                      ToggleCheckbox(3, 2, value!));
                                },
                              ),
                              const Text("Choix 2"),
                            ],
                          ),
                        ),

                        // Paramètre 4
                        _buildOptionCard(
                          icon: Icons.line_weight,
                          title: "Paramètre 4",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, size: 32),
                                onPressed: () {
                                  // Logique augmenter unité
                                },
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                "Unité",
                                style: TextStyle(fontSize: 16), 
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.remove, size: 32),
                                onPressed: () {
                                  // Logique diminuer unité
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
        Text(title),
      ],
    );
  }

  Widget _buildCheckboxColumn({required BuildContext context, required String title, required bool value, required Function(bool?) onChanged}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(title),
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
