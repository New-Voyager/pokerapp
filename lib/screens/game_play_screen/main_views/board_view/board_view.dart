import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/numeric_keyboard.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';

class BoardView extends StatefulWidget {
  BoardView({
    @required this.gameInfo,
    @required this.onUserTap,
    @required this.onStartGame,
    @required this.gameComService,
  });
  final GameComService gameComService;
  final GameInfoModel gameInfo;
  final Function(int index) onUserTap;
  final Function() onStartGame;

  static Size dimensions(BuildContext context, bool isHorizontal) {
    var _widthMultiplier = 0.78;
    var _heightMultiplier = 2.0;
    double width = MediaQuery.of(context).size.width;
    double heightOfBoard = width * _widthMultiplier * _heightMultiplier;
    double widthOfBoard = width * _widthMultiplier;

    bool isBoardHorizontal = isHorizontal;

    if (isBoardHorizontal) {
      widthOfBoard = MediaQuery.of(context).size.width;
      heightOfBoard = MediaQuery.of(context).size.height / 2.5;
    }
    return Size(widthOfBoard, heightOfBoard);
  }

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  BuildContext providerContext;

  @override
  Widget build(BuildContext context) {
    providerContext = context;
    final gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);
    final isBoardHorizontal =
        boardAttributes.orientation == BoardOrientation.horizontal;
    var dimensions = boardAttributes.dimensions(context);

    final centerKey = GlobalKey();
    final emptyCenterKey = GlobalKey();
    boardAttributes.centerKey = centerKey;
    boardAttributes.emptyCenterKey = emptyCenterKey;
    boardAttributes.dummyKey = GlobalKey();

    /* finally the view */
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // game board view
        Align(
          alignment: Alignment.center,
          child: TableView(
            dimensions.height,
            dimensions.width,
          ),
        ),

        Positioned(
          top: boardAttributes.centerOffset.dy,
          width: boardAttributes.centerSize.width,
          height: boardAttributes.centerSize.height,
          child: Opacity(
            opacity: 1.0,
            child: Container(
              key: boardAttributes.dummyKey,
              width: boardAttributes.centerSize.width,
              height: boardAttributes.centerSize.height,
              color: Colors.transparent,
            ),
          ),
        ),

        Positioned(
          top: boardAttributes.centerOffset.dy,
          left: boardAttributes.centerOffset.dx,
          width: boardAttributes.centerSize.width,
          height: boardAttributes.centerSize.height,
          child: Consumer3<TableState, ValueNotifier<FooterStatus>,
              ServerConnectionState>(
            builder: (
              _,
              TableState tableState,
              ValueNotifier<FooterStatus> valueNotifierFooterStatus,
              ServerConnectionState connectionState,
              __,
            ) {
              final cards = tableState.cards;
              final cardsOther = tableState.cardsOther;
              final pots = tableState.potChips;
              final flipSpeed = tableState.flipSpeed;

              return Transform.scale(
                scale: boardAttributes.centerScale,
                child: CenterView(
                  centerKey,
                  tableState.twoBoardsNeeded,
                  widget.gameInfo.gameCode,
                  widget.gameInfo.isHost,
                  isBoardHorizontal,
                  cards,
                  cardsOther,
                  pots,
                  double.parse(
                    tableState.potChipsUpdates != null
                        ? tableState.potChipsUpdates.toString()
                        : '0.0',
                  ),
                  tableState.tableStatus,
                  valueNotifierFooterStatus.value == FooterStatus.Result,
                  widget.onStartGame,
                  flipSpeed,
                ),
              );
            },
          ),
        ),

        Consumer<Players>(
          builder: (
            BuildContext _,
            Players players,
            Widget __,
          ) =>
              Transform.translate(
            offset: boardAttributes.playerOnTableOffset,
            child: PlayersOnTableView(
              players: players,
              gameComService: widget.gameComService,
              isBoardHorizontal:
                  boardAttributes.orientation == BoardOrientation.horizontal,
              widthOfBoard: dimensions.width,
              heightOfBoard: dimensions.height,
              onUserTap: widget.onUserTap,
              maxPlayers: widget.gameInfo.maxPlayers,
            ),
          ),
        ),

        /* distributing card animation widgets */
        Align(
          alignment: Alignment.center,
          child: CardDistributionAnimatingWidget(),
        ),

        /* this widget is used to show animating of stacks in case user changes seats */
        Align(
          child: StackSwitchSeatAnimatingWidget(),
        ),

        Consumer<MyState>(
          builder: (
            BuildContext _,
            MyState myState,
            Widget __,
          ) =>
              Align(
            alignment: Alignment.bottomCenter,
            child: buyInButton(context),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: SizedBox(
            key: emptyCenterKey,
          ),
        ),
      ],
    );
  }

  Widget buyInButton(BuildContext context) {
    // show buyin button only for if the current player is in a seat
    final gameState = GameState.getState(providerContext);
    final mySeat = gameState.mySeat(providerContext);
    final myState = gameState.getMyState(context);

    bool showBuyInButton = true;
    if (mySeat == null || mySeat.isOpen || mySeat.player == null) {
      return SizedBox.shrink();
    }
    // log('Rebuild buyin button: Status: ${myState.status.toString()}');

    if (!mySeat.player.showBuyIn || mySeat.player.waitForBuyInApproval) {
      return SizedBox.shrink();
    }

    if (!showBuyInButton) {
      return SizedBox.shrink();
    }

    final widget = ListenableProvider<Seat>(
      create: (_) => mySeat,
      builder: (context, _) => Consumer<Seat>(
        builder: (_, seat, __) => Transform.translate(
            offset: Offset(0, 10),
            child: RoundRaisedButton(
              buttonText: 'Buyin',
              color: Colors.blueGrey,
              verticalPadding: 1,
              fontSize: 15,
              onButtonTap: () async => {await onBuyin(context)},
            )),
      ),
    );

    return widget;
  }

  // Future<void> onBuyinAlert(BuildContext context) async {
  //   dynamic ret = await showBuyinDialog(context, _buyInKey, 30, 100);
  // }

  Future<void> onBuyin(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;

    /* use numeric keyboard to get buyin */
    double value = await NumericKeyboard.show(
      context,
      title: 'Buy In (${gameInfo.buyInMin} - ${gameInfo.buyInMax})',
      min: gameInfo.buyInMin.toDouble(),
      max: gameInfo.buyInMax.toDouble(),
    );

    if (value == null) return;

    // buy chips
    await GameService.buyIn(
      gameInfo.gameCode,
      value.toInt(),
    );
  }
}
