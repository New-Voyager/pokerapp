import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class HandLogHeaderView extends StatelessWidget {
  final HandLogModelNew _handLogModel;

  HandLogHeaderView(this._handLogModel);

  // String _printDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[850],
              Colors.grey[700],
            ],
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Game: " + _handLogModel.hand.gameId,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Hand: #" + _handLogModel.hand.handNum.toString(),
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamilyLato,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
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
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Visibility(
                    visible: _getMyCards(_handLogModel).length > 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "Your Cards",
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        StackCardView00(
                          cards: _getMyCards(_handLogModel),
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

  _getMyCards(HandLogModelNew handLogModel) {
    List<int> myCards = [];
    int myId = handLogModel.myInfo.id;
    // Need to use 'orElse', otherwise it will crash.
    final player = handLogModel.hand.playersInSeats
        .firstWhere((element) => element.id == myId, orElse: () => null);
    if (player != null) {
      return player.cards;
    }
    return myCards;
  }
}
