import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

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
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  handLogModel.getPlayerNameBySeatNo(player.seatNo),
                  style: AppStyles.playerNameTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Recieved",
                  style: AppStyles.playerNameTextStyle
                      .copyWith(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  player.received.toString(),
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  player.balance.after.toString(),
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
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
          color: AppColors.veryLightGrayColor,
        );
      },
      itemCount: handLogModel.hand.playersInSeats.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }
}
