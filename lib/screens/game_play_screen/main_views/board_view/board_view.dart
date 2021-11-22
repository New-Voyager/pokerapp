import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';

class BoardView extends StatelessWidget {
  final GameComService gameComService;
  final GameInfoModel gameInfo;
  final Function(Seat seat) onUserTap;
  final Function() onStartGame;
  AppTextScreen _appScreenText;

  BoardView({
    @required this.gameInfo,
    @required this.onUserTap,
    @required this.onStartGame,
    @required this.gameComService,
  });

  final GlobalKey boardViewKey = GlobalKey();

  // static Size dimensions(BuildContext context, bool isHorizontal) {
  //   var _widthMultiplier = 0.78;
  //   var _heightMultiplier = 2.0;

  //   double width = MediaQuery.of(context).size.width;
  //   double heightOfBoard = width * _widthMultiplier * _heightMultiplier;
  //   double widthOfBoard = width * _widthMultiplier;

  //   if (isHorizontal) {
  //     widthOfBoard = MediaQuery.of(context).size.width;
  //     heightOfBoard = MediaQuery.of(context).size.height / 2.8;
  //   }

  //   return Size(widthOfBoard, heightOfBoard);
  // }

  @override
  Widget build(BuildContext context) {
    _appScreenText = getAppTextScreen("boardView");

    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    gameState.boardKey = boardViewKey;
    final boardAttributes = gameState.getBoardAttributes(context);
    final isBoardHorizontal =
        boardAttributes.orientation == BoardOrientation.horizontal;
    var dimensions = boardAttributes.dimensions(context);
    var bottomPos = boardAttributes.tableBottomPos;
    var tableScale = boardAttributes.tableScale;
    //bottomPos = -160;
    /* finally the view */
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: dimensions.width,
          height: dimensions.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 3),
            color: Colors.transparent,
          ),
        ),        
        Positioned(
            bottom: bottomPos,
            child: Transform.scale(
                scale: tableScale,
                child: TableView(
                    width: dimensions.width, height: dimensions.height))),

        /* players */
        Transform.translate(
          offset: boardAttributes.playerOnTableOffset,
          child: PlayersOnTableView(
            gameComService: gameComService,
            isBoardHorizontal:
                boardAttributes.orientation == BoardOrientation.horizontal,
            widthOfBoard: dimensions.width,
            heightOfBoard: dimensions.height,
            onUserTap: onUserTap,
            maxPlayers: gameInfo.maxPlayers,
            gameState: gameState,
          ),
        ),

        /* center view */
        Positioned(
          top: boardAttributes.centerOffset.dy,
          left: boardAttributes.centerOffset.dx,
          width: boardAttributes.centerSize.width,
          height: boardAttributes.centerSize.height,
          child: Builder(
            builder: (context) {
              // final cards = tableState.cards;
              // final cardsOther = tableState.cardsOther;
              // final pots = tableState.potChips;

              return Transform.scale(
                scale: boardAttributes.centerViewCenterScale,
                child: CenterView(
                  tableState: context.read<TableState>(),
                  gameCode: gameInfo.gameCode,
                  isHost: gameInfo.isHost,
                  isBoardHorizontal: isBoardHorizontal,
                  onStartGame: onStartGame,
                ),
              );
            },
          ),
        ),

        /* distributing card animation widgets */
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: boardAttributes.centerViewCardShufflePosition,
            child: CardDistributionAnimatingWidget(),
          ),
        ),

        /* this widget is used to show animating of stacks in case user changes seats */
        Align(child: StackSwitchSeatAnimatingWidget()),
      ],
    );
  }
}
