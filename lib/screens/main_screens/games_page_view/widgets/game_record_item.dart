import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';

class GameRecordItem extends StatelessWidget {
  final GameHistoryModel game;
  final Function onTapFunction;
  GameRecordItem({this.game, this.onTapFunction});
  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("gameRecordItem");

    return InkWell(
      onTap: onTapFunction,
      child: Container(
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
            color: AppColorsNew.newBorderColor,
            width: 2.pw,
          ),
          borderRadius: BorderRadius.circular(
            8.pw,
          ),
          color: AppColorsNew.newBackgroundBlackColor,
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
                    GameModelNew.getGameTypeImageAsset(game.gameTypeStr),
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
                      Text(
                        "${GameModelNew.getGameTypeStr(game.gameTypeStr)} ${game.smallBlind}/${game.bigBlind}",
                        style: AppStylesNew.gameTypeTextStyle,
                      ),
                      AppDimensionsNew.getVerticalSizedBox(4.ph),
                      Text(
                        "${AppStringsNew.GameId} - ${game.gameCode}",
                        style: AppStylesNew.gameIdTextStyle,
                      ),
                      AppDimensionsNew.getVerticalSizedBox(2.ph),
                      // Text(
                      //   GameModelNew.getSeatsAvailble(game) > 0
                      //       ? "${game.maxPlayers} ${AppStringsNew.OpenSeats}"
                      //       : game.waitlistCount > 0
                      //           ? "${AppStringsNew.TableFull} (${game.waitlistCount} ${AppStringsNew.Waiting})"
                      //           : "${AppStringsNew.TableFull}",
                      //   style: AppStylesNew.openSeatsTextStyle,
                      // ),
                      AppDimensionsNew.getVerticalSizedBox(8.ph),
                      Text(
                        "${DataFormatter.getTimeInHHMMFormat(game.runTime)}",
                        style: AppStylesNew.elapsedTimeTextStyle,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
