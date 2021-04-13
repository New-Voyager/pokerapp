import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/card_view.dart';

class HandLogHeaderView extends StatelessWidget {
  final HandLogModel _handLogModel;

  HandLogHeaderView(this._handLogModel);

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      elevation: 5.5,
      color: AppColors.cardBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
                  margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  child: Text(
                    "Game: " + _handLogModel.gameCode,
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        "Hand: #" + _handLogModel.handNumber.toString(),
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Text(
                    //     "Duration: " + _printDuration(_handLogModel.handDuration),
                    //     style: const TextStyle(
                    //       fontFamily: AppAssets.fontFamilyLato,
                    //       color: Colors.white,
                    //       fontSize: 14.0,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10,bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Community Cards",
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          CommunityCardWidget(
                              _handLogModel.communityCards.cast<int>().toList(),
                              _handLogModel.gameWonAt == GameStages.SHOWDOWN),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Visibility(
                        visible: _handLogModel.yourcards.length > 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Your Cards",
                                style: const TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            CardsView(_handLogModel.yourcards, true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
