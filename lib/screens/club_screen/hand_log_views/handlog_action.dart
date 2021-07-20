import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandLogActionView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  HandLogActionView({this.handLogModel});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        Player player = handLogModel.hand.playersInSeats[index];
        if (player.received <= 0) {
          return Container();
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.pw),
          padding: EdgeInsets.all(8.pw),
          decoration: BoxDecoration(
            color: AppColorsNew.actionRowBgColor,
            borderRadius: BorderRadius.circular(5.pw),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // player name
              Expanded(
                flex: 4,
                child: Text(
                  getPlayerNameBySeatNo(
                      handLogModel: handLogModel, seatNo: player.seatNo),
                  style: AppStylesNew.playerNameTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),

              // received text
              Expanded(
                flex: 2,
                child: Text(
                  'Received',
                  style: AppStylesNew.playerNameTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),

              // received value
              Expanded(
                flex: 2,
                child: Text(
                  player.received.toString(),
                  style: AppStylesNew.balanceTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),

              // player balance after
              Expanded(
                flex: 2,
                child: Text(
                  player.balance.after.toString(),
                  style: AppStylesNew.balanceTextStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        Player player = handLogModel.hand.playersInSeats[index];
        if (player.received <= 0) {
          return Container();
        }
        return Divider(
          endIndent: 16.pw,
          indent: 16.pw,
          color: Colors.transparent,
          height: 1.ph,
        );
      },
      itemCount: handLogModel.hand.playersInSeats.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }
}
