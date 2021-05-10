import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

class HandlogSummary extends StatelessWidget {
  final HandLogModelNew handlogModel;

  HandlogSummary({this.handlogModel});
  @override
  Widget build(BuildContext context) {
    //   log(handlogModel.hand.data.players.length.toString());

    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(7)),
            padding: EdgeInsets.all(8),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              "Summary",
              style: AppStyles.boldTitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              itemBuilder: (context, index) {
                log("TOTAL : ${handlogModel.hand.players.length}");
                // log(handlogModel.hand.data.players[(index + 1).toString()].id);
                return actionRow(
                    handlogModel.hand.players[(index + 1).toString()]);
              },
              itemCount: handlogModel.hand.players.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionRow(Player player) {
    final int diff = player.balance.after - player.balance.before;
    int index = handlogModel.players
        .indexWhere((element) => element.id.toString() == player.id);
    String playerName =
        index != -1 ? handlogModel.players[index].name : "Player";
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              playerName,
              style: AppStyles.playerNameTextStyle,
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
                fontFamily: AppAssets.fontFamilyLato,
                color: (diff > 0) ? Colors.green : Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              player.balance.after.toString(),
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
