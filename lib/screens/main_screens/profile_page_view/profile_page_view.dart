import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/plate_border.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/card_helper.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  List<CardObject> cards =
      [200, 196].map((e) => CardHelper.getCard(e)).toList();

  @override
  Widget build(BuildContext context) {
    final plateWidget = PlateWidget(1, 30);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          ElevatedButton(
            child: Text('Replay Hand'),
            onPressed: () {
              ReplayHandDialog.show(
                playerID: 337, // yong's ID
                context: context,
              );
            },
          ),
          Spacer(),

          Container(width: 150, height: 100, child: plateWidget),

          //SvgWidget(),
          Spacer(),
          ElevatedButton(
              child: Text('SVG border'),
              onPressed: () async {
                log('show svg border');
                GameType type = await showGameSelectorDialog(
                  listOfGameTypes: [
                    GameType.HOLDEM,
                    GameType.PLO,
                    GameType.PLO_HILO,
                    GameType.FIVE_CARD_PLO_HILO,
                    GameType.FIVE_CARD_PLO,
                  ],
                  timeLimit: Duration(seconds: 60),
                );

                log("Selected Game Type: ${gameTypeStr(type)}");
                // plateWidget.animate()
              }
              // child: Text('Numeric Keyboard'),
              // onPressed: () async {
              //   final double value = await NumericKeyboard.show(
              //     context,
              //     title: 'Please enter your BET amount',
              //     min: 45,
              //   );
              //   print('numeric value: $value');
              // },
              ),
          Spacer(),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () {
              AuthService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
