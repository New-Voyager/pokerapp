import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/enums.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

import '../../../../utils/color_generator.dart';

class GameItem extends StatelessWidget {
  GameItem({
    @required this.game,
    @required this.gameStatus,
  }) : assert(game != null && gameStatus != null);

  final GameModel game;
  final LiveOrPlayedGames gameStatus;

  void _joinGame(BuildContext context) => Navigator.pushNamed(
        context,
        Routes.game_play,
        arguments: game.gameCode,
      );

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 10.0);

    return Container(
      height: 135.0,
      /*
      * decoration of the single game item widget
      * */
      decoration: const BoxDecoration(
        color: AppColorsNew.cardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
        boxShadow: AppStylesNew.cardBoxShadow,
      ),
      child: Row(
        children: <Widget>[
          /*
          * Club logo
          * */

          Container(
            width: MediaQuery.of(context).size.width / 15,
            height: double.infinity,
            decoration: BoxDecoration(
              color: generateColorFor(game.gameCode),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
          ),

          /*
          * Game details
          * */
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /*
                      * club name
                      * */

                      Text(
                        game.title + "  " + game.gameType.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      separator,

                      /*
                      * game type
                      * */

                      Text(
                        "${game.clubName}",
                        style: AppStylesNew.itemInfoTextStyle,
                      ),
                      Spacer(),

                      /*
                      * Game ID
                      * */

                      Text(
                        'Code - ${game.gameCode}',
                        style: AppStylesNew.itemInfoTextStyle,
                      ),
                      separator,

                      /*
                      *  for played games -  session time and end time
                      *  for live games - open seats and
                      * */

                      gameStatus == LiveOrPlayedGames.LiveGames
                          ? Text(
                              "${'1' == '0' ? 'No' : '1'} Open Seat${'1' == '1' ? '' : 's'}${'\t' * 4}${'56'}",
                              style: AppStylesNew.itemInfoTextStyle,
                            )
                          : Text(
                              "Session Time ${game.sessionTime}${'\t' * 4}Ended at : ${DateFormat('dd/yy hh:mm a').format(game.endedAt)}",
                              style: AppStylesNew.itemInfoTextStyle,
                            ),
                    ],
                  ),

                  /*
                  * for played games - profit or loss
                  * for live games - Join or Join Waitlist button
                  * */

                  Align(
                    alignment: Alignment.centerRight,
                    child: gameStatus == LiveOrPlayedGames.LiveGames
                        ? CustomTextButton(
                            split: true,
                            text: 'game.openSeats' == '0'
                                ? 'Join Waitlist'
                                : 'Join',
                            onTap: () {
                              // todo: need to decide what if wait listed
                              // fixme: for now the game screen is opened
                              _joinGame(context);
                            },
                          )
                        : Text(
                            '${double.parse('0') == 0 ? '' : (double.parse('10') > 0 ? '+' : '-')}${100}',
                            style: TextStyle(
                              color: double.parse('100') > 0
                                  ? Color(0xff31fe53)
                                  : Color(0xfffe3153),
                              fontFamily: AppAssets.fontFamilyLato,
                              fontSize: 16.0,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
