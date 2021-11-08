import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:provider/provider.dart';

class Winner {
  int seatNo;
  List<int> playerCards;
  List<int> boardCards;
  double amount;
  String rankStr;
  bool low;
  Winner(int seatNo, List<int> playerCards, List<int> boardCards,
      List<int> winningCards, double amount, String rank, bool low) {
    this.seatNo = seatNo;
    this.playerCards = [];
    this.boardCards = [];
    this.low = low;
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
  GameState gameState;
  bool hiLoGame;
  bool replay;

  TableState tableState;

  ResultHandlerV2({
    @required this.gameState,
    @required this.context,
    @required this.result,
    this.hiLoGame = false,
    this.replay = false,
  });

  Future<void> show() async {
    log('Result: result show');
    log('Result: pauseTimeSecs: ${result.pauseTimeSecs}');
    tableState = gameState.tableState;
    for (final seat in gameState.seats) {
      if (seat != null && seat.player != null) {
        final playerInfo = result.playerInfo[seat.player.seatNo];
        if (playerInfo == null) {
          continue;
        }
        seat.player.winner = false;
        seat.player.highlight = false;
        seat.player.highlightCards = [];
        seat.player.cards = playerInfo.cards;
        log('Result: updating cards for seat: ${seat.player.seatNo} player: ${seat.player.name} cards: ${seat.player.cards}');
      }
    }
    gameState.wonat = result.wonAt;
    log('Result: updating all seats');
    gameState.seatsOnTableState.notify();
    log('Result: updating all seats notified');

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

    if (result.highHandWinners.length > 0) {
      final winner = result.highHandWinners[0];
      String playerName = winner.playerName;
      List<int> hhCards = winner.hhCards;

      List<int> playerCards = winner.playerCards;

      Alerts.showHighHandWinner(
        playerCards: playerCards,
        boardCards: result.boards.first.cards,
        highHandCards: hhCards,
        name: playerName,
        handNo: result.handNum,
      );

      // var notificationValueNotifier =
      //     context.read<ValueNotifier<HHNotificationModel>>();
      //
      // notificationValueNotifier.value = HHNotificationModel(
      //   gameCode: gameState.gameCode,
      //   handNum: result.handNum,
      //   playerName: playerName,
      //   hhCards: hhCards,
      //   playerCards: playerCards,
      //   boardCards: result.boards.first.cards,
      // );

      AudioService.playFireworks(mute: gameState.playerLocalConfig.mute);

      for (final winner in result.highHandWinners) {
        // show firework
        final seat = gameState.getSeat(winner.seatNo);
        final player = seat.player;
        player.showFirework = true;
        seat.notify();
      }
    }
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
    log('Result: result board: ${result.boards.length}');

    /**
     * DO the following for each pot:
     *    1. show all the high pot winners
     *    2. delay
     *    3. show all the low pot winners
     */
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

    gameState.handResultState.notify();
    log('Result: 1 show');

    for (int i = totalPots - 1; i >= 0; i--) {
      log('Result: 1 show pot: $i');
      final potWinner = result.potWinners[i];
      final potNo = potWinner.potNo;

      // highlight the req pot no
      tableState.updatePotToHighlightSilent(potNo);
      tableState.notifyAll();

      for (final boardWinners in potWinner.boardWinners) {
        log('Result: 1 show pot: $i boardWinners: ${boardWinners.boardNo} rank: ${boardWinners.hiRankText}');
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
        log('Result: 2 show pot: $i boardWinners: ${boardWinners.boardNo} rank: ${boardWinners.hiRankText}');

        for (final seat in gameState.seats) {
          if (seat != null && seat.player != null) {
            final playerInfo = result.playerInfo[seat.player.seatNo];
            if (playerInfo != null) {
              seat.player.cards = playerInfo.cards;
            }
            log('Result: UpdateSeat: show winnners updating cards for seat: ${seat.player.seatNo} player: ${seat.player.name} cards: ${seat.player.cards}');
          }
        }
        AudioService.playApplause(mute: gameState.playerLocalConfig.mute);
        log('Result: 1 Show winners');

        await _showWinners(
          board,
          rankText,
          boardWinners.hiWinners.values.toList(),
          low: false,
        );

        if (boardWinners.lowWinners.length > 0) {
          // clear all the boards
          for (final board in result.boards) {
            resetResult(
              boardIndex: board.boardNo,
            );
          }
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

    // see whether this high hand
    if (result.highHandWinners.length > 0) {
      /* wait for 5 seconds, then remove the notification */
      // await Future.delayed(AppConstants.notificationDuration);
      // var notificationValueNotifier =
      //     context.read<ValueNotifier<HHNotificationModel>>();
      //
      // notificationValueNotifier.value = null;
      // turn off firework
      for (final winner in result.highHandWinners) {
        final seat = gameState.getSeat(winner.seatNo);
        final player = seat.player;
        player.showFirework = false;
        seat.notify();
      }
    }

    resetResult();
    // remove all the community cards
    gameState.clear();
    tableState.clear();
    tableState.notifyAll();
    gameState.myState.notify();

    // update the players stack
    for (final player in result.playerInfo.values) {
      final playerInSeat = gameState.getPlayerById(player.id.toInt());
      if (playerInSeat != null) {
        playerInSeat.stack = player.balance.after.toInt();
        final seat = gameState.getSeat(playerInSeat.seatNo);
        if (seat != null) {
          seat.notify();
        }
      }
    }
  }

  Future<void> _showWinners(
      final proto.Board board, String rank, List<proto.Winner> winners,
      {bool low = false}) async {
    log('Result: Show winners');
    for (int i = 0; i < winners.length; i++) {
      final winner = winners[i];
      final playerRank = board.playerRank[winner.seatNo];
      List<int> winningCards = [];
      final playerInfo = result.playerInfo[winner.seatNo];
      if (low) {
        winningCards = playerRank.loCards;
        rank = 'Low';
        log('HiLo: Low winners: players cards: ${winningCards}');
      } else {
        winningCards = playerRank.hiCards;
      }
      Winner winningPlayer = Winner(winner.seatNo, playerInfo.cards,
          board.cards, winningCards, winner.amount, rank, low);
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
      player.animatingFold = false;
      player.rankText = '';
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
    // for (final seat in gameState.seats) {
    //   log('ResultMessage 111: ${seat.serverSeatPos} name: ${seat.player.name} winner: ${seat.player.winner}');
    // }

    /* highlight the hi winners */
    final seat = gameState.getSeat(winner.seatNo);
    seat.player.winner = true;

    // highlight winning cards and rank if we are in showdown
    if (result.wonAt == proto.HandStatus.SHOW_DOWN) {
      /* highlight the winning cards for players */
      seat.player.highlightCards = winner.playerCards;
      log('HiLo22: low: ${winner.low} highlight cards: ${seat.player.highlightCards} player cards: ${seat.player.cards}');

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
      log('HiLo: low: ${winner.low} player: ${seat.player.name} highlight cards: ${seat.player.highlightCards}');

      gameState.notifyAllSeats();
      for (final seat in gameState.seats) {
        if (seat == null || seat.player == null) {
          continue;
        }
        log('HiLo: Rebuild seat low: ${winner.low} player: ${seat.player.name} highlight cards: ${seat.player.highlightCards}');
        seat.notify();
      }
    }
  }
}
