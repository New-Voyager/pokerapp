import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/rewards_model.dart';
import 'package:pokerapp/screens/auth_screens/login_screen.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

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
          Container(
            color: Colors.white10,
            height: 200.0,
            width: double.infinity,
            child: StackCardView(
              cards: cards,
            ),
          ),
          Spacer(),
          RaisedButton(
            child: Text('FLIP'),
            onPressed: () {
              for (var card in cards) card.flipCard();
            },
          ),
          Spacer(),
          RaisedButton(
            child: Text('Logout'),
            onPressed: () {
              AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
