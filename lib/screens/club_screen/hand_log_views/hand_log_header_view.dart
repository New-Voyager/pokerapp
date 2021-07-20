import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandLogHeaderView extends StatelessWidget {
  final HandLogModelNew _handLogModel;

  HandLogHeaderView(this._handLogModel);

  Widget _buildTitledCards({
    @required final String text,
    @required final List<int> boardCards,
    @required final bool show,
    bool is00 = false,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 5.ph, bottom: 5.ph),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.ph),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 6.5.dp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.90.pw,
            alignment: is00 ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              child: is00
                  ? StackCardView00(
                      cards: boardCards,
                      show: show,
                    )
                  : StackCardView02(
                      cards: boardCards,
                      show: show,
                    ),
            ),
          ),
        ],
      ),
    );
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // community cards
              _buildTitledCards(
                text: 'Community Cards',
                boardCards: _handLogModel.hand.boardCards,
                show: _handLogModel.hand.handLog.wonAt == GameStages.SHOWDOWN,
              ),

              // your cards
              _buildTitledCards(
                is00: true,
                text: 'Your Cards',
                boardCards: _handLogModel.getMyCards(),
                show: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
