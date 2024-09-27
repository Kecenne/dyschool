class SettingsState {
  final int selectedParam2Choice; 
  final int selectedParam3Choice;

  SettingsState({
    this.selectedParam2Choice = 1,
    this.selectedParam3Choice = 1,
  });

  SettingsState copyWith({
    int? selectedParam2Choice,
    int? selectedParam3Choice,
  }) {
    return SettingsState(
      selectedParam2Choice: selectedParam2Choice ?? this.selectedParam2Choice,
      selectedParam3Choice: selectedParam3Choice ?? this.selectedParam3Choice,
    );
  }
}
