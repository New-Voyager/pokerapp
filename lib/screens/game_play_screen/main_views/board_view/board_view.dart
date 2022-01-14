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
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';

import 'decorative_views/background_view.dart';

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

    final tableSize = boardAttributes.tableSize;

    // TODO: WE NEED A TABLE WIDTH FACTOR FROM OUTSIDE
    double tableWidthFactor = 1.0;
    print(boardAttributes.screenDiagnolSize);
    if (boardAttributes.screenDiagnolSize > 7.0) {
      tableWidthFactor = 0.80;
    }

    // this calculates the table size after drawing the table image
    gameState.calculateTableSizePostFrame();

    return Stack(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: dimensions.height,
          child: BackgroundView(),
        ),

        TableView(tableWidthFactor: tableWidthFactor),

        /* center view */
        Positioned(
          top: boardAttributes.centerOffset.dy,
          left: boardAttributes.centerOffset.dx,
          width: boardAttributes.centerSize.width,
          height: boardAttributes.centerSize.height,
          child: Builder(
            builder: (context) {
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

        // new players view
        ValueListenableBuilder(
          valueListenable: gameState.tableSizeVn,
          builder: (_, size, __) {
            print('valuelistenablebuilder: $size');
            if (size == null) return const SizedBox.shrink();
            return PlayersOnTableViewNew(
              tableSize: size,
              onUserTap: onUserTap,
              gameComService: gameComService,
              gameState: gameState,
              maxPlayers: gameInfo.maxPlayers,
            );
          },
        ),

        /* players */
        // Transform.translate(
        //   offset: boardAttributes.playerOnTableOffset,
        //   child: PlayersOnTableView(
        //     gameComService: gameComService,
        //     isBoardHorizontal:
        //         boardAttributes.orientation == BoardOrientation.horizontal,
        //     widthOfBoard: dimensions.width,
        //     heightOfBoard: dimensions.height,
        //     onUserTap: onUserTap,
        //     maxPlayers: gameInfo.maxPlayers,
        //     gameState: gameState,
        //   ),
        // ),

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
