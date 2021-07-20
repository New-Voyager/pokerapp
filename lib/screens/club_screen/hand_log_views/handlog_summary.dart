import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandlogSummary extends StatelessWidget {
  final HandLogModelNew handlogModel;

  HandlogSummary({@required this.handlogModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // The summary title
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.pw, vertical: 4.ph),
            decoration: BoxDecoration(
              color: AppColorsNew.newGreenRadialStartColor,
              borderRadius: BorderRadius.circular(7.pw),
            ),
            padding: EdgeInsets.all(8.pw),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              AppStringsNew.SummaryText,
              style: AppStylesNew.valueTextStyle,
            ),
          ),

          // main body
          Container(
            padding: EdgeInsets.only(bottom: 16.ph),
            child: ListView.separated(
              itemBuilder: (context, index) {
                log("TOTAL : ${handlogModel.hand.playersInSeats.length}");
                return actionRow(handlogModel.hand.playersInSeats[index]);
              },
              itemCount: handlogModel.hand.playersInSeats.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                endIndent: 16.pw,
                indent: 16.pw,
                color: AppColorsNew.newBackgroundBlackColor,
                height: 1.ph,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionRow(Player player) {
    final int diff = player.balance.after - player.balance.before;
    String playerName = 'Player';
    if (player != null) {
      playerName = getPlayerNameBySeatNo(
        handLogModel: handlogModel,
        seatNo: player.seatNo,
      );
    }
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
      margin: EdgeInsets.symmetric(horizontal: 8.pw),
      padding: EdgeInsets.symmetric(horizontal: 8.pw, vertical: 4.ph),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // player name
          Expanded(
            flex: 4,
            child: Text(
              playerName,
              style: AppStylesNew.playerNameTextStyle,
              textAlign: TextAlign.left,
            ),
          ),

          // NOTHING
          Expanded(
            flex: 2,
            child: const SizedBox.shrink(),
          ),

          // difference
          Expanded(
            flex: 2,
            child: Text(
              diff.toString(),
              style: TextStyle(
                color: (diff > 0) ? Colors.green : Colors.red,
                fontSize: 9.0.dp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // final player balance
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
