import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import '../../main.dart';

class ClubGameItem extends StatelessWidget {
  final GameModel _clubGameModel;

  const ClubGameItem(this._clubGameModel);

  GameModel get clubGameModel => _clubGameModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
      decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          boxShadow: AppStyles.cardBoxShadow,
          borderRadius:
              BorderRadius.all(Radius.circular(AppDimensions.cardRadius))),
      child: Row(
        children: <Widget>[
          /*
          * color
          * */
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                    child: Text(
                      _clubGameModel.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontFamily: AppAssets.fontFamilyLato,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            _clubGameModel.smallBlind.toString() +
                                "/" +
                                _clubGameModel.bigBlind.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.contentColor,
                              fontSize: 12.0,
                              fontFamily: AppAssets.fontFamilyLato,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "BUY IN : " +
                                _clubGameModel.buyInMin.toString() +
                                "/" +
                                _clubGameModel.buyInMax.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.contentColor,
                              fontSize: 12.0,
                              fontFamily: AppAssets.fontFamilyLato,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            _clubGameModel.seatsAvailable == 0
                                ? "Table is full"
                                : _clubGameModel.seatsAvailable.toString() +
                                    " open seats",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.contentColor,
                              fontSize: 12.0,
                              fontFamily: AppAssets.fontFamilyLato,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            _clubGameModel.waitList != 0
                                ? _clubGameModel.waitList.toString() +
                                    " in the waiting list"
                                : "",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.contentColor,
                              fontSize: 12.0,
                              fontFamily: AppAssets.fontFamilyLato,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: CustomTextButton(
                text: _clubGameModel.waitList == 0 ? "Join" : "Join Waitlist",
                onTap: () => navigatorKey.currentState.pushNamed(
                  Routes.game_play,
                  arguments: clubGameModel.gameCode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
