import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/game_play/new_game_settings_services/new_game_settings_services.dart';
import 'package:pokerapp/widgets/select_from_list_IOS_look.dart';
import 'package:provider/provider.dart';

class GameTypeSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: new AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Game Type"),
        elevation: 0.0,
      ),
      body: Consumer<NewGameSettingsServices>(
        builder: (context, data, child) => IOSLikeCheckList(
          list: data.gameTypes,
          selectedIndex: data.currentGameIndex,
          onTap: (index) {
            data.updateGameType(index);
          },
        ),
      ),
    );
  }
}
