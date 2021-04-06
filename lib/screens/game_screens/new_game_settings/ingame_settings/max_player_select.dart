import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/select_from_list_IOS_look.dart';
import 'package:provider/provider.dart';

class MaxPlayerSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> maxPlayersList = new List<String>();
    NewGameModelProvider data = Provider.of<NewGameModelProvider>(context);
    int maxPlayersAllowed =
        NewGameConstants.MAX_PLAYERS[data.settings.gameType];
    for (int i = 2; i <= maxPlayersAllowed; i++) {
      if (i % 2 == 0 || i == maxPlayersAllowed) {
        maxPlayersList.add(i.toString());
      }
    }

    // int selectedIndex = data.maxPlayers - 2;
    int selectedIndex = _getSelectedIndex(data.maxPlayers, maxPlayersList);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: new AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Max Players"),
        elevation: 0.0,
      ),
      body: Consumer<NewGameModelProvider>(
        builder: (context, data, child) => IOSLikeCheckList(
          list: maxPlayersList,
          selectedIndex: selectedIndex,
          onTap: (index) {
            data.maxPlayers = int.parse(
                maxPlayersList[index]); ////index + 2; //0 + 2 (first item)
          },
        ),
      ),
    );
  }

  int _getSelectedIndex(int val, List<String> values) {
    String value = val.toString();
    return values.indexOf(value);
  }
}
