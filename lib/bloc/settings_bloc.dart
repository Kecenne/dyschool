import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<ToggleCheckbox>((event, emit) {
      // Paramètre 2
      if (event.paramIndex == 2) {
        emit(state.copyWith(selectedParam2Choice: event.choiceIndex));
      }

      // Paramètre 3
      else if (event.paramIndex == 3) {
        emit(state.copyWith(selectedParam3Choice: event.choiceIndex));
        add(ChangeFontEvent(event.choiceIndex));
      }
    });

    on<ChangeFontEvent>((event, emit) {
      emit(state.copyWith(selectedFontChoice: event.selectedFontChoice));
    });
  }
}
