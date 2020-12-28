import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_game_model.dart';
import 'package:pokerapp/resources/app_assets.dart';

import 'club_game_item.dart';

class ClubGamesPageView extends StatelessWidget {
  final List<ClubGameModel> gamesList = new List<ClubGameModel>();

  @override
  Widget build(BuildContext context) {
    gamesList.add(new ClubGameModel("5 Card PLO", 100, 300, 5, 2, 2.0, 4.0));

    gamesList
        .add(new ClubGameModel("No Limit Holdem", 100, 300, 0, 0, 1.0, 2.0));

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
            itemCount: gamesList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ClubGameItem(
                gamesList[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
