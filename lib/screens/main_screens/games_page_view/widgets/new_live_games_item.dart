import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final double _minHeight = 130.ph;

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

      return Container(
        // margin: EdgeInsets.symmetric(
        // horizontal: 16.pw,
        // ),
        constraints: BoxConstraints(
          minHeight: _minHeight,
        ),
        child: Container(
          decoration: AppDecorators.generalListItemWidget(),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.pw,
              top: 8.ph,
              bottom: 8.ph,
              right: 8.ph,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
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
                    Expanded(
                        flex: 9,
                        child: Container(
                          margin: EdgeInsets.only(left: 16.pw),
                          constraints:
                              BoxConstraints(minHeight: _minHeight - 16),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${gameTypeStr} ${DataFormatter.chipsFormat(game.smallBlind)}/${DataFormatter.chipsFormat(game.bigBlind)}",
                                    style: AppDecorators.getHeadLine3Style(
                                            theme: theme)
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFF6DF),
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                              text: game.gameCode))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.black87,
                                            content: Text(
                                              "Game code copied to clipboard",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Code: ',
                                                style: AppDecorators
                                                        .getHeadLine5Style(
                                                            theme: theme)
                                                    .copyWith(
                                                  color: Color(0xFFFFF6DF),
                                                ),
                                              ),
                                              TextSpan(
                                                text: game.gameCode,
                                                style: AppDecorators
                                                        .getAccentTextStyle(
                                                            theme: theme)
                                                    .copyWith(
                                                      color: Color(0xFFFFF6DF),
                                                    )
                                                    .copyWith(fontSize: 10.dp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AppDimensionsNew.getHorizontalSpace(4),
                                        Icon(
                                          Icons.copy,
                                          size: 12,
                                          color: Color(0xFFFFF6DF),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppDimensionsNew.getVerticalSizedBox(16.ph),
                                  // Row(children: [
                                  //   Row(
                                  //     children: [
                                  //       Icon(
                                  //         Icons.person,
                                  //         color: theme.secondaryColorWithDark(0.1),
                                  //         size: 16.pw,
                                  //       ),
                                  //       SizedBox(width: 5),
                                  //       Text(
                                  //         '${game.tableCount}/${game.maxPlayers}',
                                  //         style: AppDecorators.getHeadLine5Style(
                                  //             theme: theme),
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   SizedBox(width: 20),
                                  //   Row(
                                  //     children: [
                                  //       Icon(
                                  //         Icons.timer,
                                  //         color: theme.secondaryColorWithDark(0.1),
                                  //         size: 16.pw,
                                  //       ),
                                  //       SizedBox(width: 5),
                                  //       Text(
                                  //         '${timeDiffStr}',
                                  //         style: AppDecorators.getHeadLine5Style(
                                  //             theme: theme),
                                  //       ),
                                  //     ],
                                  //   )
                                  // ]),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          // color:
                                          //     theme.secondaryColorWithDark(0.1),
                                          color: Color(0xFFFFF6DF),
                                          size: 16.pw,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${game.tableCount}/${game.maxPlayers}',
                                          style:
                                              AppDecorators.getHeadLine5Style(
                                                      theme: theme)
                                                  .copyWith(
                                            color: Color(0xFFFFF6DF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          // color:
                                          //     theme.secondaryColorWithDark(0.1),
                                          color: Color(0xFFFFF6DF),
                                          size: 16.pw,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${timeDiffStr}',
                                          style:
                                              AppDecorators.getHeadLine5Style(
                                                      theme: theme)
                                                  .copyWith(
                                            color: Color(0xFFFFF6DF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Text(
                    'Buy-in: ${DataFormatter.chipsFormat(game.buyInMin)}-${DataFormatter.chipsFormat(game.buyInMax)}',
                    style:
                        AppDecorators.getHeadLine5Style(theme: theme).copyWith(
                      color: Color(0xFFFFF6DF),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ThemedButton(
                    text: GameModel.getSeatsAvailble(game) > 0
                        ? "${_appScreenText['join']}"
                        : "${_appScreenText['view']}",
                    onTap: onTapFunction,
                    style: theme.blueButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
