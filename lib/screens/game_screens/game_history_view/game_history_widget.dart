import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

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
              style: AppStylesNew.itemInfoSecondaryTextStyle.copyWith(
                  color: item.balance > 0
                      ? AppColorsNew.positiveColor
                      : AppColorsNew.negativeColor)),
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
        height: 180,
        decoration: const BoxDecoration(
          color: AppColorsNew.cardBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
          boxShadow: AppStylesNew.cardBoxShadow,
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
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                /* Game type */
                                Flexible(
                                  child: Text(
                                    item.GameType,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.0,
                                      fontFamily: AppAssets.fontFamilyLato,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                colSeparator,
                                /* blinds */
                                separator,
                                Text(
                                  item.Blinds,
                                  style: AppStylesNew.blindsTextStyle,
                                ),
                              ],
                            ),
                            /* hosted by */
                            separator,
                            Row(children: [
                              Text(
                                'Hosted by',
                                style: AppStylesNew.hostInfoTextStyle,
                              ),
                              colSeparator,
                              Text(
                                item.startedBy,
                                style: AppStylesNew.hostNameTextStyle,
                              ),
                            ]),
                            separator,
                            /** started at **/
                            Row(children: [
                              Text(
                                'Started at',
                                style: AppStylesNew.hostInfoTextStyle,
                              ),
                              colSeparator,
                              Text(
                                item.StartedAt,
                                style: AppStylesNew.hostNameTextStyle,
                              ),
                            ]),
                            separator,
                            /** game time **/
                            Row(
                              children: [
                                Text(
                                  'Game ran for',
                                  style: AppStylesNew.hostInfoTextStyle,
                                ),
                                colRunTimeSeparator,
                                Text(
                                  item.runTimeStr,
                                  style: AppStylesNew.hostInfoTextStyle,
                                ),
                              ],
                            ),
                            separator,
                            Visibility(
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: item.handsPlayed > 0,
                                    child: Text(
                                      'Played for',
                                      style: AppStylesNew.hostInfoTextStyle,
                                    ),
                                  ),
                                  colRunTimeSeparator,
                                  Text(
                                    item.sessionTimeStr,
                                    style: AppStylesNew.sessionTimeTextStyle,
                                  ),
                                ],
                              ),
                              visible: item.sessionTimeStr != null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /*
          * action button or status
          * */

                Container(
                  width: 80.0,
                  decoration: const BoxDecoration(
                    color: AppColorsNew.cardBackgroundColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(AppDimensions.cardRadius),
                    ),
                    boxShadow: AppStylesNew.cardBoxShadowMedium,
                  ),
                  child: _buildSideAction(),
                ),
              ],
            ),
            Visibility(
              visible: item.gameNum != 0,
              child: Positioned(
                right: 8,
                top: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.gameCode,
                      style: AppStylesNew.gameCodeTextStyle,
                    ),
                    colSeparator,
                    Text(
                      '#' + item.gameNum.toString(),
                      style: AppStylesNew.hostNameTextStyle,
                    ),
                    colSeparator,
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
