import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandLogHeaderView extends StatelessWidget {
  final HandLogModelNew _handLogModel;

  HandLogHeaderView(this._handLogModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.pw, vertical: 4.ph),
      padding: EdgeInsets.symmetric(horizontal: 10.pw, vertical: 8.ph),
      decoration: AppStylesNew.gradientBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // game, game type, hand number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Game: " + _handLogModel.hand.gameId,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.5.dp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                _handLogModel.hand.gameType,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0.dp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Hand: #" + _handLogModel.hand.handNum.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.5.dp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),

          // community cards, and your cards row
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // community cards
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Community Cards",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.5.dp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      StackCardView02(
                        cards: _handLogModel.hand.boardCards,
                        show: _handLogModel.hand.handLog.wonAt ==
                            GameStages.SHOWDOWN,
                      ),
                    ],
                  ),
                ),

                // your cards
                Container(
                  margin: EdgeInsets.only(top: 5.ph),
                  child: Visibility(
                    visible: _handLogModel.getMyCards().length > 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.ph),
                          child: Text(
                            "Your Cards",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 6.5.dp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        StackCardView00(
                          cards: _handLogModel.getMyCards(),
                          show: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
