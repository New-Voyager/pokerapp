import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';

class GameHistoryItemNew extends StatelessWidget {
  final GameHistoryModel game;
  final bool showClubName;
  const GameHistoryItemNew({Key key, this.game, this.showClubName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("gameHistoryItemNew");

    Widget clubName = Container();
    AppTheme theme = AppTheme.getTheme(context);

    if ((this.showClubName ?? false) && this.game.clubName != null) {
      clubName = Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              _appScreenText['club'],
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              " ${this.game.clubName}",
              style: AppDecorators.getSubtitle2Style(theme: theme),
            ),
          ),
        ],
      );
    }

    return Consumer<AppTheme>(builder: (_, theme, __) {
      final gameType = gameTypeFromStr(game.gameTypeStr);
      final gameStr = gameTypeStr(gameType);

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: AppDecorators.getGameItemDecoration(theme: theme),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    "${GameModelNew.getGameTypeImageAsset(game.gameTypeStr)}",
                    width: 48.pw,
                    height: 48.ph,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "${gameStr}",
                              style:
                                  AppDecorators.getHeadLine3Style(theme: theme),
                              children: [
                                TextSpan(
                                  text:
                                      "${DataFormatter.chipsFormat(game.smallBlind)}/${DataFormatter.chipsFormat(game.bigBlind)}",
                                  style: AppDecorators.getAccentTextStyle(
                                          theme: theme)
                                      .copyWith(fontSize: 16.dp),
                                )
                              ],
                            ),
                          ),
                          clubName,
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _appScreenText['hostedBy'],
                                  style: AppDecorators.getSubtitle1Style(
                                      theme: theme),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  " ${game.startedBy}",
                                  style: AppDecorators.getSubtitle2Style(
                                      theme: theme),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${_appScreenText['startedAt']}",
                                    style: AppDecorators.getSubtitle1Style(
                                        theme: theme),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    " ${DataFormatter.dateFormat(game.startedAt)}",
                                    style: AppDecorators.getSubtitle2Style(
                                        theme: theme),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${_appScreenText['runningTime']}",
                                  style: AppDecorators.getSubtitle1Style(
                                      theme: theme),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  " ${DataFormatter.getTimeInHHMMFormatInMin(game.runTime)}",
                                  style: AppDecorators.getSubtitle2Style(
                                      theme: theme),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${_appScreenText['sessionTime']}",
                                    style: AppDecorators.getSubtitle1Style(
                                        theme: theme),
                                  )),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  " ${DataFormatter.getTimeInHHMMFormatInMin(game.sessionTime)}",
                                  style: AppDecorators.getSubtitle2Style(
                                      theme: theme),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "${DataFormatter.chipsFormat(game.balance)}",
                        style: TextStyle(
                          color: getBalanceColor(game.balance),
                          fontSize: 24.0.pw,
                          fontFamily: AppAssetsNew.fontFamilyPoppins,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Color getBalanceColor(double number) {
    if (number == null) {
      return AppColorsNew.newTextColor;
    }

    return number == 0
        ? AppColorsNew.newTextColor
        : number > 0
            ? AppColorsNew.newGreenButtonColor
            : AppColorsNew.newRedButtonColor;
  }
}
