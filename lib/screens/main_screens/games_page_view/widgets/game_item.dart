import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/mock_data/mock_game_data.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/enums.dart';
import 'package:pokerapp/widgets/text_button.dart';

class GameItem extends StatelessWidget {
  GameItem({
    @required this.game,
    this.gameStatus = GameStatus.PlayedGames,
  });

  final MockGameData game;
  final GameStatus gameStatus;

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
          Radius.circular(AppDimensions.cardRadius),
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
                        style: AppStyles.itemInfoTextStyle,
                      ),
                      Spacer(),

                      /*
                      * Game ID
                      * */

                      Text(
                        'Game ID - ${game.gameID}',
                        style: AppStyles.itemInfoTextStyle,
                      ),
                      separator,

                      /*
                      *  for played games -  session time and end time
                      *  for live games - open seats and
                      * */

                      gameStatus == GameStatus.LiveGames
                          ? Text(
                              "${game.openSeats == '0' ? 'No' : game.openSeats} Open Seat${game.openSeats == '1' ? '' : 's'}${'\t' * 4}${game.gameStartedAt}",
                              style: AppStyles.itemInfoTextStyle,
                            )
                          : Text(
                              "Session Time ${game.sessionTime}${'\t' * 4}Ended at : ${game.gameEndedAt}",
                              style: AppStyles.itemInfoTextStyle,
                            ),
                    ],
                  ),

                  /*
                  * for played games - profit or loss
                  * for live games - Join or Join Waitlist button
                  * */

                  Align(
                    alignment: Alignment.centerRight,
                    child: gameStatus == GameStatus.LiveGames
                        ? TextButton(
                            split: true,
                            text: game.openSeats == '0'
                                ? 'Join Waitlist'
                                : 'Join',
                            onTap: () {},
                          )
                        : Text(
                            '${double.parse(game.profit) == 0 ? '' : (double.parse(game.profit) > 0 ? '+' : '-')}${game.profit}',
                            style: TextStyle(
                              color: double.parse(game.profit) > 0
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
