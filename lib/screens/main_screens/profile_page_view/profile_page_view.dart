import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/plate_border.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/straddle_dialog.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView>
    with SingleTickerProviderStateMixin {
  // GifController _gifController;
  bool _showGif = false;
  AssetImage _gifImage;

  List<CardObject> cards =
      [200, 196].map((e) => CardHelper.getCard(e)).toList();

  @override
  void initState() {
    super.initState();

    // _gifController = GifController(
    //   vsync: this,
    //   duration: AppConstants.highHandFireworkAnimationDuration,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final plateWidget = PlateWidget(1, 30);
    return Container(
      color: AppColors.screenBackgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
          ),

          Spacer(),
          // ElevatedButton(
          //   child: Text('Replay Hand'),
          //   onPressed: () {
          //     ReplayHandDialog.show(
          //       playerID: 337, // yong's ID
          //       context: context,
          //     );
          //   },
          // ),
          Spacer(),

          // GifImage(
          //   image: AssetImage('assets/animations/fireworks2.gif'),
          //   controller: _gifController,
          //   height: 100,
          //   width: 100,
          // ),

          _showGif
              ? Builder(
                  builder: (_) {
                    _gifImage = AssetImage('assets/animations/fireworks2.gif');
                    return Image(
                      image: _gifImage,
                      height: 100,
                      width: 100,
                    );
                  },
                )
              : Builder(
                  builder: (_) {
                    _gifImage?.evict();
                    return Text('Gif here');
                  },
                ),

          //SvgWidget(),
          Spacer(),
          ElevatedButton(
            // child: Text('SVG border'),
            // onPressed: () async {
            //   log('show svg border');
            //   GameType type = await showGameSelectorDialog(
            //     listOfGameTypes: [
            //       GameType.HOLDEM,
            //       GameType.PLO,
            //       GameType.PLO_HILO,
            //       GameType.FIVE_CARD_PLO_HILO,
            //       GameType.FIVE_CARD_PLO,
            //     ],
            //     timeLimit: Duration(seconds: 60),
            //   );

            //   log("Selected Game Type: ${gameTypeStr(type)}");
            //   // plateWidget.animate()
            // }
            child: Text('Gif Fireworks'),
            onPressed: () async {
              setState(() {
                _showGif = !_showGif;
              });
              // final l = await fetchGif(
              //     AssetImage('assets/animations/fireworks2.gif'));

              // print('1 and ${l.length}');

              // _gifController.repeat(
              //   min: 1,
              //   max: l.length.toDouble(),
              //   period: AppConstants.highHandFireworkAnimationDuration,
              // );
            },
          ),
          ElevatedButton(
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
                timeLimit: Duration(seconds: 500),
              );

              log("Selected Game Type: ${gameTypeStr(type)}");
              // plateWidget.animate()
            },
            child: Text('New Game Selector Dialog'),
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
          Spacer(),
        ],
      ),
    );
  }
}
