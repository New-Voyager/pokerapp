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
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/sizing_utils/sizing_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'decorative_views/background_view.dart';

class BoardView extends StatelessWidget {
  final GameComService gameComService;
  final GameInfoModel gameInfo;
  final GameState gameState;
  final Function(Seat seat) onUserTap;
  final Function() onStartGame;

  BoardView({
    @required this.gameState,
    @required this.gameInfo,
    @required this.onUserTap,
    @required this.onStartGame,
    @required this.gameComService,
  });

  final GlobalKey boardViewKey = GlobalKey();

  Size _getCenterViewSize({@required Size tableSize}) {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final ts = SizingUtils.getPlayersOnTableSize(tableSize);
    final left = this.gameState.playerOnTableOffset.dx + namePlateSize.width;
    final top = this.gameState.playerOnTableOffset.dy + namePlateSize.height;
    final right = ts.width - namePlateSize.width;
    final bottom = ts.height - namePlateSize.height;

    final height = (ts.height - namePlateSize.height * 2) - 30;
    final width = (ts.width - namePlateSize.width * 2) - 20;

    return Size(width, height);
  }

  Tuple2<Offset, Size> _getCenterViewRect({@required Size tableSize}) {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final ts = SizingUtils.getPlayersOnTableSize(tableSize);
    final left = this.gameState.playerOnTableOffset.dx + namePlateSize.width;
    final top = this.gameState.playerOnTableOffset.dy + namePlateSize.height;
    double right =
        (this.gameState.playerOnTableSize.width - namePlateSize.width);
    if (Screen.isLargeScreen) {
      right =
          (this.gameState.playerOnTableSize.width - (2 * namePlateSize.width));
    }
    final bottom =
        this.gameState.playerOnTableSize.height - 2 * namePlateSize.height;
    // hack here
    double deflateSize = 10;
    if (Screen.isLargeScreen) {
      deflateSize = 40;
    }
    final rect = Rect.fromLTRB(left, top, right, bottom).deflate(deflateSize);
    final ret = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    log('CenterView: rect: $ret this.gameState.playerOnTableSize: ${this.gameState.playerOnTableSize}');
    return Tuple2<Offset, Size>(
      Offset(rect.left, rect.top - deflateSize),
      rect.size,
    );
  }

  Rect _getCenterViewRect2({@required Size tableSize}) {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final ts = SizingUtils.getPlayersOnTableSize(tableSize);
    final left = this.gameState.playerOnTableOffset.dx + namePlateSize.width;
    final top = this.gameState.playerOnTableOffset.dy + namePlateSize.height;
    final right =
        (this.gameState.playerOnTableSize.width - namePlateSize.width);
    final bottom =
        this.gameState.playerOnTableSize.height - 2 * namePlateSize.height;
    final rect = Rect.fromLTRB(left, top, right, bottom).deflate(10);
    final ret = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    log('CenterView: rect: $ret this.gameState.playerOnTableSize: ${this.gameState.playerOnTableSize}');
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    // AppTextScreen _appScreenText = getAppTextScreen("boardView");

    // final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    //gameState.boardKey = boardViewKey;
    final boardAttributes = gameState.getBoardAttributes(context);
    final isBoardHorizontal =
        boardAttributes.orientation == BoardOrientation.horizontal;
    var dimensions = boardAttributes.dimensions(context);
    // var bottomPos = boardAttributes.tableBottomPos;
    // var tableScale = boardAttributes.tableScale;

    // final tableSize = boardAttributes.tableSize;

    // TODO: WE NEED TWO NEW VARIABLES FROM OUTSIDE
    // TODO: 1. TABLE WIDTH FACTOR
    // TODO: 2. IS LARGER SCREEN
    double tableWidthFactor = 1.3;
    bool isLargerScreen = false;
    print(boardAttributes.screenDiagnolSize);
    if (boardAttributes.screenDiagnolSize > 7.0) {
      tableWidthFactor = 0.70;
      isLargerScreen = true;
    }

    // this calculates the table size after drawing the table image
    gameState.calculateTableSizePostFrame();
    gameState.calculatePlayerOnTablePostFrame();

    return DebugBorderWidget(
      key: gameState.boardKey,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: dimensions.height,
            child: BackgroundView(),
          ),

          DebugBorderWidget(
            color: Colors.green,
            child: TableView(tableWidthFactor: tableWidthFactor),
          ),

          // new players view
          ValueListenableBuilder(
            valueListenable: gameState.tableSizeVn,
            builder: (_, size, __) {
              if (size == null) return const SizedBox.shrink();
              return DebugBorderWidget(
                color: Colors.amber,
                child: PlayersOnTableViewNew(
                  key: gameState.playerOnTableKey,
                  tableSize: size,
                  onUserTap: onUserTap,
                  gameComService: gameComService,
                  gameState: gameState,
                  maxPlayers: gameInfo.maxPlayers,
                  isLargerScreen: isLargerScreen,
                ),
              );
            },
          ),

          /* new center view */
          ValueListenableBuilder(
            valueListenable: gameState.playerOnTableSizeVn,
            builder: (_, tableSize, __) {
              if (tableSize == null) return const SizedBox.shrink();

              // return DebugBorderWidget(
              //   color: Colors.lime,
              //   child: SizedBox.fromSize(
              //     size: _getCenterViewSize(tableSize: tableSize),
              //     child: CenterView(
              //       tableState: context.read<TableState>(),
              //       gameCode: gameInfo.gameCode,
              //       isHost: gameInfo.isHost,
              //       isBoardHorizontal: isBoardHorizontal,
              //       onStartGame: onStartGame,
              //     ),
              //   ),
              // );
              final tuple = _getCenterViewRect(tableSize: tableSize);
              gameState.communityCardsWidth = tuple.item2.width;
              return Positioned(
                  top: tuple.item1.dy,
                  left: tuple.item1.dx,
                  child: DebugBorderWidget(
                    color: Colors.blue,
                    child: SizedBox.fromSize(
                      size: Size(tuple.item2.width, tuple.item2.height),
                      // right: rect.right,
                      // bottom: rect.bottom,
                      child: CenterView(
                        gameState: gameState,
                        rect: Rect.fromLTWH(tuple.item1.dx, tuple.item1.dy,
                            tuple.item2.width, tuple.item2.height),
                        tableState: context.read<TableState>(),
                        gameCode: gameInfo.gameCode,
                        isHost: gameInfo.isHost,
                        isBoardHorizontal: isBoardHorizontal,
                        onStartGame: onStartGame,
                      ),
                    ),
                  ));
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
