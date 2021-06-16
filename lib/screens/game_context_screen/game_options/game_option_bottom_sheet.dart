import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/club_games_page_view.dart';
import 'package:pokerapp/services/app/game_service.dart';

import 'game_option/game_option.dart';
import 'pending_approvals_option.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class GameOptionsBottomSheet extends StatefulWidget {
  final GameState gameState;
  GameOptionsBottomSheet(this.gameState);

  @override
  _GameOptionsState createState() => _GameOptionsState();
}

class _GameOptionsState extends State<GameOptionsBottomSheet> {
  double height, width;
  int selectedOptionIndex = 0;

  List<OptionItemModel> items = [
    OptionItemModel(image: "assets/images/casino.png", title: "Game"),
    OptionItemModel(name: "Live", title: "Live Games"),
    OptionItemModel(
        image: "assets/images/casino.png", title: "Pending Approvals"),
    OptionItemModel(
        image: "assets/images/casino.png", title: "Pending Approvals")
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final currentPlayer = widget.gameState.currentPlayer;
    return Container(
      decoration: AppStylesNew.bgCurvedGreenRadialGradient,
      height: height / 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   height: 105,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: items.length,
          //     itemBuilder: (context, index) {
          //       return optionItem(items[index], index);
          //     },
          //   ),
          // ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  AppStringsNew.gameCodeText,
                  style: AppStylesNew.labelTextStyle,
                ),
                Text(
                  "${widget.gameState.gameCode}",
                  style: AppStylesNew.valueTextStyle,
                ),
              ],
            ),
          ),

          // /* divider */
          // const SizedBox(height: 15.0),

          /* build other options */
          Expanded(
            child: selectedOptionIndex == 0
                ? GameOption(
                    widget.gameState,
                    widget.gameState.gameCode,
                    currentPlayer.uuid,
                    currentPlayer.isAdmin(),
                  )
                : selectedOptionIndex == 1
                    ? SingleChildScrollView(
                        child: FutureBuilder<List<GameModel>>(
                          future: GameService.getLiveGames(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              List<GameModel> allLiveGames = [];
                              if (snapshot.data != null) {}
                              allLiveGames = snapshot.data;
                              return ClubGamesPageView(allLiveGames);
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      )
                    : PendingApprovalsOption(),
          ),
        ],
      ),
    );
  }

  optionItem(OptionItemModel optionItem, int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedOptionIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.screenBackgroundColor,
                  shape: BoxShape.circle,
                  border: index == selectedOptionIndex
                      ? Border.all(color: AppColors.appAccentColor, width: 2)
                      : Border(),
                ),
                child: Center(
                  child: optionItem.image != null
                      ? Image.asset(
                          optionItem.image,
                        )
                      : optionItem.iconData != null
                          ? Icon(
                              optionItem.iconData,
                              size: 35,
                              color: AppColors.appAccentColor,
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.appAccentColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                optionItem.name,
                                style: AppStyles.optionname,
                              ),
                            ),
                )),
            Text(
              optionItem.title,
              style: AppStyles.optionTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
