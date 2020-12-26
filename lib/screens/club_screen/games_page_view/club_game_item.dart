import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_game_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class ClubGameItem extends StatelessWidget {
  final ClubGameModel _clubGameModel;

  const ClubGameItem(this._clubGameModel);

  ClubGameModel get clubGameModel => _clubGameModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                      _clubGameModel.gameTitle,
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
                            _clubGameModel.smallBlind +
                                "/" +
                                _clubGameModel.bigBlind,
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
                            _clubGameModel.buyIn,
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
                            _clubGameModel.seatsAvailable,
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
                            _clubGameModel.waitList,
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
              child: Text(
                "Join",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.appAccentColor,
                  fontSize: 16.0,
                  fontFamily: AppAssets.fontFamilyLato,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
