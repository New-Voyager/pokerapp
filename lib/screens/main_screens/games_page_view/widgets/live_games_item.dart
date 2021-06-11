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
            horizontal: 12.pt,
          ),
          padding: EdgeInsets.only(
            left: 16.pt,
            top: 8.pt,
            bottom: 8.pt,
          ),
          constraints: BoxConstraints(
            minHeight: 130.pt,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColorsNew.newBorderColor,
              width: 2.pt,
            ),
            borderRadius: BorderRadius.circular(
              8.pt,
            ),
            color: AppColorsNew.newBackgroundBlackColor,
            image: DecorationImage(
              image: AssetImage(
                AppAssetsNew.pathLiveGameItemBackground,
              ),
              fit: BoxFit.contain,
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
                      height: 100.pt,
                      width: 100.pt,
                    ),
                    Image.asset(
                      GameModelNew.getGameTypeImageAsset(game.gameType),
                      height: 60.pt,
                      width: 60.pt,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(left: 16.pt),
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
                            AppDimensionsNew.getHorizontalSpace(16.pt),
                          ],
                        ),
                        Text(
                          "${GameModelNew.getGameTypeStr(game.gameType)} ${game.smallBlind}/${game.bigBlind}",
                          style: AppStylesNew.gameTypeTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(4.pt),
                        Text(
                          "${AppStringsNew.GameId} - ${game.gameCode}",
                          style: AppStylesNew.gameIdTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(2.pt),
                        Text(
                          GameModelNew.getSeatsAvailble(game) > 0
                              ? "${game.maxPlayers} ${AppStringsNew.OpenSeats}"
                              : game.waitlistCount > 0
                                  ? "${AppStringsNew.TableFull} (${game.waitlistCount} ${AppStringsNew.Waiting})"
                                  : "${AppStringsNew.TableFull}",
                          style: AppStylesNew.openSeatsTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8.pt),
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
          bottom: 20.pt,
          right: 5.pt,
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
                horizontal: 14.pt,
                vertical: 3.pt,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.pt),
                image: DecorationImage(
                  image: AssetImage(
                    AppAssetsNew.pathJoinBackground,
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber,
                    offset: Offset(1.pt, 0),
                    blurRadius: 5.pt,
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
