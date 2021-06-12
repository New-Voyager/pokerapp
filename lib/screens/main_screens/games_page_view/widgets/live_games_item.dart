import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class LiveGameItem extends StatelessWidget {
  final GameModelNew game;
  final Function onTapFunction;

  LiveGameItem({this.game, this.onTapFunction});
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                              style: AppStylesNew.buyInTextStyle,
                            ),
                            AppDimensionsNew.getHorizontalSpace(16.pw),
                          ],
                        ),
                        Text(
                          "${GameModelNew.getGameTypeStr(game.gameType)} ${game.smallBlind}/${game.bigBlind}",
                          style: AppStylesNew.gameTypeTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(4.ph),
                        Text(
                          "${AppStringsNew.GameId} - ${game.gameCode}",
                          style: AppStylesNew.gameIdTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(2.ph),
                        Text(
                          GameModelNew.getSeatsAvailble(game) > 0
                              ? "${game.maxPlayers} ${AppStringsNew.OpenSeats}"
                              : game.waitlistCount > 0
                                  ? "${AppStringsNew.TableFull} (${game.waitlistCount} ${AppStringsNew.Waiting})"
                                  : "${AppStringsNew.TableFull}",
                          style: AppStylesNew.openSeatsTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8.ph),
                        Text(
                          "${AppStringsNew.Started} ${GameModelNew.getTimeInHHMMFormat(game)} ${AppStringsNew.Ago}.",
                          style: AppStylesNew.elapsedTimeTextStyle,
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
          child: InkWell(
            onTap: onTapFunction,
            child: Container(
              child: Text(
                GameModelNew.getSeatsAvailble(game) > 0
                    ? "${AppStringsNew.Join}"
                    : "${AppStringsNew.View}",
                style: AppStylesNew.joinTextStyle,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 14.pw,
                vertical: 3.ph,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.pw),
                image: DecorationImage(
                  image: AssetImage(
                    AppAssetsNew.pathJoinBackground,
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber,
                    offset: Offset(1.pw, 0),
                    blurRadius: 5.pw,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
