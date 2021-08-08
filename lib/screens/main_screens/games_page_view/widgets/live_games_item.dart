import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/rounded_accent_button.dart';
import 'package:provider/provider.dart';

class LiveGameItem extends StatelessWidget {
  final GameModelNew game;
  final Function onTapFunction;

  LiveGameItem({this.game, this.onTapFunction});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 12.pw,
            ),
            padding: EdgeInsets.only(
              left: 16.pw,
              top: 8.ph,
              bottom: 8.ph,
            ),
            constraints: BoxConstraints(
              minHeight: 100.ph,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.secondaryColorWithDark(0.3),
                width: 2.pw,
              ),
              borderRadius: BorderRadius.circular(
                8.pw,
              ),
              color: theme.primaryColorWithDark(),
              image: DecorationImage(
                image: AssetImage(
                  AppAssetsNew.pathLiveGameItemBackground,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        AppAssetsNew.pathGameTypeChipImage,
                        height: 100.ph,
                        width: 100.ph,
                      ),
                      Image.asset(
                        GameModelNew.getGameTypeImageAsset(game.gameType),
                        height: 60.ph,
                        width: 60.ph,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 9,
                    child: Container(
                      margin: EdgeInsets.only(left: 16.pw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${AppStringsNew.BuyIn}: ${game.buyInMin}-${game.buyInMax}',
                                style: AppDecorators.getSubtitle1Style(
                                    theme: theme),
                              ),
                              AppDimensionsNew.getHorizontalSpace(16.pw),
                            ],
                          ),
                          Text(
                            "${GameModelNew.getGameTypeStr(game.gameType)} ${game.smallBlind}/${game.bigBlind}",
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          ),
                          AppDimensionsNew.getVerticalSizedBox(4.ph),
                          Text(
                            "${AppStringsNew.GameId} - ${game.gameCode}",
                            style:
                                AppDecorators.getSubtitle2Style(theme: theme),
                          ),
                          AppDimensionsNew.getVerticalSizedBox(2.ph),
                          Text(
                            GameModelNew.getSeatsAvailble(game) > 0
                                ? "${game.maxPlayers} ${AppStringsNew.OpenSeats}"
                                : game.waitlistCount > 0
                                    ? "${AppStringsNew.TableFull} (${game.waitlistCount} ${AppStringsNew.Waiting})"
                                    : "${AppStringsNew.TableFull}",
                            style:
                                AppDecorators.getSubtitle1Style(theme: theme),
                          ),
                          AppDimensionsNew.getVerticalSizedBox(8.ph),
                          Text(
                            "${AppStringsNew.Started} ${DataFormatter.getTimeInHHMMFormat(game.elapsedTime)} ${AppStringsNew.Ago}.",
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Positioned(
            bottom: 20.ph,
            right: 5.pw,
            child: RoundedColorButton(
              text: GameModelNew.getSeatsAvailble(game) > 0
                  ? "${AppStringsNew.Join}"
                  : "${AppStringsNew.View}",
              onTapFunction: onTapFunction,
              backgroundColor: theme.accentColor,
              textColor: theme.primaryColorWithDark(),
            ),
          ),
        ],
      ),
    );
  }
}
