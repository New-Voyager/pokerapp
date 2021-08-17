import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;

class ResultHandler {
  bool isRunItTwice;
  proto.RunItTwiceResult runItTwiceResult;
  Map<int, proto.PotWinners> potWinners;
  List<int> boardCards;
  List<int> boardCards2;
  BuildContext context;
  AudioPlayer audioPlayer;
  GameState gameState;
  bool replay;

  TableState tableState;
  Players players;

  ResultHandler({
    @required this.gameState,
    @required this.context,
    @required this.boardCards,
    @required this.audioPlayer,
    this.boardCards2,
    this.isRunItTwice,
    this.runItTwiceResult,
    this.potWinners,
    this.replay = false,
  });

  Future<void> show() async {
    tableState = gameState.getTableState(context);
    players = gameState.getPlayers(context);

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    if (isRunItTwice) {
      await showRunItTwiceBoards();
    } else {
      /* SIMPLE POT WINNER CASE */

      /**
       * DO the following for each pot:
       *    1. show all the high pot winners
       *    2. delay
       *    3. show all the low pot winners
       */
      List<CardObject> boardCardsUpdate = [];
      for (final c in boardCards) {
        boardCardsUpdate.add(CardHelper.getCard(c));
      }
      tableState.setBoardCards(1, boardCardsUpdate);

      // time we get for each pot is 3 seconds

      for (final potWinner in potWinners.entries) {
        final potNo = int.parse(potWinner.key.toString());

        // highlight the req pot no
        tableState.updatePotToHighlightSilent(potNo);
        tableState.notifyAll();

        final winners = potWinner.value;

        final highWinners = winners.hiWinners;
        final lowWinners = winners.lowWinners;

        /* this method should complete in timePerPotInMs time */
        await processHiLoWinners(
          highWinners: highWinners,
          lowWinners: lowWinners,
        );

        // UN highlight the req pot no
        tableState.updatePotToHighlightSilent(-1);
        tableState.notifyAll();

        if (replay) return;
      }
    }

    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    gameState.resetPlayers(context);
  }

  Future<void> processHiLoWinners({
    final List<proto.HandWinner> highWinners,
    final List<proto.HandWinner> lowWinners,
    final int boardIndex = 1,
    final bool resetState = false,
  }) async {
    /* we have 3000 / 6000 (incase we have both hi and low winners) ms to complete this entire pot */
    int totalWaitTimeInMs = lowWinners.isNotEmpty ? 6000 : 3000;

    // if we dont have lowWinners to process, spend entire time for highWinners
    int highWinnersTimeInMs =
        lowWinners.isEmpty ? totalWaitTimeInMs : totalWaitTimeInMs ~/ 2;
    int lowWinnersTimeInMs = totalWaitTimeInMs ~/ 2;

    if (gameState?.settings?.gameSound ?? true) {
      gameState.getAudioBytes(AppAssets.applauseSound).then((value) {
        audioPlayer.playBytes(value);
      });
    }

    /** process the high pot winners: this method already takes 500ms*/
    log('paul debug: HIGH pot winners starting');
    if (gameState != null) {
      final currentGameType = gameState.currentHandGameType;
      if (currentGameType == GameType.PLO_HILO ||
          currentGameType == GameType.FIVE_CARD_PLO_HILO) {
        tableState.setWhichWinner(AppConstants.HIGH_WINNERS);
      }
    }
    //tableState.setWhichWinner(AppConstants.HIGH_WINNERS);

    await processWinners(
      highWinners: highWinners,
      boardIndex: boardIndex,
    );

    /** wait for the extra duration */
    int balancedMstoWait =
        highWinnersTimeInMs - AppConstants.animationDuration.inMilliseconds;

    log('paul debug: waiting for: $balancedMstoWait');

    await Future.delayed(Duration(milliseconds: balancedMstoWait));
    audioPlayer.stop();
    log('Result: Animation done');

    /* if we dont have any low winners to show AND we are from
    replay hand, we end the function call here */
    if (lowWinners.isEmpty && replay) return;

    /* need to clear the board */
    resetResult(
      boardIndex: boardIndex,
    );

    if (lowWinners.isEmpty) return;

    // this method takes another 500 MS
    /** process the low pot winners */
    log('paul debug: low pot winners starting: $lowWinners');
    if (gameState != null) {
      final currentGameType = gameState.currentHandGameType;
      if (currentGameType == GameType.PLO_HILO ||
          currentGameType == GameType.FIVE_CARD_PLO_HILO) {
        tableState.setWhichWinner(AppConstants.LOW_WINNERS);
      }
    }
    await processWinners(
      highWinners: lowWinners,
      boardIndex: boardIndex,
    );

    /** wait for the extra duration */
    balancedMstoWait =
        lowWinnersTimeInMs - AppConstants.animationDuration.inMilliseconds;
    await Future.delayed(Duration(milliseconds: balancedMstoWait));
    audioPlayer.stop();

    /* if we are from replay, we dont need to clear the result state */
    if (replay || resetState == false) return;

    /* need to clear the board */
    resetResult(
      boardIndex: boardIndex,
    );
  }

