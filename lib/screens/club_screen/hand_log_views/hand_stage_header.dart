import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/card_view_old.dart';

class HandStageHeader extends StatelessWidget {
  final String stageName;
  final List<int> stageCards;
  final HandLogModelNew handLogModel;
  final GameActions actions;

  HandStageHeader({
    this.stageName,
    this.handLogModel,
    this.stageCards,
    this.actions,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          //color: AppColors.lightGrayColor,
          borderRadius: BorderRadius.circular(7),
          gradient: LinearGradient(colors: [
            Colors.grey[850],
            Colors.grey[700],
          ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  stageName,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: 8, bottom: 10, right: 10),
                alignment: Alignment.centerLeft,
                child: CardsView(
                  cards: stageCards,
                  show: true,
                  needToShowEmptyCards: true,
                ),
              ),
            ],
          ),
          actions != null
              ? Container(
                  margin: EdgeInsets.all(8),
                  child: Text(
                    "Pot: ${actions.potStart ?? 0}",
                    style: AppStyles.playerNameTextStyle,
                  ),
                )
              : stageName == "Showdown"
                  ? Container(
                      child: _getPotAmountWidget(),
                      margin: EdgeInsets.all(8),
                    )
                  : Container(),
        ],
      ),
    );
  }

  _getPotAmountWidget() {
    int length = handLogModel.hand.handLog.potWinners.length;
    if (length == 1) {
      return Container(
        child: Text(
          "Pot: ${handLogModel.hand.handLog.potWinners['0'].amount}",
          style: AppStyles.playerNameTextStyle,
        ),
      );
    }
    if (length > 1) {
      String sidePots = "(";
      handLogModel.hand.handLog.potWinners.forEach((key, value) {
        if (key != "0") {
          sidePots += value.amount.toString();
          if (int.parse(key) < length) {
            sidePots += ",";
          }
        }
      });
      sidePots += ")";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              child: Text(
            "Pot: ${handLogModel.hand.handLog.potWinners['0'].amount}",
            style: AppStyles.playerNameTextStyle,
          )),
          Container(
            child: Text(
              "$sidePots",
              style: AppStyles.playerNameTextStyle,
            ),
          ),
        ],
      );
    }
  }
}
