import 'package:flutter/material.dart';

class MedalManager with ChangeNotifier {
  int _goldMedals = 0;
  int _silverMedals = 0;
  int _bronzeMedals = 0;

  int get goldMedals => _goldMedals;
  int get silverMedals => _silverMedals;
  int get bronzeMedals => _bronzeMedals;

  void addGoldMedal() {
    _goldMedals++;
    notifyListeners();
  }

  void addSilverMedal() {
    _silverMedals++;
    notifyListeners();
  }

  void addBronzeMedal() {
    _bronzeMedals++;
    notifyListeners();
  }

  void resetMedals() {
    _goldMedals = 0;
    _silverMedals = 0;
    _bronzeMedals = 0;
    notifyListeners();
  }
}