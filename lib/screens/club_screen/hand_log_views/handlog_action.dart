import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:provider/provider.dart';

class HandLogActionView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  HandLogActionView({this.handLogModel});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        Player player = handLogModel.hand.playersInSeats[index];
        if (player.received <= 0) {
          return SizedBox.shrink();
        }
        return Consumer<AppTheme>(
          builder: (_, theme, __) => Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: AppDecorators.tileDecorationWithoutBorder(theme),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    getPlayerNameBySeatNo(
                        handLogModel: handLogModel, seatNo: player.seatNo),
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    AppStringsNew.recievedText,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    player.received.toString(),
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    player.balance.after.toString(),
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
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
