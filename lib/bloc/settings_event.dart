abstract class SettingsEvent {}

class ToggleCheckbox extends SettingsEvent {
  final int paramIndex;
  final int choiceIndex;
  final bool newValue;

  ToggleCheckbox(this.paramIndex, this.choiceIndex, this.newValue);
}

class ChangeFontEvent extends SettingsEvent {
  final int selectedFontChoice;

  ChangeFontEvent(this.selectedFontChoice);
}

class LoadFontPreferenceEvent extends SettingsEvent {}

class ResetSettingsEvent extends SettingsEvent {}
