import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_game_item_new.dart';

class ClubLiveGamesView extends StatelessWidget {
  final List<GameModel> liveGames;
  ClubLiveGamesView(this.liveGames);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            liveGames.length == 0 ? "No Live Games" : "Live Games",
            style: TextStyle(
              color: AppColorsNew.newTextColor,
              fontSize: 18.0,
              fontFamily: AppAssetsNew.fontFamilyPoppins,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: liveGames.length,
            shrinkWrap: true,
            itemBuilder: (_, index) => ClubGameItemNew(
              liveGames[index],
            ),
          ),
        ],
      ),
    );
  }
}
