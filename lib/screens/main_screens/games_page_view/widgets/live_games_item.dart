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
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

class LiveGameItem extends StatelessWidget {
  final GameModel game;
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
          cacheManager: ImageCacheManager.instance,
        ),
        fit: BoxFit.cover,
      );
    }
    return Consumer<AppTheme>(builder: (_, theme, __) {
      final gameType = gameTypeFromStr(game.gameType);
      final gameTypeStr = gameTypeShortStr(gameType);
      int timeDiff = 0;
      if (game.gameStartTime != null) {
        timeDiff = DateTime.now().difference(game.gameStartTime).inSeconds;
      }
      final timeDiffStr = DataFormatter.timeFormat(timeDiff);

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
                    left: 8.pw,
                    top: 8.ph,
                    bottom: 8.ph,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                AppAssetsNew.pathGameTypeChipImage,
                                height: 80.ph,
                                width: 80.ph,
                              ),
                              Image.asset(
                                GameModel.getGameTypeImageAsset(game.gameType),
                                height: 40.ph,
                                width: 40.ph,
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
                                      'Buy-in: ${DataFormatter.chipsFormat(game.buyInMin)}-${DataFormatter.chipsFormat(game.buyInMax)}',
                                      style: AppDecorators.getHeadLine5Style(
                                          theme: theme),
                                    ),
                                    AppDimensionsNew.getHorizontalSpace(8.pw),
                                  ],
                                ),
                                Text(
                                  "${gameTypeStr} ${DataFormatter.chipsFormat(game.smallBlind)}/${DataFormatter.chipsFormat(game.bigBlind)}",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Code: ',
                                    style: AppDecorators.getHeadLine5Style(
                                        theme: theme),
                                  ),
                                  TextSpan(
                                    text: game.gameCode,
                                    style: AppDecorators.getAccentTextStyle(
                                            theme: theme)
                                        .copyWith(fontSize: 10.dp),
                                  )
                                ])),
                                AppDimensionsNew.getVerticalSizedBox(8.ph),
                                Row(children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color:
                                            theme.secondaryColorWithDark(0.1),
                                        size: 16.pw,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '${game.tableCount}/${game.maxPlayers}',
                                        style: AppDecorators.getHeadLine5Style(
                                            theme: theme),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color:
                                            theme.secondaryColorWithDark(0.1),
                                        size: 16.pw,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '${timeDiffStr}',
                                        style: AppDecorators.getHeadLine5Style(
                                            theme: theme),
                                      ),
                                    ],
                                  )
                                ]),
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
              text: GameModel.getSeatsAvailble(game) > 0
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
