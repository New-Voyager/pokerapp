import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/screens/util_screens/numeric_keyboard.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_screen/replay_hand_screen.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/plate_border.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/numeric_keyboard.dart';
import 'package:pokerapp/widgets/run_it_twice_dialog.dart';

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
              ConnectionDialog.show(
                context: context,
              );
              // TODO: USE ROUTES HERE INSTEAD OF NAVIGATOR.PUSH
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReplayHandScreen(),
                ),
              ); */
            },
          ),
          Spacer(),

          Container(width: 150, height: 100, child: plateWidget),

          ElevatedButton(
            child: Text('Prompt Run it twice'),
            onPressed: () async {
              RunItTwiceDialog.promptRunItTwice(
                context: context,
              );
            },
          ),

          //SvgWidget(),
          Spacer(),
          ElevatedButton(
              child: Text('SVG border'),
              onPressed: () async {
                log('show svg border');
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
