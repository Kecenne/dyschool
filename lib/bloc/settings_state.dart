class SettingsState {
  final int selectedParam2Choice;
  final int selectedParam3Choice;
  final int selectedFontChoice;
  final double fontSize;
  final double lineHeight;
  final bool isDarkMode;

  SettingsState({
    this.selectedParam2Choice = 1,
    this.selectedParam3Choice = 1,
    this.selectedFontChoice = 1,
    this.fontSize = 16.0,
    this.lineHeight = 1.5,
    this.isDarkMode = false,
  });

  SettingsState copyWith({
    int? selectedParam2Choice,
    int? selectedParam3Choice,
    int? selectedFontChoice,
    double? fontSize,
    double? lineHeight,
    bool? isDarkMode,
  }) {
    return SettingsState(
      selectedParam2Choice: selectedParam2Choice ?? this.selectedParam2Choice,
      selectedParam3Choice: selectedParam3Choice ?? this.selectedParam3Choice,
      selectedFontChoice: selectedFontChoice ?? this.selectedFontChoice,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
