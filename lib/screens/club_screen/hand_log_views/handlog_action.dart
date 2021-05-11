import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';

class HandLogActionView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  HandLogActionView({this.handLogModel});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        Player player = handLogModel.hand.players[(index + 1).toString()];
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
                  _getPlayerName(player),
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
      separatorBuilder: (context, index) => Divider(),
      itemCount: handLogModel.hand.players.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }

  String _getPlayerName(Player player) {
    int i = handLogModel.players
        .lastIndexWhere((element) => (player.id == element.id.toString()));
    if (i == -1) {
      return "Player";
    } else {
      return handLogModel.players[i].name;
    }
  }
}
