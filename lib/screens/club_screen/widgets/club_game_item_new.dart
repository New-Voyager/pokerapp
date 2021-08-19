import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

class ClubGameItemNew extends StatelessWidget {
  final GameModel _clubGameModel;

  const ClubGameItemNew(this._clubGameModel);

  GameModel get clubGameModel => _clubGameModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: AppStylesNew.actionRowDecoration,
      child: Row(
        children: <Widget>[
          /*
          * color
          * */
          // Expanded(
          //   flex: 1,
          //   child: Container(),
          // ),
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
                              color: AppColorsNew.contentColor,
                              fontSize: 12.0,
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
                              color: AppColorsNew.contentColor,
                              fontSize: 12.0,
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
                              color: AppColorsNew.contentColor,
                              fontSize: 12.0,
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
                              color: AppColorsNew.contentColor,
                              fontSize: 12.0,
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
            child: RoundedColorButton(
              backgroundColor: AppColorsNew.yellowAccentColor,
              textColor: AppColorsNew.darkGreenShadeColor,
              // fontSize: _clubGameModel.waitList != 0 ? 8 : 6,
              text: _clubGameModel.waitList == 0 ? "Join" : "Join Waitlist",
              onTapFunction: () => navigatorKey.currentState.pushNamed(
                Routes.game_play,
                arguments: clubGameModel.gameCode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
