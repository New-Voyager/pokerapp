import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_game_item_new.dart';

class ClubLiveGamesView extends StatelessWidget {
  final List<GameModel> liveGames;
  ClubLiveGamesView(this.liveGames);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            liveGames.length == 0 ? "No Live Games" : "Live Games",
            style: AppStylesNew.cardHeaderTextStyle,
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: liveGames.length,
            shrinkWrap: true,
            itemBuilder: (_, index) => ClubGameItemNew(
              liveGames[index],
            ),
            separatorBuilder: (context, index) =>
                AppDimensionsNew.getVerticalSizedBox(8),
          ),
        ],
      ),
    );
  }
}
