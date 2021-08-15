import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class HandlogShowDown extends StatelessWidget {
  final HandResultData handResult;
  HandlogShowDown({this.handResult});
  @override
  Widget build(BuildContext context) {
    if (handResult.wonAt() != GameStages.SHOWDOWN) {
      return Container();
    }
    return Column(
      children: [
        HandStageHeader(
          stageName: "Showdown",
          handResult: handResult,
        ),
        Container(
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              int seatNo = handResult.result.activeSeats[index];
              final player = handResult.getPlayerBySeatNo(seatNo);
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
                        player.name,
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
              final seatNo = handResult.result.activeSeats[index];
              final player = handResult.getPlayerBySeatNo(seatNo);
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
            itemCount: handResult.result.activeSeats.length,
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