  /* only resets the highlights, and winners */
  void resetResult({
    int boardIndex = 1,
  }) {
    tableState.unHighlightCardsSilent(boardIndex);
    players.removeAllHighlightsSilent();
    players.removeWinnerHighlightSilent();
    players.unHighlightCardsSilentForAll();

    tableState.updateRankStrSilent(null);

    gameState.resetSeatActions(newHand: true);

    players.notifyAll();
    tableState.refreshTable();
    tableState.notifyAll();
    tableState.refreshCommunityCards();
  }

  /* this method processes multiple winners */
  /* THIS METHOD TAKES ONLY 500 MS (the pot moving animation time) */
  Future<void> processWinners({
    List<proto.HandWinner> highWinners,
    final boardIndex = 1,
  }) async {
    /** process the high pot winners */
    for (int i = 0; i < highWinners.length; i++) {
      final HiWinnersModel winner = HiWinnersModel.fromProto(highWinners[i]);

      await processWinner(
        winner: winner,
        boardIndex: boardIndex,
        // for the last element only we set the state
        setState: i == highWinners.length - 1,
      );
    }
  }

  Future<void> processWinner({
    final HiWinnersModel winner,
    final boardIndex = 1,
    final bool setState = false,
  }) async {
    /* highlight the hi winners */
    players.highlightWinnerSilent(winner.seatNo);

    /* highlight the winning cards for players */
    players.highlightCardsSilent(
      seatNo: winner.seatNo,
      cards: winner.playerCards,
    );

    log('WINNER player.cards: ${winner.playerCards} boardCards: ${winner.boardCards} setState: $setState ${winner.rankStr} ${AppConstants.chipMovingAnimationDuration}');
    /* highlight the winning cards for board 1 */
    tableState.highlightCardsSilent(
      boardIndex,
      winner.boardCards,
    );

    /* update the rank str */
    tableState.updateRankStrSilent(winner.rankStr);

    /* update the stack amount for the winners */
    final PlayerModel player = players.getPlayerBySeat(winner.seatNo);
    if (player != null) {
      player.action.amount = winner.amount.toDouble();
      player.action.winner = true;
    }

    /** set state */
    if (setState) {
      /* update state */
      players.notifyAll();
      tableState.notifyAll();
      tableState.refreshCommunityCards();

      /* finally animate the moving stack */
      gameState.animateSeatActions();

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.chipMovingAnimationDuration);

      /* update the actual stack */
      players.addStackWithValueSilent(
        winner.seatNo,
        winner.amount,
      );

      players.notifyAll();
    }
  }

  Future<void> showRunItTwiceBoards() async {
    /* RUN IT TWICE CASE */

    /* set the board cards first */

    /* set board 1 cards */
    List<CardObject> boardCards1CO = [];
    for (final c in boardCards) {
      boardCards1CO.add(CardHelper.getCard(c));
    }
    tableState.setBoardCards(1, boardCards1CO);

    /* set board 2 cards */
    List<CardObject> boardCards2CO = [];
    for (final c in boardCards2) {
      boardCards2CO.add(CardHelper.getCard(c));
    }
    tableState.setBoardCards(2, boardCards2CO);

    final board1PotWinners = runItTwiceResult.board1Winners;

    final board2PotWinners = runItTwiceResult.board2Winners;

    log('board 1 winners: $board1PotWinners');
    log('board 2 winners: $board2PotWinners');

    /* process board 1 first
      * 0. get all hi winner players for board 1
      * 1. highlight hi winner
      * 2. highlight winning cards - players and community one's
      * 3. update the rankStr
      * 4. move the pot chip to the winner */

    // this loop should take 3000 ms per POT winners
    for (final board1Winners in board1PotWinners.entries) {
      log('completed: board1 winners');
      final potNo = int.parse(board1Winners.key.toString());

      // highlight the req pot no
      tableState.updatePotToHighlightSilent(potNo);
      tableState.notifyAll();

      final winners = board1Winners.value;

      final highWinners = winners.hiWinners;
      final lowWinners = winners.lowWinners;

      await processHiLoWinners(
        highWinners: highWinners,
        lowWinners: lowWinners,
        resetState: true,
      );

      // UN highlight the req pot no
      tableState.updatePotToHighlightSilent(-1);
      tableState.notifyAll();
    }

    // /* if we dont have any board 2 winners to show, we pause here */
    // if (board2PotWinners.isEmpty && fromReplay) return;

    /* cleanup all highlights and rankStr */
    resetResult(
      boardIndex: 1,
    );

    // refresh after un highlighting
    tableState.refreshCommunityCards();

    /* then, process board 2
      * 0. get all hi winner players for board 1
      * 1. highlight hi winner
      * 2. highlight winning cards - players and community one's
      * 3. update the rankStr
      * 4. move the pot chip to the winner */

    // this loop should take 3000 ms per POT winners
    for (final board2Winners in board2PotWinners.entries) {
      final potNo = int.parse(board2Winners.key.toString());

      // highlight the req pot no
      tableState.updatePotToHighlightSilent(potNo);
      tableState.notifyAll();

      final winners = board2Winners.value;

      final highWinners = winners.hiWinners;
      final lowWinners = winners.lowWinners;

      await processHiLoWinners(
        highWinners: highWinners,
        lowWinners: lowWinners,
        boardIndex: 2,
      );

      // UN highlight the req pot no
      tableState.updatePotToHighlightSilent(-1);
      tableState.notifyAll();
    }

    /* turn off two boards needed flag -> only if we are not from replay */
    if (!replay) tableState.updateTwoBoardsNeeded(false);
  }
}
