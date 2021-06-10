import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';

class HandlogSummary extends StatelessWidget {
  final HandLogModelNew handlogModel;

  HandlogSummary({this.handlogModel});
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(AppStringsNew.SummaryText,
                style: AppStylesNew.valueTextStyle),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: ListView.separated(
              itemBuilder: (context, index) {
                log("TOTAL : ${handlogModel.hand.playersInSeats.length}");
                // log(handlogModel.hand.data.players[(index + 1).toString()].id);
                return actionRow(handlogModel.hand.playersInSeats[index]);
              },
              itemCount: handlogModel.hand.playersInSeats.length,
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
    );
  }

  Widget actionRow(Player player) {
    final int diff = player.balance.after - player.balance.before;
    // int index = handlogModel.players
    //     .indexWhere((element) => element.id.toString() == player.id);
    // String playerName =
    //     index != -1 ? handlogModel.players[index].name : "Player";
    String playerName = 'Player';
    if (player != null) {
      playerName = getPlayerNameBySeatNo(
        handLogModel: handlogModel,
        seatNo: player.seatNo,
      );
    }
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
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
              style: AppStylesNew.playerNameTextStyle,
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
              diff.toString(),
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
              player.balance.after.toString(),
              style: AppStylesNew.potSizeTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
