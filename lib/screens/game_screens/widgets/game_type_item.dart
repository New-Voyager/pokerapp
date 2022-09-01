import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/utils/utils.dart';

class GameTypeItem extends StatelessWidget {
  final String clubCode;
  final GameType type;
  final String imagePath;
  final bool isSelected;
  final double animValue;
  final List<GameType> gamesList;
  final Function onSettingsClick;
  final Function onArrowClick;
  final AppTextScreen appScreenText;
  GameTypeItem({
    @required this.clubCode,
    this.type,
    this.imagePath,
    this.isSelected,
    this.animValue,
    this.gamesList,
    this.onSettingsClick,
    this.onArrowClick,
    this.appScreenText,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final theme = AppTheme.getTheme(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: AppDecorators.generalListItemWidget(),
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // decoration: AppDecorators.tileDecoration(theme),
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: Duration(milliseconds: isSelected ? 500 : 100),
                child: InkWell(
                  onTap: onArrowClick,
                  child: Container(
                    //this height should match with the image height of GameImage
                    height: 50,
                    child: Image.asset(
                      AppAssetsNew.pathArrowImage,
                      height: 32,
                      width: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              width: width,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: AppDecorators.generalListItemWidget(),
            // decoration: BoxDecoration(
            //   color: isSelected
            //       ? theme.primaryColorWithDark()
            //       : theme.fillInColor,
            //   border: Border.all(
            //     color: theme.accentColor,
            //     width: 2,
            //   ),
            //   borderRadius: BorderRadius.circular(8),
            // ),
            // -32 is for margin for container. and remaining difference is for revealing arrow.
            width: width - 32 - (isSelected ? (animValue * 64) : 0),
            child: Row(
              children: [
                AppDimensionsNew.getVerticalSizedBox(50),
                Container(
                  height: 40,
                  width: 40,
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
                      Text(
                        gameTypeStr(type),
                        style: AppDecorators.getHeadLine4Style(theme: theme),
                      ),
                      Visibility(
                        child: Text(
                          HelperUtils.buildGameTypeStrFromList(gamesList),
                          style: AppDecorators.getSubtitle2Style(theme: theme),
                        ),
                        visible: (gamesList != null && gamesList.length > 0),
                      ),
                    ],
                  ),
                ),
                // Visibility(
                //   child: IconButton(
                //     onPressed: onSettingsClick,
                //     icon: Icon(Icons.settings),
                //     color: theme.supportingColor,
                //   ),
                //   visible: type == GameType.ROE || type == GameType.DEALER_CHOICE,
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
