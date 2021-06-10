import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class HandlogShowDown extends StatelessWidget {
  final HandLogModelNew handLogModel;
  HandlogShowDown({this.handLogModel});
  @override
  Widget build(BuildContext context) {
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Player player = handLogModel.hand.playersInSeats[index];
              if (player.playedUntil != "SHOW_DOWN") {
                return Container();
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColorsNew.actionRowBgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        getPlayerNameBySeatNo(
                          handLogModel: handLogModel,
                          seatNo: player.seatNo,
                        ),
                        style: AppStylesNew.playerNameTextStyle,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: StackCardView00(
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
                color: AppColorsNew.newBackgroundBlackColor,
                height: 1,
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
