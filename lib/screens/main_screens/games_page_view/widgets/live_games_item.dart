import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

class LiveGameItem extends StatelessWidget {
  final GameModelNew game;
  final Function onTapFunction;

  LiveGameItem({this.game, this.onTapFunction});
  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("liveGameItem");
    DecorationImage clubImage;
    if (game.clubPicUrl != null && !game.clubPicUrl.isEmpty) {
      clubImage = DecorationImage(
        image: CachedNetworkImageProvider(
          game.clubPicUrl,
        ),
        fit: BoxFit.cover,
      );
    }
    return Consumer<AppTheme>(builder: (_, theme, __) {
      final gameType = gameTypeFromStr(game.gameType);
      final gameTypeStr = gameTypeShortStr(gameType);
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 12.pw,
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
            ),
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      theme.gameListShadeColor, BlendMode.srcATop),
                  child: Image(
                    image: AssetImage(
                      AppAssetsNew.pathLiveGameItemBackground,
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.pw,
                    top: 8.ph,
                    bottom: 8.ph,
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
                            (game.clubCode != null)
                                ? Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 26.pw,
                                      width: 26.pw,
                                      decoration: BoxDecoration(
                                          image: clubImage,
                                          borderRadius:
                                              BorderRadius.circular(13.pw)),
                                      padding: EdgeInsets.all(5.pw),
                                      // child: SvgPicture.asset(
                                      //     'assets/icons/clubs.svg',
                                      //     height: 24.pw,
                                      //     width: 24.pw,
                                      //     color: Colors.white),
                                    ))
                                : Container(),
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
                                      '${_appScreenText['buyin']}: ${DataFormatter.chipsFormat(game.buyInMin)}-${DataFormatter.chipsFormat(game.buyInMax)}',
                                      style: AppDecorators.getSubtitle1Style(
                                          theme: theme),
                                    ),
                                    AppDimensionsNew.getHorizontalSpace(16.pw),
                                  ],
                                ),
                                Text(
                                  "${gameTypeStr} ${DataFormatter.chipsFormat(game.smallBlind)}/${DataFormatter.chipsFormat(game.bigBlind)}",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                AppDimensionsNew.getVerticalSizedBox(4.ph),
                                Text(
                                  "${_appScreenText['gameId']}: ${game.gameCode}",
                                  style: AppDecorators.getSubtitle2Style(
                                      theme: theme),
                                ),
                                AppDimensionsNew.getVerticalSizedBox(2.ph),
                                Text(
                                  GameModelNew.getSeatsAvailble(game) > 0
                                      ? "${game.maxPlayers - game.tableCount} ${_appScreenText['openSeats']}"
                                      : game.waitlistCount > 0
                                          ? "${_appScreenText['tableIsFull']} (${game.waitlistCount} ${_appScreenText['waiting']})"
                                          : "${_appScreenText['tableIsFull']}",
                                  style: AppDecorators.getSubtitle1Style(
                                      theme: theme),
                                ),
                                AppDimensionsNew.getVerticalSizedBox(8.ph),
                                Text(
                                  "${_appScreenText['started']} ${DataFormatter.getTimeInHHMMFormat(game.elapsedTime)} ${_appScreenText['ago']}.",
                                  style: AppDecorators.getSubtitle3Style(
                                      theme: theme),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20.ph,
            right: 5.pw,
            child: RoundRectButton(
              text: GameModelNew.getSeatsAvailble(game) > 0
                  ? "${_appScreenText['join']}"
                  : "${_appScreenText['view']}",
              onTap: onTapFunction,
              theme: theme,
            ),
          ),
        ],
      );
    });
  }
}
