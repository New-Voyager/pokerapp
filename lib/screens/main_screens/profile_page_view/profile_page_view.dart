import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/card_helper.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView>
    with SingleTickerProviderStateMixin {
  // GifController _gifController;
  bool _showGif = false;
  AssetImage _gifImage;
  AppTextScreen _appScreenText;

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
    _appScreenText = getAppTextScreen("profilePageView");

    return Container(
      color: AppColorsNew.screenBackgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
          ),
          Spacer(),
          Spacer(),
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
          Spacer(),
          ElevatedButton(
            child: Text('Gif Fireworks'),
            onPressed: () async {
              setState(() {
                _showGif = !_showGif;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              log('show svg border');
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
