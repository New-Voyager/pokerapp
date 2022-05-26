import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/screens/layouts/delegates/poker_game_delegate.dart';
import 'package:pokerapp/screens/layouts/layout_holder.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';

/// THIS CLASS IS ACTUALLY BOARD VIEW - I CHOOSE THE NAME TABLE VIEW, BECAUSE TABLE MAKES MORE SENSE THAN BOARD IN A POKER GAME

class TableView extends StatefulWidget {
  const TableView({Key key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> with WidgetsBindingObserver {
  GameState gameState;
  PokerLayoutDelegate layoutDelegate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _calculateTableSizeAndPlayerOnTablePosition();
  }

  void _calculateTableSizeAndPlayerOnTablePosition() {
    gameState.gameUIState.calculateTableSizePostFrame(force: true);
    gameState.gameUIState.calculatePlayersOnTablePositionPostFrame();
  }

  @override
  Widget build(BuildContext context) {
    // gameState = GameStateX.getGameState(context);
    layoutDelegate = LayoutHolder.getGameDelegate(context);

    _calculateTableSizeAndPlayerOnTablePosition();
    return DebugBorderWidget(
      key: gameState.gameUIState.boardKey,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // table image
          layoutDelegate.tableImage(),

          // players on table
          ValueListenableBuilder(
            valueListenable: gameState.gameUIState.tableSizeVn,
            builder: (_, Size size, __) {
              if (size == null) return const SizedBox.shrink();
              Rect rect = gameState.gameUIState.getPlayersOnTableRect();

              return Positioned(
                top: rect.top,
                left: rect.left,
                child: DebugBorderWidget(
                  child: layoutDelegate.playersOnTableBuilder(size),
                ),
              );
            },
          ),

          // todo: center view - for showing pots, community cards, card shuffling, pot update & rank
        ],
      ),
    );
  }
}
