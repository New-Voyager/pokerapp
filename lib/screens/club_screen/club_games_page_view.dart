import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/app_assets.dart';

import 'club_game_item.dart';

class ClubGamesPageView extends StatelessWidget {
  final List<GameModel> liveGames;
  ClubGamesPageView(this.liveGames);

  final AppTextScreen _appScreenText = getAppTextScreen("clubGames");

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              liveGames.length == 0 ? _appScreenText['noLiveGames'] : _appScreenText['liveGames'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: AppAssets.fontFamilyLato,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: liveGames.length,
              shrinkWrap: true,
              itemBuilder: (_, index) => ClubGameItem(
                liveGames[index],
              ),
            ),
          ],
        ),
      );
}
