import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';

class HandlogSummary extends StatelessWidget {
  final AppTextScreen appTextScreen;
  final HandResultData handResult;

  HandlogSummary({this.handResult, this.appTextScreen});
  @override
  Widget build(BuildContext context) {
    final playersInSeats = this.handResult.result.playerInfo.keys.toList();
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColorsNew.newGreenRadialStartColor,
                borderRadius: BorderRadius.circular(7),
              ),
              padding: EdgeInsets.all(8),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                appTextScreen['stack'],
                style: AppDecorators.getHeadLine4Style(theme: theme)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  log("TOTAL : ${playersInSeats.length}");
                  final player =
                      handResult.result.playerInfo[playersInSeats[index]];
                  // log(handlogModel.hand.data.players[(index + 1).toString()].id);
                  return actionRow(player, theme);
                },
                itemCount: playersInSeats.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                  endIndent: 16,
                  indent: 16,
                  color: AppColorsNew.newBackgroundBlackColor,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionRow(ResultPlayerInfo player, AppTheme theme) {
    final double diff = player.balance.after - player.balance.before;
    // int index = handlogModel.players
    //     .indexWhere((element) => element.id.toString() == player.id);
    // String playerName =
    //     index != -1 ? handlogModel.players[index].name : "Player";
    String playerName = 'Player';
    if (player != null) {
      playerName = player.name;
    }
    return Container(
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              playerName,
              style: AppDecorators.getSubtitle1Style(theme: theme)
                  .copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(""),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ((diff > 0) ? '+' : '') + DataFormatter.chipsFormat(diff),
              style: TextStyle(
                color: (diff > 0) ? Colors.green : Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DataFormatter.chipsFormat(player.balance.after),
              style: AppDecorators.getSubtitle1Style(theme: theme)
                  .copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
