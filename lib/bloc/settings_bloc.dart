import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import '../services/settings_service.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService;

  SettingsBloc(this._settingsService) : super(SettingsState(
    selectedFontChoice: 1,
    selectedParam2Choice: 1,
    selectedParam3Choice: 1,
    fontSize: 16.0,
    lineHeight: 1.5,
    isDarkMode: false,
  )) {
    // Charger les préférences initiales immédiatement
    _loadInitialPreferences();

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

      String selectedFont;
      switch (event.selectedFontChoice) {
        case 2:
          selectedFont = 'OpenDyslexic';
          break;
        case 3:
          selectedFont = 'Inter';
          break;
        default:
          selectedFont = 'Poppins';
      }
      print("Sauvegarde de la police dans Firestore : $selectedFont");
      await _settingsService.saveUserFontPreference(selectedFont);
    });

    on<ChangeFontSizeEvent>((event, emit) async {
      print("ChangeFontSizeEvent reçu : newSize = ${event.newSize}");
      emit(state.copyWith(fontSize: event.newSize));
      await _settingsService.saveUserFontSize(event.newSize);
    });

    on<ChangeLineHeightEvent>((event, emit) async {
      print("ChangeLineHeightEvent reçu : newHeight = ${event.newHeight}");
      emit(state.copyWith(lineHeight: event.newHeight));
      await _settingsService.saveUserLineHeight(event.newHeight);
    });

    on<ToggleDarkModeEvent>((event, emit) async {
      print("ToggleDarkModeEvent reçu");
      final newDarkMode = !state.isDarkMode;
      emit(state.copyWith(isDarkMode: newDarkMode));
      await _settingsService.saveUserDarkMode(newDarkMode);
    });

    on<LoadFontPreferenceEvent>((event, emit) async {
      await _loadInitialPreferences();
    });

    on<ResetSettingsEvent>((event, emit) async {
      print("ResetSettingsEvent reçu");
      // Réinitialiser les valeurs dans Firestore
      await _settingsService.saveUserFontPreference('Inter');
      await _settingsService.saveUserFontSize(16.0);
      await _settingsService.saveUserLineHeight(1.5);
      await _settingsService.saveUserDarkMode(false);
      
      // Réinitialiser l'état
      emit(SettingsState(
        selectedFontChoice: 1, 
        selectedParam2Choice: 1,
        selectedParam3Choice: 1,
        fontSize: 16.0,
        lineHeight: 1.5,
        isDarkMode: false,
      ));
      print("Bloc réinitialisé à l'état par défaut");
    });
  }

  Future<void> _loadInitialPreferences() async {
    print("Chargement des préférences initiales");
    String fontPreference = await _settingsService.getUserFontPreference();
    double fontSize = await _settingsService.getUserFontSize();
    double lineHeight = await _settingsService.getUserLineHeight();
    bool isDarkMode = await _settingsService.getUserDarkMode();
    print("Police chargée depuis Firestore : $fontPreference");
    emit(state.copyWith(
      selectedFontChoice: fontPreference == 'OpenDyslexic' ? 2 : 1,
      fontSize: fontSize,
      lineHeight: lineHeight,
      isDarkMode: isDarkMode,
    ));
  }
}
