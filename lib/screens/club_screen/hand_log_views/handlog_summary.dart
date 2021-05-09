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
            margin: EdgeInsets.all(8),
            child: Text(
              "SUMMARY",
              style: AppStyles.boldTitleTextStyle.copyWith(fontSize: 14),
            ),
          ),
          Card(
            color: AppColors.cardBackgroundColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Player",
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamilyLato,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "",
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Diff",
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamilyLato,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Balance",
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamilyLato,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.listViewDividerColor,
                  indent: 5.0,
                  endIndent: 5.0,
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    // log(handlogModel.hand.data.players[(index + 1).toString()].id);
                    return actionRow(
                        handlogModel.hand.data.players[(index + 1).toString()]);
                  },
                  itemCount: handlogModel.hand.data.players.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget actionRow(Player player) {
    final int diff = player.balance.after - player.balance.before;
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              handlogModel.players
                  .lastWhere((element) => element.id.toString() == player.id)
                  .name,
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
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
