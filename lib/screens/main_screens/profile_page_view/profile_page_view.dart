import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/util_screens/numeric_keyboard.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_screen/replay_hand_screen.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/numeric_keyboard.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  List<CardObject> cards =
      [200, 196].map((e) => CardHelper.getCard(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          ElevatedButton(
            child: Text('Replay Hand'),
            onPressed: () {
              // TODO: USE ROUTES HERE INSTEAD OF NAVIGATOR.PUSH
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReplayHandScreen(),
                ),
              );
            },
          ),
          Spacer(),
          ElevatedButton(
            child: Text('Numeric Keyboard'),
            onPressed: () async {
              final double value = await NumericKeyboard.show(context);
              print('numeric value: $value');
            },
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
