import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medal_manager.dart';

class GameRewardWidget extends StatelessWidget {
  final String gameName;
  final dynamic result;

  const GameRewardWidget({required this.gameName, required this.result, Key? key}) : super(key: key);

  String getReward() {
    if (gameName == 'Seven Families') {
      if (result <= 30) return 'Gold';
      if (result <= 60) return 'Silver';
      if (result <= 120) return 'Bronze';
      return 'No Reward';
    }

    switch (gameName) {
      case 'Memory Game':
        if (result <= 20) return 'Gold';
        if (result <= 40) return 'Silver';
        return 'Bronze';
      case 'Connect Four':
        if (result <= 7) return 'Gold';
        if (result <= 10) return 'Silver';
        if (result <= 15) return 'Bronze';
        break;
      case 'Guess Who':
        if (result >= 9) return 'Gold';
        if (result >= 7) return 'Silver';
        if (result >= 5) return 'Bronze';
        break;
      case 'Simon':
        if (result >= 20) return 'Gold';
        if (result >= 10) return 'Silver';
        if (result >= 5) return 'Bronze';
        break;
    }
    return 'No Reward';
  }

  @override
  Widget build(BuildContext context) {
    String reward = getReward();

    if (reward != 'No Reward') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final medalManager = Provider.of<MedalManager>(context, listen: false);

        switch (reward) {
          case 'Gold':
            medalManager.addGoldMedal();
            break;
          case 'Silver':
            medalManager.addSilverMedal();
            break;
          case 'Bronze':
            medalManager.addBronzeMedal();
            break;
        }
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        if (reward != 'No Reward')
          Image.asset('assets/images/rewards/$reward.png', width: 100, height: 100),
      ],
    );
  }
}
