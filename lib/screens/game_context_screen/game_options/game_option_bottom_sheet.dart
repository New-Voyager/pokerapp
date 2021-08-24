import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/club_games_page_view.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:provider/provider.dart';

import 'game_option/game_option.dart';
import 'pending_approvals_option.dart';

class GameOptionsBottomSheet extends StatefulWidget {
  final GameState gameState;
  GameOptionsBottomSheet(this.gameState);

  @override
  _GameOptionsState createState() => _GameOptionsState();
}

class _GameOptionsState extends State<GameOptionsBottomSheet> {
  double height, width;
  int selectedOptionIndex = 0;
  AppTextScreen _appScreenText;
  List<OptionItemModel> items = [];

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("gameHistoryView");
    items = [
      OptionItemModel(
          image: "assets/images/casino.png", title: _appScreenText['game']),
      OptionItemModel(
          name: _appScreenText['live'], title: _appScreenText['liveGames']),
      OptionItemModel(
        image: "assets/images/casino.png",
        title: _appScreenText['pendingApprovals'],
      ),
      OptionItemModel(
        image: "assets/images/casino.png",
        title: _appScreenText['pendingApprovals'],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final theme = AppTheme.getTheme(context);
    final currentPlayer = widget.gameState.currentPlayer;
    return Container(
      decoration: AppDecorators.getCurvedRadialGradient(theme),
      height: height * 0.60,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  _appScreenText['gameCode'],
                  style: AppDecorators.getSubtitle3Style(theme: theme),
                ),
                Text(
                  "${widget.gameState.gameCode}",
                  style: AppDecorators.getHeadLine4Style(theme: theme)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          /* build other options */
          Expanded(
            child: GameOption(
              widget.gameState,
              widget.gameState.gameCode,
              currentPlayer.uuid,
              currentPlayer.isAdmin(),
            ),
          ),

          // /* build other options */
          // Expanded(
          //   child: selectedOptionIndex == 0
          //       ? GameOption(
          //           widget.gameState,
          //           widget.gameState.gameCode,
          //           currentPlayer.uuid,
          //           currentPlayer.isAdmin(),
          //         )
          //       : selectedOptionIndex == 1
          //           ? SingleChildScrollView(
          //               child: FutureBuilder<List<GameModel>>(
          //                 future: GameService.getLiveGames(),
          //                 builder: (context, snapshot) {
          //                   if (snapshot.connectionState ==
          //                       ConnectionState.done) {
          //                     List<GameModel> allLiveGames = [];
          //                     if (snapshot.data != null) {}
          //                     allLiveGames = snapshot.data;
          //                     return ClubGamesPageView(allLiveGames);
          //                   }
          //                   return Center(
          //                     child: CircularProgressIndicator(),
          //                   );
          //                 },
          //               ),
          //             )
          //           : PendingApprovalsOption(),
          // ),
        ],
      ),
    );
  }

  // optionItem(OptionItemModel optionItem, int index) {
  //   return GestureDetector(
  //     onTap: () async {
  //       setState(() {
  //         selectedOptionIndex = index;
  //       });
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 30),
  //       width: 70,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //               height: 60,
  //               width: 60,
  //               padding: EdgeInsets.all(10),
  //               decoration: BoxDecoration(
  //                 color: AppColorsNew.screenBackgroundColor,
  //                 shape: BoxShape.circle,
  //                 border: index == selectedOptionIndex
  //                     ? Border.all(color: AppColorsNew.appAccentColor, width: 2)
  //                     : Border(),
  //               ),
  //               child: Center(
  //                 child: optionItem.image != null
  //                     ? Image.asset(
  //                         optionItem.image,
  //                       )
  //                     : optionItem.iconData != null
  //                         ? Icon(
  //                             optionItem.iconData,
  //                             size: 35,
  //                             color: AppColorsNew.appAccentColor,
  //                           )
  //                         : Container(
  //                             padding: EdgeInsets.symmetric(
  //                                 horizontal: 3, vertical: 1),
  //                             decoration: BoxDecoration(
  //                               color: AppColorsNew.appAccentColor,
  //                               borderRadius: BorderRadius.circular(3),
  //                             ),
  //                             child: Text(
  //                               optionItem.name,
  //                               style: AppStylesNew.optionname,
  //                             ),
  //                           ),
  //               )),
  //           Text(
  //             optionItem.title,
  //             style: AppStylesNew.optionTitle,
  //             textAlign: TextAlign.center,
  //             maxLines: 2,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
