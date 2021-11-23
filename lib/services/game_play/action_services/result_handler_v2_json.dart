import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';

class Winner {
  int seatNo;
  List<int> playerCards;
  List<int> boardCards;
  double amount;
  String rankStr;
  Winner(int seatNo, List<int> playerCards, List<int> boardCards,
      List<int> winningCards, double amount, String rank) {
    this.seatNo = seatNo;
    this.playerCards = [];
    this.boardCards = [];
    for (final card in winningCards) {
      int i = playerCards.indexOf(card);
      if (i != -1) {
        this.playerCards.add(card);
      } else {
        this.boardCards.add(card);
      }
    }
    this.amount = amount;
    this.rankStr = rankStr;
  }
}

class ResultHandlerV2Json {
  HandResultNew handResult;
  BuildContext context;
  AudioPlayer audioPlayer;
  GameState gameState;
  bool hiLoGame;
  bool replay;

  TableState tableState;

  ResultHandlerV2Json({
    @required this.gameState,
    @required this.context,
    @required this.handResult,
    @required this.audioPlayer,
    this.hiLoGame = false,
    this.replay = false,
  });

  Future<void> show() async {
    // log('Result: pauseTimeInMs: ${handResult.pauseTimeInMs}');

    if (gameState.mySeat != null) {
      gameState.showAction(false);
      gameState.myState.notify();
    }
    tableState = gameState.tableState;
    gameState.handState = HandState.RESULT;
    gameState.handChangeState.notify();

    // update pots
    tableState.updatePotChipsSilent(
      potChips: handResult.potWinners.map<double>((p) => p.amount).toList(),
    );
    tableState.dimPotsSilent(true);
    tableState.notifyAll();

    // NOTE: we support only two boards at this time
    if (handResult.boards.length == 0) {
      log('We need at least one board');
      return;
    }

    if (handResult.boards.length > 2) {
      log('max number of boards: 2');
      return;
    }

    /* set board 1 cards */
    List<CardObject> boardCards1CO = [];
    for (final c in handResult.boards[0].cards) {
      boardCards1CO.add(CardHelper.getCard(c));
    }
    tableState.setBoardCards(1, boardCards1CO);

    /* set board 2 cards */
    if (handResult.boards.length == 2) {
      List<CardObject> boardCards2CO = [];
      for (final c in handResult.boards[1].cards) {
        boardCards2CO.add(CardHelper.getCard(c));
      }
      tableState.setBoardCards(2, boardCards2CO);
      tableState.updateTwoBoardsNeeded(true);
    } else {
      tableState.updateTwoBoardsNeeded(false);
    }

    /* then, change the status of the footer to show the result */
    // context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.Result;

    /**
     * DO the following for each pot:
     *    1. show all the high pot winners
     *    2. delay
     *    3. show all the low pot winners
     */
    final boardCards = this.handResult.boards[0].cards;
    List<CardObject> boardCardsUpdate = [];
    for (final c in boardCards) {
      boardCardsUpdate.add(CardHelper.getCard(c));
    }
    tableState.setBoardCards(1, boardCardsUpdate);
    final totalPots = handResult.potWinners.length;
    for (int i = totalPots - 1; i >= 0; i--) {
      final potWinner = handResult.potWinners[i];
      for (final boardWinners in potWinner.boardWinners) {
        if (boardWinners.lowWinners.length > 0) {
          hiLoGame = true;
          break;
        }
      }
    }

    for (int i = totalPots - 1; i >= 0; i--) {
      final potWinner = handResult.potWinners[i];
      final potNo = potWinner.potNo;

      // highlight the req pot no
      tableState.updatePotToHighlightSilent(potNo);
      tableState.notifyAll();

      for (final boardWinners in potWinner.boardWinners) {
        // reset board, hi lo banners
        tableState.setWhichWinner(null);
        // clear all the boards
        for (final board in handResult.boards) {
          resetResult(
            boardIndex: board.boardNo,
          );
        }

        // seat no, Winner
        ResultBoard board;
        for (final b in handResult.boards) {
          if (b.boardNo == boardWinners.boardNo) {
            board = b;
            break;
          }
        }

        if (board.boardNo == 1) {
          tableState.dimBoard1 = false;
          tableState.dimBoard2 = true;
        } else {
          tableState.dimBoard1 = true;
          tableState.dimBoard2 = false;
        }

        if (handResult.boards.length > 1) {
          // display board banner
          // highlight board
        }
        tableState.setWhichWinner(null);
        if (hiLoGame) {
          // display high banner
          tableState.setWhichWinner(AppConstants.HIGH_WINNERS);
        }
        await _showWinners(
          board,
          boardWinners.hiRankText,
          boardWinners.hiWinners.values.toList(),
          low: false,
        );

        if (boardWinners.lowWinners.length > 0) {
          // display low banner
          if (hiLoGame) {
            // display high banner
            tableState.setWhichWinner(AppConstants.LOW_WINNERS);
          }
          await _showWinners(
            board,
            boardWinners.hiRankText,
            boardWinners.lowWinners.values.toList(),
            low: true,
          );
        }
      }

      // UN highlight the req pot no
      tableState.updatePotToHighlightSilent(-1);
      tableState.notifyAll();
      //break;
    }
    if (replay) return;
    resetResult();
    // remove all the community cards
    gameState.clear();
    tableState.clear();
    tableState.notifyAll();
  }

