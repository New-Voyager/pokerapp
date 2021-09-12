import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;

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

class ResultHandlerV2 {
  proto.HandResultClient result;
  BuildContext context;
  AudioPlayer audioPlayer;
  GameState gameState;
  bool hiLoGame;
  bool replay;

  TableState tableState;

  ResultHandlerV2({
    @required this.gameState,
    @required this.context,
    @required this.result,
    @required this.audioPlayer,
    this.hiLoGame = false,
    this.replay = false,
  });

  Future<void> show() async {
    tableState = gameState.tableState;
    for (final player in gameState.playersInGame) {
      player.winner = false;
      player.highlight = false;
      player.highlightCards = [];
    }

    // update pots
    tableState.updatePotChipsSilent(
      potChips: result.potWinners.map<int>((p) => p.amount.toInt()).toList(),
    );
    tableState.dimPotsSilent(true);
    tableState.notifyAll();

    // NOTE: we support only two boards at this time
    if (result.boards.length == 0) {
      log('We need at least one board');
      return;
    }

    if (result.boards.length > 2) {
      log('max number of boards: 2');
      return;
    }

    /* set board 1 cards */
    List<CardObject> boardCards1CO = [];
    for (final c in result.boards[0].cards) {
      boardCards1CO.add(CardHelper.getCard(c));
    }

    if (result.wonAt == proto.HandStatus.PREFLOP) {
      boardCards1CO = [];
    } else if (result.wonAt == proto.HandStatus.FLOP) {
      boardCards1CO = boardCards1CO.sublist(0, 3);
    } else if (result.wonAt == proto.HandStatus.TURN) {
      boardCards1CO = boardCards1CO.sublist(0, 4);
    }
    tableState.setBoardCards(1, boardCards1CO);

    /* set board 2 cards */
    if (result.boards.length == 2) {
      List<CardObject> boardCards2CO = [];
      for (final c in result.boards[1].cards) {
        boardCards2CO.add(CardHelper.getCard(c));
      }
      if (result.wonAt == proto.HandStatus.PREFLOP) {
        boardCards2CO = [];
      } else if (result.wonAt == proto.HandStatus.FLOP) {
        boardCards2CO = boardCards2CO.sublist(0, 3);
      } else if (result.wonAt == proto.HandStatus.TURN) {
        boardCards2CO = boardCards2CO.sublist(0, 4);
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
    // final boardCards = this.result.boards[0].cards;
    // List<CardObject> boardCardsUpdate = [];
    // for (final c in boardCards) {
    //   boardCardsUpdate.add(CardHelper.getCard(c));
    // }
    // tableState.setBoardCards(1, boardCardsUpdate);
    final totalPots = result.potWinners.length;
    for (int i = totalPots - 1; i >= 0; i--) {
      final potWinner = result.potWinners[i];
      for (final boardWinners in potWinner.boardWinners) {
        if (boardWinners.lowWinners.length > 0) {
          hiLoGame = true;
          break;
        }
      }
    }

    for (int i = totalPots - 1; i >= 0; i--) {
      final potWinner = result.potWinners[i];
      final potNo = potWinner.potNo;

      // highlight the req pot no
      tableState.updatePotToHighlightSilent(potNo);
      tableState.notifyAll();

      for (final boardWinners in potWinner.boardWinners) {
        // reset board, hi lo banners
        tableState.setWhichWinner(null);
        // clear all the boards
        for (final board in result.boards) {
          resetResult(
            boardIndex: board.boardNo,
          );
        }

        // seat no, Winner
        proto.Board board;
        for (final b in result.boards) {
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

        if (result.boards.length > 1) {
          // display board banner
          // highlight board
        }
        tableState.setWhichWinner(null);
        if (hiLoGame) {
          // display high banner
          tableState.setWhichWinner(AppConstants.HIGH_WINNERS);
        }
        String rankText = boardWinners.hiRankText;
        if (result.wonAt != proto.HandStatus.SHOW_DOWN) {
          rankText = '';
        }
        await _showWinners(
          board,
          rankText,
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

  void playApplause() {
    return;
    if (gameState?.settings?.gameSound ?? true) {
      gameState.getAudioBytes(AppAssets.applauseSound).then((value) {
        audioPlayer.playBytes(value);
      });
    }
  }

  Future<void> _showWinners(
      final proto.Board board, String rank, List<proto.Winner> winners,
      {bool low = false}) async {
    for (int i = 0; i < winners.length; i++) {
      final winner = winners[0];
      final playerRank = board.playerRank[winner.seatNo];
      List<int> winningCards = [];
      final playerInfo = result.playerInfo[winner.seatNo];
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
    await Future.delayed(Duration(milliseconds: result.pauseTimeSecs));
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
      player.highlightCards = [];
    }

    tableState.updateRankStrSilent(null);

    gameState.resetSeatActions(newHand: true);
    tableState.refreshTable();
      gameState.notifyAllSeats();
    // refresh community cards already calls notifyListeners
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
    seat.player.winner = true;

    // highlight winning cards and rank if we are in showdown
    if (result.wonAt == proto.HandStatus.SHOW_DOWN) {
      /* highlight the winning cards for players */
      seat.player.cards = winner.playerCards;
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
      gameState.notifyAllSeats();
      tableState.notifyAll();
      tableState.refreshCommunityCards();

      /* finally animate the moving stack */
      gameState.animateSeatActions();

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.chipMovingAnimationDuration);

      gameState.notifyAllSeats();
    }
  }
}
