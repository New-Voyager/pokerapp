import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';

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
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColorsNew.actionRowBgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  getPlayerNameBySeatNo(
                      handLogModel: handLogModel, seatNo: player.seatNo),
                  style: AppStylesNew.playerNameTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Recieved",
                  style: AppStylesNew.playerNameTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  player.received.toString(),
                  style: AppStylesNew.balanceTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
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
          endIndent: 16,
          indent: 16,
          color: Colors.transparent,
          height: 1,
        );
      },
      itemCount: handLogModel.hand.playersInSeats.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }
}
