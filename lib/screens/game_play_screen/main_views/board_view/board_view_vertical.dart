import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view_vertical.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/utils/listenable.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';

import 'decorative_views/background_view.dart';

class BoardViewVertical extends StatefulWidget {
  final GameComService gameComService;
  final GameInfoModel gameInfo;
  final Function(Seat seat) onUserTap;
  final Function() onStartGame;

  BoardViewVertical({
    @required this.gameInfo,
    @required this.onUserTap,
    @required this.onStartGame,
    @required this.gameComService,
  });

  @override
  State<BoardViewVertical> createState() => _BoardViewVerticalState();
}

class _BoardViewVerticalState extends State<BoardViewVertical> {
  GameState gameState;

  @override
  void initState() {
    super.initState();

    gameState = GameState.getState(context);
    gameState.gameUIState.init(context);

    // this calculates the table size after drawing the table image
    gameState.gameUIState.calculateTableSizePostFrame();
    gameState.gameUIState.calculatePlayersOnTablePositionPostFrame();
  }

  @override
  Widget build(BuildContext context) {
    final boardAttributes = gameState.getBoardAttributes(context);
    final isBoardHorizontal =
        boardAttributes.orientation == BoardOrientation.horizontal;
    var dimensions = boardAttributes.dimensions(context);

    return DebugBorderWidget(
      key: gameState.gameUIState.boardKey,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: DebugBorderWidget(
              color: Colors.green,
              child: TableView(
                  tableWidthFactor: gameState.gameUIState.tableWidthFactor),
            ),
          ),

          // new players view
          ValueListenableBuilder(
            valueListenable: gameState.gameUIState.tableSizeVn,
            builder: (_, size, __) {
              if (size == null) return const SizedBox.shrink();
              Rect rect = gameState.gameUIState.getPlayersOnTableRect();
              log('PlayersOnTableViewNew Rect2: ${rect}');

              Widget child = DebugBorderWidget(
                color: Colors.green,
                child: PlayersOnTableViewNewVertical(
                  tableSize: size,
                  onUserTap: widget.onUserTap,
                  gameComService: widget.gameComService,
                  gameState: gameState,
                  maxPlayers: widget.gameInfo.maxPlayers,
                  isLargerScreen: Screen.isLargeScreen,
                ),
              );

              return Positioned(top: rect.top, left: rect.left, child: child);
            },
          ),

          /* new center view */

          ValueListenableBuilder2(
            gameState.gameUIState.tableSizeVn,
            gameState.gameUIState.playerOnTablePositionVn,
            builder: (_, Size tableSize, Offset position, __) {
              if (tableSize == null || position == null) {
                return const SizedBox.shrink();
              }

              final rect = gameState.gameUIState.centerViewRect;
              return Positioned(
                left: rect.left,
                top: rect.top,
                child: DebugBorderWidget(
                  color: Colors.yellow,
                  child: SizedBox.fromSize(
                    size: Size(rect.width, rect.height),
                    child: CenterView(
                      tableState: context.read<TableState>(),
                      gameCode: widget.gameInfo.gameCode,
                      isHost: widget.gameInfo.isHost,
                      isBoardHorizontal: isBoardHorizontal,
                      onStartGame: widget.onStartGame,
                    ),
                  ),
                ),
              );
            },
          ),

          /* distributing card animation widgets */
          Align(
            alignment: Alignment.center,
            child: MultipleCardDistributionAnimatingWidget(
              gameState,
              key: Key('card-distribution-widget'),
            ),
          ),

          /* this widget is used to show animating of stacks in case user changes seats */
          Align(child: StackSwitchSeatAnimatingWidget()),
        ],
      ),
    );
  }
}
