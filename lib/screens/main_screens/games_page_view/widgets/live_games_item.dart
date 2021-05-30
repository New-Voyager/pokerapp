import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';

class LiveGameItem extends StatelessWidget {
  final GameModelNew game;
  final Function onTapFunction;

  LiveGameItem({this.game, this.onTapFunction});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 16),
        //   padding: EdgeInsets.symmetric(vertical: 8),
        //   color: AppColors.newBackgroundBlackColor,
        //   child: Image.asset(
        //     "assets/images/cards/livegames_background.png",
        //     fit: BoxFit.fitWidth,
        //   ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.only(
            left: 16,
            top: 8,
            bottom: 8,
          ),
          constraints: BoxConstraints(
            minHeight: 140,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColorsNew.newBorderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
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
                      height: 100,
                      width: 100,
                    ),
                    Image.asset(
                      GameModelNew.getGameTypeImageAsset(game.gameType),
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${AppStringsNew.BuyIn}: ${game.buyInMin}-${game.buyInMax}',
                              style: AppStylesNew.BuyInTextStyle,
                            ),
                            AppDimensionsNew.getHorizontalSpace(16),
                          ],
                        ),
                        Text(
                          "${GameModelNew.getGameTypeStr(game.gameType)} ${game.smallBlind}/${game.bigBlind}",
                          style: AppStylesNew.GameTypeTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(4),
                        Text(
                          "${AppStringsNew.GameId} - ${game.gameCode}",
                          style: AppStylesNew.GameIdTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(2),
                        Text(
                          GameModelNew.getSeatsAvailble(game) > 0
                              ? "${game.maxPlayers} ${AppStringsNew.OpenSeats}"
                              : game.waitlistCount > 0
                                  ? "${AppStringsNew.TableFull} (${game.waitlistCount} ${AppStringsNew.Waiting})"
                                  : "${AppStringsNew.TableFull} ",
                          style: AppStylesNew.OpenSeatsTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Text(
                          "${AppStringsNew.Started} ${GameModelNew.getTimeInHHMMFormat(game)} ${AppStringsNew.Ago}.",
                          style: AppStylesNew.ElapsedTimeTextStyle,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 8,
          child: InkWell(
            onTap: onTapFunction,
            child: Container(
              child: Text(
                GameModelNew.getSeatsAvailble(game) > 0
                    ? "${AppStringsNew.Join}"
                    : "${AppStringsNew.View}",
                style: AppStylesNew.JoinTextStyle,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(
                      AppAssetsNew.pathJoinBackground,
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber,
                      offset: Offset(1, 0),
                      blurRadius: 5,
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
