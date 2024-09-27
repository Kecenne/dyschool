abstract class SettingsEvent {}

class ToggleCheckbox extends SettingsEvent {
  final int paramIndex;
  final int choiceIndex; 
  final bool newValue; 

  ToggleCheckbox(this.paramIndex, this.choiceIndex, this.newValue);
}
