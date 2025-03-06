abstract class SettingsEvent {}

class ToggleCheckbox extends SettingsEvent {
  final int paramIndex;
  final int choiceIndex;

  ToggleCheckbox({required this.paramIndex, required this.choiceIndex});
}

class ChangeFontEvent extends SettingsEvent {
  final int selectedFontChoice;

  ChangeFontEvent(this.selectedFontChoice);
}

class ChangeFontSizeEvent extends SettingsEvent {
  final double newSize;

  ChangeFontSizeEvent(this.newSize);
}

class ChangeLineHeightEvent extends SettingsEvent {
  final double newHeight;

  ChangeLineHeightEvent(this.newHeight);
}

class ToggleDarkModeEvent extends SettingsEvent {}

class LoadFontPreferenceEvent extends SettingsEvent {}

class ResetSettingsEvent extends SettingsEvent {}
