import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class BoardView extends StatelessWidget {
  final GameComService gameComService;
  final GameInfoModel gameInfo;
  final Function(int index) onUserTap;
  final Function() onStartGame;
  final AudioPlayer audioPlayer;

  BoardView({
    @required this.gameInfo,
    @required this.onUserTap,
    @required this.onStartGame,
    @required this.gameComService,
    @required this.audioPlayer,
  });

  final GlobalKey boardViewKey = GlobalKey();

  static Size dimensions(BuildContext context, bool isHorizontal) {
    var _widthMultiplier = 0.78;
    var _heightMultiplier = 2.0;

    double width = MediaQuery.of(context).size.width;
    double heightOfBoard = width * _widthMultiplier * _heightMultiplier;
    double widthOfBoard = width * _widthMultiplier;

    if (isHorizontal) {
      widthOfBoard = MediaQuery.of(context).size.width;
      heightOfBoard = MediaQuery.of(context).size.height / 2.5;
    }

    return Size(widthOfBoard, heightOfBoard);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    gameState.boardKey = boardViewKey;
    final boardAttributes = gameState.getBoardAttributes(context);
    final isBoardHorizontal =
        boardAttributes.orientation == BoardOrientation.horizontal;
    var dimensions = boardAttributes.dimensions(context);

    /* finally the view */
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // table view - board image
        Align(
          alignment: Alignment.center,
          child: TableView(width: dimensions.width, height: dimensions.height),
        ),

        /* players */
        Consumer<Players>(
          builder: (BuildContext _, Players players, Widget __) =>
              Transform.translate(
            offset: boardAttributes.playerOnTableOffset,
            child: PlayersOnTableView(
              players: players,
              gameComService: gameComService,
              isBoardHorizontal:
                  boardAttributes.orientation == BoardOrientation.horizontal,
              widthOfBoard: dimensions.width,
              heightOfBoard: dimensions.height,
              onUserTap: onUserTap,
              maxPlayers: gameInfo.maxPlayers,
              audioPlayer: audioPlayer,
              gameState: gameState,
            ),
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
                scale: 1 / boardAttributes.tableScale,
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

        // building buy in button
        Consumer<MyState>(
          builder: (BuildContext _, MyState myState, Widget __) => Align(
            alignment: Alignment.bottomCenter,
            child: buyInButton(context, theme),
          ),
        ),

        // building sit back button
        Consumer<MyState>(
          builder: (BuildContext _, MyState myState, Widget __) => Align(
            alignment: Alignment.bottomCenter,
            child: sitBackButton(context),
          ),
        ),

        // hand rank text
        !gameState.gameInfo.showHandRank
            ? const SizedBox.shrink()
            : Consumer<MyState>(
                builder: (BuildContext _, MyState myState, Widget __) =>
                    Transform.translate(
                  offset: Offset(0, 10.ph),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: rankText(context, theme),
                  ),
                ),
              ),
      ],
    );
  }

  Widget buyInButton(BuildContext context, AppTheme theme) {
    // show buyin button only for if the current player is in a seat
    final gameState = GameState.getState(context);
    final mySeat = gameState.mySeat(context);

    //log('Rebuild buyin button: Status: ${myState.status.toString()}');
    bool showBuyInButton = true;
    if (mySeat == null || mySeat.isOpen || mySeat.player == null) {
      //log('mySeat == null || mySeat.isOpen || mySeat.player == null');
      return SizedBox.shrink();
    }

    if (!(mySeat.player.showBuyIn || mySeat.player.waitForBuyInApproval)) {
      //log('!(mySeat.player.showBuyIn || mySeat.player.waitForBuyInApproval)');
      return SizedBox.shrink();
    }

    if (!showBuyInButton) {
      //log('!showBuyInButton');
      return SizedBox.shrink();
    }
    //log('Rebuilding buyin button');

    final widget = ListenableProvider<Seat>(
      create: (_) => mySeat,
      builder: (context, _) => Consumer<Seat>(builder: (_, seat, __) {
        if (seat.player != null &&
                seat.player.status == AppConstants.WAIT_FOR_BUYIN ||
            seat.player.status == AppConstants.WAIT_FOR_BUYIN_APPROVAL) {
          //log('Rebuilding buyin button now');
          return RoundRaisedButtonWithTimer(
            buttonText: AppStringsNew.BuyIn,
            color: theme.fillInColor,
            verticalPadding: 1,
            fontSize: 15,
            onButtonTap: () async => {await onBuyin(context)},
          );
        } else {
          //log('Cannot rebuild buyin button now ${seat.player.status}');
          return SizedBox.shrink();
        }
      }),
    );

    return widget;
  }

  Widget rankText(BuildContext context, AppTheme theme) {
    // show buyin button only for if the current player is in a seat
    final gameState = GameState.getState(context);
    final mySeat = gameState.mySeat(context);
    if (mySeat?.player != null) {
      //log('Rebuild sitBackButton button: Status: ${mySeat.player.status.toString()}');
    }

    if (mySeat == null || mySeat.isOpen || mySeat.player == null) {
      log('Rebuild (mySeat == null || mySeat.isOpen || mySeat.player == null');
      return SizedBox.shrink();
    }
    // log('Rebuild buyin button: Status: ${myState.status.toString()}');

    // if (mySeat.player.rankText != null && mySeat.player.rankText.isNotEmpty) {
    //   //log('mySeat.player.inBreak');
    //   final theme = AppTheme.getTheme(context);
    //   return Container(
    //     padding: EdgeInsets.symmetric(
    //       horizontal: 14.pw,
    //       vertical: 3.ph,
    //     ),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(6.pw),
    //       border: Border.all(color: theme.accentColorWithDark()),
    //       // border: Border.all(color: Colors.grey[700]),
    //       //color: Colors.green[700],
    //     ),
    //     child: Text(
    //       mySeat.player.rankText,
    //       style: AppDecorators.getHeadLine4Style(theme: theme),
    //     ),
    //   );
    // } else {
    //   return SizedBox.shrink();
    // }
  }

  Widget sitBackButton(BuildContext context) {
    // show buyin button only for if the current player is in a seat
    final gameState = GameState.getState(context);
    final mySeat = gameState.mySeat(context);
    if (mySeat?.player != null) {
      //log('Rebuild sitBackButton button: Status: ${mySeat.player.status.toString()}');
    }

    if (mySeat == null || mySeat.isOpen || mySeat.player == null) {
      log('Rebuild (mySeat == null || mySeat.isOpen || mySeat.player == null');
      return SizedBox.shrink();
    }
    // log('Rebuild buyin button: Status: ${myState.status.toString()}');

    if (!mySeat.player.inBreak) {
      //log('mySeat.player.inBreak');
      return SizedBox.shrink();
    }

    final widget = ListenableProvider<Seat>(
      create: (_) => mySeat,
      builder: (context, _) => Consumer<Seat>(builder: (_, seat, __) {
        if (!(seat.player.status == AppConstants.IN_BREAK ||
            seat.player.status == AppConstants.WAIT_FOR_BUYIN ||
            seat.player.status == AppConstants.WAIT_FOR_BUYIN_APPROVAL)) {
          //log('Rebuild sitBackButton seat.player.status == AppConstants.IN_BREAK');
          return SizedBox.shrink();
        }
        log('Rebuild sitBackButton show');
        return Transform.translate(
          offset: Offset(0, 10),
          child: RoundRaisedButtonWithTimer(
            buttonText: AppStringsNew.sitBackText,
            color: Colors.blueGrey,
            verticalPadding: 1,
            fontSize: 14,
            onButtonTap: () async => {await onSitBack(context)},
          ),
        );
      }),
    );

    return widget;
  }

  Future<void> onBuyin(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    gameState.buyInKeyboardShown = true;
    /* use numeric keyboard to get buyin */
    double value = await NumericKeyboard2.show(
      context,
      title: 'Buy In (${gameInfo.buyInMin} - ${gameInfo.buyInMax})',
      min: gameInfo.buyInMin.toDouble(),
      max: gameInfo.buyInMax.toDouble(),
    );
    gameState.buyInKeyboardShown = false;

    if (value == null) return;

    // buy chips
    await GameService.buyIn(
      gameInfo.gameCode,
      value.toInt(),
    );
  }

  Future<void> onSitBack(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    //sit back in the seat
    await GameService.sitBack(gameInfo.gameCode);
  }
}
