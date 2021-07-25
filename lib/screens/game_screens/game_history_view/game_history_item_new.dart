import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';

class GameHistoryItemNew extends StatelessWidget {
  final GameHistoryModel game;
  final bool showClubName;
  const GameHistoryItemNew({Key key, this.game, this.showClubName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget clubName = Container();
    if ((this.showClubName ?? false) && this.game.clubName != null) {
      clubName = Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Club",
              style: AppStylesNew.labelTextStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              " ${this.game.clubName}",
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: AppStylesNew.gameHistoryDecoration,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                "${GameModelNew.getGameTypeImageAsset(game.ShortGameType)}",
                width: 48.pw,
                height: 48.ph,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.only(left: 16),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "${game.GameType} ",
                          style: TextStyle(
                            color: AppColorsNew.newTextColor,
                            fontFamily: AppAssetsNew.fontFamilyPoppins,
                            fontSize: 16.dp,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "${DataFormatter.chipsFormat(game.smallBlind)}/${DataFormatter.chipsFormat(game.bigBlind)}",
                              style: TextStyle(
                                color: AppColorsNew.yellowAccentColor,
                                fontFamily: AppAssetsNew.fontFamilyPoppins,
                                fontSize: 16.dp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      clubName,
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Hosted by",
                              style: AppStylesNew.labelTextStyle,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              " ${game.startedBy}",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Started at",
                                style: AppStylesNew.labelTextStyle,
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  " ${DataFormatter.dateFormat(game.startedAt)}")),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Running time",
                              style: AppStylesNew.labelTextStyle,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              " ${DataFormatter.getTimeInHHMMFormatInMin(game.runTime)}",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Session Time",
                                style: AppStylesNew.labelTextStyle,
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  " ${DataFormatter.getTimeInHHMMFormatInMin(game.sessionTime)}")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${DataFormatter.chipsFormat(game.balance)}",
                    style: TextStyle(
                      color: getBalanceColor(game.balance),
                      fontSize: 24.0.pw,
                      fontFamily: AppAssetsNew.fontFamilyPoppins,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getBalanceColor(double number) {
    if (number == null) {
      return AppColorsNew.newTextColor;
    }

    return number == 0
        ? AppColorsNew.newTextColor
        : number > 0
            ? AppColorsNew.newGreenButtonColor
            : AppColorsNew.newRedButtonColor;
  }
}