  Future<void> _showWinners(
    final ResultBoard board,
    String rank,
    List<ResultWinner> winners, {
    bool low = false,
  }) async {
    for (int i = 0; i < winners.length; i++) {
      final winner = winners[0];
      final playerRank = board.playerBoardRank[winner.seatNo];
      List<int> winningCards = [];
      final playerInfo = handResult.playerInfo[winner.seatNo];
      if (low) {
        winningCards = playerRank.loCards;
        rank = '';
      } else {
        winningCards = playerRank.hiCards;
      }
      Winner winningPlayer = Winner(winner.seatNo, playerInfo.cards,
          board.cards, winningCards, winner.amount, rank);
      bool setState = false;
      if (i == winners.length - 1) {
        setState = true;
      }
      this.showWinner(
        rank: rank,
        winner: winningPlayer,
        boardIndex: board.boardNo,
        setState: setState,
      );
    }

    await Future.delayed(Duration(milliseconds: handResult.pauseTimeInMs));
    audioPlayer?.stop();
  }

  /* only resets the highlights, and winners */
  void resetResult({
    int boardIndex = 1,
  }) {
    tableState.unHighlightCardsSilent(boardIndex);

    for (final player in gameState.playersInGame) {
      player.winner = false;
      player.highlight = false;
      player.action.reset();
      player.highlightCards = [];
    }

    tableState.updateRankStrSilent(null);

    gameState.resetSeatActions(newHand: true);

    gameState.notifyAllSeats();
    tableState.refreshTable();
    tableState.refreshCommunityCards();
  }

  Future<void> showWinner({
    final String rank,
    final Winner winner,
    final boardIndex = 1,
    final bool setState = false,
  }) async {
    /* highlight the hi winners */
    final seat = gameState.getSeat(winner.seatNo);
    seat.player.highlight = true;

    // highlight winning cards and rank if we are in showdown
    if (handResult.wonAt == AppConstants.SHOW_DOWN) {
      /* highlight the winning cards for players */
      seat.player.highlightCards = winner.playerCards;
      seat.player.winner = true;

      // log('WINNER player.cards: ${winner.playerCards} boardCards: ${winner.boardCards} setState: $setState ${winner.rankStr} ${AppConstants.chipMovingAnimationDuration}');
      /* highlight the winning cards for board 1 */
      tableState.highlightCardsSilent(
        boardIndex,
        winner.boardCards,
      );

      /* update the rank str */
      tableState.updateRankStrSilent(rank);
    }

    /* update the stack amount for the winners */
    seat.player.action.amount = winner.amount.toDouble();
    seat.player.action.winner = true;

    /** set state */
    if (setState) {
      /* update state */
      tableState.notifyAll();
      tableState.refreshCommunityCards();
      gameState.notifyAllSeats();

      /* finally animate the moving stack */
      gameState.animateSeatActions();

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.chipMovingAnimationDuration);
      gameState.notifyAllSeats();
    }
  }
}
