import 'package:flutter/material.dart';
import 'package:pokerapp/screens/auth_screens/login_screen.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/high_hand/high_hand.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  bool showAnimation = false;
  void toggle() => setState(() => showAnimation = !showAnimation);

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
            child: showAnimation
                ? Transform.scale(
                    scale: 3.0,
                    child: AnimatingShuffleCardView(),
                  )
                : Container(
                    child: Center(
                      child: Text(
                        'EMPTY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
          ),
          Spacer(),
          RaisedButton(
            child: Text('TOGGLE'),
            // onPressed: toggle,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HighHand())),
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
