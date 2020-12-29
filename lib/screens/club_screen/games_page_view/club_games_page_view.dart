import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_game_model.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:provider/provider.dart';

import 'club_game_item.dart';

class ClubGamesPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<ClubHomePageModel>(
        builder: (_, ClubHomePageModel clubModel, __) => Container(
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
              const SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: clubModel.liveGames.length,
                shrinkWrap: true,
                itemBuilder: (_, index) => ClubGameItem(
                  clubModel.liveGames[index],
                ),
              ),
            ],
          ),
        ),
      );
}
