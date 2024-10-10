import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import '../services/settings_service.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService;

  SettingsBloc(this._settingsService) : super(SettingsState()) {
    on<ToggleCheckbox>((event, emit) {
      print("ToggleCheckbox reçu : paramIndex = ${event.paramIndex}, choiceIndex = ${event.choiceIndex}");
      if (event.paramIndex == 2) {
        emit(state.copyWith(selectedParam2Choice: event.choiceIndex));
      } else if (event.paramIndex == 3) {
        emit(state.copyWith(selectedParam3Choice: event.choiceIndex));
        add(ChangeFontEvent(event.choiceIndex));
      }
    });

    on<ChangeFontEvent>((event, emit) async {
      print("ChangeFontEvent reçu : selectedFontChoice = ${event.selectedFontChoice}");
      emit(state.copyWith(
        selectedFontChoice: event.selectedFontChoice,
        selectedParam3Choice: event.selectedFontChoice,
      ));

      String selectedFont = event.selectedFontChoice == 2 ? 'OpenDyslexic' : 'Roboto';
      print("Sauvegarde de la police dans Firestore : $selectedFont");
      await _settingsService.saveUserFontPreference(selectedFont);
    });

    on<LoadFontPreferenceEvent>((event, emit) async {
      print("LoadFontPreferenceEvent reçu");
      String fontPreference = await _settingsService.getUserFontPreference();
      print("Police chargée depuis Firestore : $fontPreference");
      emit(state.copyWith(selectedFontChoice: fontPreference == 'OpenDyslexic' ? 2 : 1));
    });

    on<ResetSettingsEvent>((event, emit) {
      print("ResetSettingsEvent reçu");
      emit(SettingsState(
        selectedFontChoice: 1, 
        selectedParam3Choice: 1,
      ));
      print("Bloc réinitialisé à l'état par défaut");
    });
  }
}
