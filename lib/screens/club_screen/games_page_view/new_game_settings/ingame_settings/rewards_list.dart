import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/select_from_list_IOS_look.dart';
import 'package:provider/provider.dart';

class RewardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: new AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Rewards"),
        elevation: 0.0,
      ),
      body: Consumer<NewGameModelProvider>(
        builder: (context, data, child) => IOSLikeCheckList(
          list: data.rewards.map((e) => e.name).toList(),
          selectedIndex: data.selectedReward,
          onTap: (index) {
            data.selectedReward = index;
          },
        ),
      ),
    );
  }
}
