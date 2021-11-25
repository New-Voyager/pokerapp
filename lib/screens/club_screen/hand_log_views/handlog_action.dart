import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';

class HandLogActionView extends StatelessWidget {
  final AppTextScreen appTextScreen;
  final HandResultData handResult;
  HandLogActionView({this.handResult, this.appTextScreen});

  @override
  Widget build(BuildContext context) {
    final playersInSeats = handResult.result.playerInfo.keys.toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final seatNo = playersInSeats[index];
        final player = handResult.getPlayerBySeatNo(seatNo);
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
                    player.name,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    appTextScreen['received'],
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
                    DataFormatter.chipsFormat(player.balance.after,
                        chipUnit: ChipUnit.CENT),
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
        final seatNo = playersInSeats[index];
        final player = handResult.getPlayerBySeatNo(seatNo);
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
      itemCount: playersInSeats.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }
}
