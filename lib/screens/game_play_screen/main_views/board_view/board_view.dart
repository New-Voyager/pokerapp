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
import 'package:pokerapp/widgets/nameplate.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'decorative_views/background_view.dart';

class BoardView extends StatefulWidget {
  final GameComService gameComService;
  final GameInfoModel gameInfo;
  final Function(Seat seat) onUserTap;
  final Function() onStartGame;

  BoardView({
    @required this.gameInfo,
    @required this.onUserTap,
    @required this.onStartGame,
    @required this.gameComService,
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  GameState gameState;

  Size _getCenterViewSize({@required Size tableSize}) {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final ts = SizingUtils.getPlayersOnTableSize(tableSize);

    final height = ts.height - namePlateSize.height * 2.2;
    final width = ts.width - namePlateSize.width * 2;

    return Size(width, height);
  }

  @override
  void initState() {
    super.initState();

    gameState = GameState.getState(context);

    // this calculates the table size after drawing the table image
    gameState.gameUIState.calculateTableSizePostFrame();
    gameState.calculatePlayersOnTablePositionPostFrame();
  }

  Tuple2<Offset, Size> _getCenterViewRect({
    @required Size size,
    @required Offset position,
  }) {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final left = position.dx + namePlateSize.width;
    final top = position.dy + namePlateSize.height;

    final centerViewSize = Size(
      gameState.playerOnTableSize.width - namePlateSize.width * 2.0,
      gameState.playerOnTableSize.height - namePlateSize.height * 2.0,
    );

    final rect = Rect.fromLTWH(
      left,
      top,
      centerViewSize.width,
      centerViewSize.height,
    );

    return Tuple2<Offset, Size>(Offset(rect.left, rect.top), rect.size);
  }

  @override
  Widget build(BuildContext context) {
    // AppTextScreen _appScreenText = getAppTextScreen("boardView");

    // final theme = AppTheme.getTheme(context);
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
    double tableWidthFactor = 1.0;
    bool isLargerScreen = false;
    print(boardAttributes.screenDiagnolSize);
    if (boardAttributes.screenDiagnolSize > 7.0) {
      tableWidthFactor = 0.70;
      isLargerScreen = true;
    }

    // this calculates the table size after drawing the table image
    gameState.gameUIState.calculateTableSizePostFrame();

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
            valueListenable: gameState.gameUIState.tableSizeVn,
            builder: (_, size, __) {
              if (size == null) return const SizedBox.shrink();
              return DebugBorderWidget(
                color: Colors.amber,
                child: PlayersOnTableViewNew(
                  key: gameState.playerOnTableKey,
                  tableSize: size,
                  onUserTap: widget.onUserTap,
                  gameComService: widget.gameComService,
                  gameState: gameState,
                  maxPlayers: widget.gameInfo.maxPlayers,
                  isLargerScreen: isLargerScreen,
                ),
              );
            },
          ),

          /* new center view */

          ValueListenableBuilder2(
            gameState.gameUIState.tableSizeVn,
            gameState.playerOnTablePositionVn,
            builder: (_, Size tableSize, Offset position, __) {
              if (tableSize == null || position == null) {
                return const SizedBox.shrink();
              }

              final rect =
                  _getCenterViewRect(size: tableSize, position: position);

              return Positioned(
                left: rect.item1.dx,
                top: rect.item1.dy,
                child: DebugBorderWidget(
                  color: Colors.lime,
                  child: SizedBox.fromSize(
                    size: rect.item2,
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
