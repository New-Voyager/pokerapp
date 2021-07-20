import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 8.pw, vertical: 4.ph),
      decoration: AppStylesNew.gradientBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // stage name
              Container(
                margin: EdgeInsets.only(left: 10.pw, top: 5.ph, right: 10.pw),
                alignment: Alignment.centerLeft,
                child: Text(
                  stageName,
                  style: AppStylesNew.stageNameTextStyle,
                ),
              ),

              // cards
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: 8, bottom: 10, right: 10),
                alignment: Alignment.centerLeft,
                child: Transform.scale(
                  scale: 0.90.pw,
                  alignment: Alignment.centerLeft,
                  child: StackCardView00(
                    cards: stageCards,
                    show: true,
                    needToShowEmptyCards: true,
                  ),
                ),
              ),
            ],
          ),
          actions != null
              ? Container(
                  margin: EdgeInsets.all(8.pw),
                  child: Text(
                    "Pot: ${actions.potStart ?? 0}",
                    style: AppStylesNew.potSizeTextStyle,
                  ),
                )
              : stageName == "Showdown"
                  ? Container(
                      child: _getPotAmountWidget(),
                      margin: EdgeInsets.all(8.pw),
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
            style: AppStylesNew.playerNameTextStyle,
          )),
          Container(
            child: Text(
              "$sidePots",
              style: AppStylesNew.playerNameTextStyle,
            ),
          ),
        ],
      );
    }
  }
}
