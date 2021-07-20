import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandlogShowDown extends StatelessWidget {
  final HandLogModelNew handLogModel;
  HandlogShowDown({this.handLogModel});
  @override
  Widget build(BuildContext context) {
    // if NOT won at SHOWDOWN, return empty widget
    if (handLogModel.hand.handLog.wonAt != GameStages.SHOWDOWN) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // hand stage header
        HandStageHeader(
          stageName: 'Showdown',
          handLogModel: handLogModel,
          stageCards: handLogModel.hand.boardCards,
        ),

        // main body
        Container(
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Player player = handLogModel.hand.playersInSeats[index];

              if (player.playedUntil != "SHOW_DOWN") {
                return const SizedBox.shrink();
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.pw),
                padding: EdgeInsets.symmetric(horizontal: 8.pw, vertical: 8.ph),
                decoration: BoxDecoration(
                  color: AppColorsNew.actionRowBgColor,
                  borderRadius: BorderRadius.circular(5.pw),
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
                endIndent: 16.pw,
                indent: 16.pw,
                color: AppColorsNew.newBackgroundBlackColor,
                height: 1.ph,
              );
            },
            itemCount: handLogModel.hand.playersInSeats.length,
          ),
        )
      ],
    );
  }
}
