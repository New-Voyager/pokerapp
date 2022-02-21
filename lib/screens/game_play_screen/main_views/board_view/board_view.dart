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
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';

import 'decorative_views/background_view.dart';

class BoardView extends StatelessWidget {
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

  final GlobalKey boardViewKey = GlobalKey();

  Size _getCenterViewSize({@required Size tableSize}) {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final ts = SizingUtils.getPlayersOnTableSize(tableSize);

    final height = ts.height - namePlateSize.height * 2;
    final width = ts.width - namePlateSize.width * 2;

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    // AppTextScreen _appScreenText = getAppTextScreen("boardView");

    // final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    gameState.boardKey = boardViewKey;
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
    gameState.calculateTableSizePostFrame();

    return DebugBorderWidget(
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

          /* new center view */
          ValueListenableBuilder(
            valueListenable: gameState.tableSizeVn,
            builder: (_, tableSize, __) {
              if (tableSize == null) return const SizedBox.shrink();

              return DebugBorderWidget(
                color: Colors.lime,
                child: SizedBox.fromSize(
                  size: _getCenterViewSize(tableSize: tableSize),
                  child: CenterView(
                    tableState: context.read<TableState>(),
                    gameCode: gameInfo.gameCode,
                    isHost: gameInfo.isHost,
                    isBoardHorizontal: isBoardHorizontal,
                    onStartGame: onStartGame,
                  ),
                ),
              );
            },
          ),

          // new players view
          ValueListenableBuilder(
            valueListenable: gameState.tableSizeVn,
            builder: (_, size, __) {
              if (size == null) return const SizedBox.shrink();
              return DebugBorderWidget(
                color: Colors.amber,
                child: PlayersOnTableViewNew(
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
