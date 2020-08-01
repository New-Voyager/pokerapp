import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/mock_data/mock_played_games.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/text_button.dart';

class PlayedGameItem extends StatelessWidget {
  PlayedGameItem({
    @required this.game,
  });

  final MockPlayedGames game;

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 10.0);

    return Container(
      height: 135.0,
      /*
      * decoration of the single game item widget
      * */
      decoration: const BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(AppStyles.cardRadius),
        ),
        boxShadow: AppStyles.cardBoxShadow,
      ),
      child: Row(
        children: <Widget>[
          /*
          * Club logo
          * */

          Container(
            width: 72.0,
            height: double.infinity,
            decoration: BoxDecoration(
              color: ([
                Color(0xffef9712),
                Color(0xff12efc2),
                Color(0xffef1229),
              ]..shuffle())
                  .first,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppStyles.cardRadius),
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
                        game.clubName,
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
                        "${game.gameType}${'\t' * 10}buy in : ${game.buyIn}",
                        style: const TextStyle(
                          color: Color(0xff848484),
                          fontSize: 12.0,
                          fontFamily: AppAssets.fontFamilyLato,
                        ),
                      ),
                      Spacer(),

                      /*
                      * Game ID
                      * */

                      Text(
                        'Game ID - ${game.gameID}',
                        style: const TextStyle(
                          color: Color(0xff848484),
                          fontSize: 12.0,
                          fontFamily: AppAssets.fontFamilyLato,
                        ),
                      ),
                      separator,

                      /*
                      * Session time and end time
                      * */

                      Text(
                        "Session Time ${game.sessionTime}${'\t' * 4}Ended at : ${game.gameEndedAt}",
                        style: const TextStyle(
                          color: Color(0xff848484),
                          fontSize: 12.0,
                          fontFamily: AppAssets.fontFamilyLato,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${double.parse(game.profit) == 0 ? '' : (double.parse(game.profit) > 0 ? '+' : '-')}${game.profit}',
                      style: TextStyle(
                        color: double.parse(game.profit) > 0
                            ? Color(0xff31fe53)
                            : Color(0xffff0000),
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
