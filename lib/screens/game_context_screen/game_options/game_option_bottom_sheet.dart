import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

import 'game_option/game_option.dart';

class GameOptionsBottomSheet extends StatefulWidget {
  final GameState gameState;
  final GameContextObject gameContextObj;
  final bool focusWaitingList;
  GameOptionsBottomSheet(
      {this.gameContextObj, this.gameState, this.focusWaitingList = false});

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
              widget.gameContextObj,
              widget.gameState,
              widget.gameState.gameCode,
              currentPlayer.uuid,
              currentPlayer.isAdmin(),
              widget.focusWaitingList,
            ),
          ),
        ],
      ),
    );
  }
}
