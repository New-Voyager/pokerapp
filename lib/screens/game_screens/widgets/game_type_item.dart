import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';

class GameTypeItem extends StatelessWidget {
  final String clubCode;
  final GameType type;
  final String imagePath;
  final bool isSelected;
  final double animValue;
  final List<GameType> gamesList;
  final Function onSettingsClick;
  final Function onArrowClick;
  GameTypeItem({
    @required this.clubCode,
    this.type,
    this.imagePath,
    this.isSelected,
    this.animValue,
    this.gamesList,
    this.onSettingsClick,
    this.onArrowClick,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColorsNew.newTileBgBlackColor,
            border: Border.all(
              color: AppColorsNew.newBlueShadeColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColorsNew.newBlueShadeColor,
                blurRadius: 5,
                spreadRadius: 0.5,
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: onArrowClick,
            child: Container(
              //this heigth should match with the image height of GameImage
              height: 80,
              child: Image.asset(
                AppAssetsNew.pathArrowImage,
                height: 32,
                width: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
          width: width,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColorsNew.newSelectedGreenColor
                : AppColorsNew.newTileBgBlackColor,
            border: Border.all(
              color: AppColorsNew.newBorderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          // -32 is for margin for container. and remaining difference is for revealing arrow.
          width: width - 32 - (isSelected ? (animValue * 64) : 0),
          child: Row(
            children: [
              AppDimensionsNew.getVerticalSizedBox(80),
              Container(
                height: 64,
                width: 64,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              AppDimensionsNew.getHorizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gameTypeStr(type),
                        style: AppStylesNew.GameTypeTextStyle.copyWith(
                            fontWeight: FontWeight.w500)),
                    Visibility(
                      child: Text(
                        _buildGameTypeStrFromList(),
                        style: AppStylesNew.OpenSeatsTextStyle.copyWith(
                            fontSize: 10),
                      ),
                      visible: (gamesList != null && gamesList.length > 0),
                    ),
                  ],
                ),
              ),
              Visibility(
                child: IconButton(
                  onPressed: onSettingsClick,
                  icon: Icon(Icons.settings),
                  color: AppColorsNew.newTextColor,
                ),
                visible: type == GameType.ROE || type == GameType.DEALER_CHOICE,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildGameTypeStrFromList() {
    if (gamesList != null) {
      String str = "(";
      for (var type in gamesList) {
        str += "${gameTypeShortStr(type)}, ";
      }
      str += ")";
      return "${str.replaceFirst(", )", ")")}";
    }
    return "";
  }
}
