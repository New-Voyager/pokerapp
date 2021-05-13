import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/widgets/card_view.dart';

class HandlogShowDown extends StatelessWidget {
  final HandLogModelNew handLogModel;
  HandlogShowDown({this.handLogModel});
  @override
  Widget build(BuildContext context) {
    log("STAGEDDDDD - ${handLogModel.hand.handLog.wonAt.toString()}");
    if (handLogModel.hand.handLog.wonAt != GameStages.SHOWDOWN) {
      return Container();
    }
    return Column(
      children: [
        HandStageHeader(
          stageName: "Showdown",
          handLogModel: handLogModel,
          stageCards: handLogModel.hand.boardCards,
        ),
        Container(
          padding: EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Player player = handLogModel.hand.playersInSeats[index];
              if (player.playedUntil != "SHOW_DOWN") {
                return Container();
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            handLogModel.getPlayerNameBySeatNo(player.seatNo),
                            style: AppStyles.playerNameTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CardsView(
                        cards: player.cards,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              Player player = handLogModel.hand.playersInSeats[index];
              if (player.playedUntil != "SHOW_DOWN") {
                return Container();
              }
              return Divider(
                endIndent: 16,
                indent: 16,
                color: AppColors.veryLightGrayColor,
              );
            },
            itemCount: handLogModel.hand.playersInSeats.length,
          ),
        )
      ],
    );
  }

  // String _getPlayerName(Player player) {
  //   int i = handLogModel.players
  //       .lastIndexWhere((element) => (player.id == element.id.toString()));
  //   if (i == -1) {
  //     return "Player";
  //   } else {
  //     return handLogModel.players[i].name;
  //   }
  // }
}
