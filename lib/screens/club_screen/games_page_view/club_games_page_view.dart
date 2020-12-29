import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_game_model.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/app_assets.dart';

import 'club_game_item.dart';

class ClubGamesPageView extends StatelessWidget {
  ClubHomePageModel data;
  ClubGamesPageView(ClubHomePageModel data) {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Live Games",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w700,
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: this.data.liveGames.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ClubGameItem(
                this.data.liveGames[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
