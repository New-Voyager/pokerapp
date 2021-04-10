import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class GameHistoryItem extends StatelessWidget {
  final GameHistoryModel item;

  GameHistoryItem({
    @required this.item,
  }) : assert(item != null);

  Widget _buildSideAction() {
    if (item.handsPlayed <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 5.0),
        Visibility(
          child: Text(item.balance.toString(),
              style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
                  color: item.balance > 0
                      ? AppColors.positiveColor
                      : AppColors.negativeColor)),
          visible: item.handsPlayed > 0 && item.balance != null,
        ),
      ],
    );
  }

  Color getGameColor() {
    if (item.gameTypeStr == 'HOLDEM') {
      return Colors.blue;
    }
    return Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 5.0);
    var colSeparator = SizedBox(width: 10.0);
    var colRunTimeSeparator = SizedBox(width: 5.0);

    return Container(
        height: 140.0,
        decoration: const BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
          boxShadow: AppStyles.cardBoxShadow,
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*
          * member avatar
          * */
                // Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       CircleAvatar(
                //         backgroundColor: getGameColor().withOpacity(1.0),
                //         radius: 20,
                //         child: Text(
                //           item.ShortGameType,
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 13.0,
                //             fontFamily: AppAssets.fontFamilyLato,
                //             fontWeight: FontWeight.w700,
                //           ),
                //         ),
                //       ),
                //     ]),

                Container(
                  width: MediaQuery.of(context).size.width / 15,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: getGameColor(),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(AppDimensions.cardRadius),
                    ),
                  ),
                ),
                /*
          * main content
          * */

                Expanded(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  /* Game type */
                                  Text(
                                    item.GameType,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.0,
                                      fontFamily: AppAssets.fontFamilyLato,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  colSeparator,
                                  /* blinds */
                                  separator,
                                  Text(
                                    item.Blinds,
                                    style: AppStyles.blindsTextStyle,
                                  ),
                                ],
                              ),
                              /* hosted by */
                              separator,
                              Row(children: [
                                Text(
                                  'Hosted by',
                                  style: AppStyles.hostInfoTextStyle,
                                ),
                                colSeparator,
                                Text(
                                  item.startedBy,
                                  style: AppStyles.hostNameTextStyle,
                                ),
                              ]),
                              separator,
                              /** started at **/
                              Row(children: [
                                Text(
                                  'Started at',
                                  style: AppStyles.hostInfoTextStyle,
                                ),
                                colSeparator,
                                Text(
                                  item.StartedAt,
                                  style: AppStyles.hostNameTextStyle,
                                ),
                              ]),
                              separator,
                              /** game time **/
                              Row(children: [
                                Text(
                                  'Game ran for',
                                  style: AppStyles.hostInfoTextStyle,
                                ),
                                colRunTimeSeparator,
                                Text(
                                  item.runTimeStr,
                                  style: AppStyles.hostInfoTextStyle,
                                ),
                              ]),
                              separator,
                              Visibility(
                                child: Row(children: [
                                  Visibility(
                                    visible: item.handsPlayed > 0,
                                    child: Text(
                                      'Played for',
                                      style: AppStyles.hostInfoTextStyle,
                                    ),
                                  ),
                                  colRunTimeSeparator,
                                  Text(
                                    item.sessionTimeStr,
                                    style: AppStyles.sessionTimeTextStyle,
                                  ),
                                ]),
                                visible: item.sessionTimeStr != null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /*
          * action button or status
          * */

                Container(
                  width: 80.0,
                  decoration: const BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(AppDimensions.cardRadius),
                    ),
                    boxShadow: AppStyles.cardBoxShadowMedium,
                  ),
                  child: _buildSideAction(),
                ),
              ],
            ),
            Visibility(
              visible: item.gameNum != 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.gameCode,
                    style: AppStyles.gameCodeTextStyle,
                  ),
                  colSeparator,
                  Text(
                    '#' + item.gameNum.toString(),
                    style: AppStyles.hostNameTextStyle,
                  ),
                  colSeparator,
                ],
              ),
            ),
          ],
        ));
  }
}
