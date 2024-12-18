import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/utils/alerts.dart';

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
    // log('Result: result show');
    // log('Result: pauseTimeSecs: ${result.pauseTimeSecs}');
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
        // log('Result: updating cards for seat: ${seat.player.seatNo} player: ${seat.player.name} cards: ${seat.player.cards}');
      }
    }
    gameState.wonat = result.wonAt;
    // log('Result: updating all seats');
    gameState.seatsOnTableState.notify();
    // log('Result: updating all seats notified');

    // update pots
    tableState.updatePotChipsSilent(
      potChips: result.potWinners.map<double>((p) => p.amount).toList(),
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
    List<int> boardCards1 = [];
    for (final c in result.boards[0].cards) {
      boardCards1.add(c);
    }
    bool showdown = false;
    if (result.wonAt == proto.HandStatus.SHOW_DOWN) {
      showdown = true;
    }
    if (result.wonAt == proto.HandStatus.PREFLOP) {
      boardCards1 = [];
    } else if (result.wonAt == proto.HandStatus.FLOP) {
      boardCards1 = boardCards1.sublist(0, 3);
    } else if (result.wonAt == proto.HandStatus.TURN) {
      boardCards1 = boardCards1.sublist(0, 4);
    }

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

      AudioService.playFireworks(mute: gameState.playerLocalConfig.mute);

      for (final winner in result.highHandWinners) {
        // show firework
        final seat = gameState.getSeat(winner.seatNo);
        final player = seat.player;
        player.showFirework = true;
        seat.notify();
      }
    }

    List<int> boardCards2;
    /* set board 2 cards */
    if (result.boards.length == 2) {
      boardCards2 = [];
      for (final c in result.boards[1].cards) {
        boardCards2.add(c);
      }
      if (result.wonAt == proto.HandStatus.PREFLOP) {
        boardCards2 = [];
      } else if (result.wonAt == proto.HandStatus.FLOP) {
        boardCards2 = boardCards2.sublist(0, 3);
      } else if (result.wonAt == proto.HandStatus.TURN) {
        boardCards2 = boardCards2.sublist(0, 4);
      }
    }

    gameState.communityCardState.addBoardCardsWithoutAnimating(
      board1: boardCards1,
      board2: boardCards2,
    );

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
    // log('Result: 1 show');

    for (int i = totalPots - 1; i >= 0; i--) {
      // log('Result: 1 show pot: $i');
      final potWinner = result.potWinners[i];
      final potNo = potWinner.potNo;

      // highlight the req pot no
      tableState.updatePotToHighlightSilent(potNo);
      tableState.notifyAll();

      for (final boardWinners in potWinner.boardWinners) {
        // log('Result: 1 show pot: $i boardWinners: ${boardWinners.boardNo} rank: ${boardWinners.hiRankText}');
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
        // log('Result: 2 show pot: $i boardWinners: ${boardWinners.boardNo} rank: ${boardWinners.hiRankText}');

        for (final seat in gameState.seats) {
          if (seat != null && seat.player != null) {
            final playerInfo = result.playerInfo[seat.player.seatNo];
            if (playerInfo != null) {
              seat.player.cards = playerInfo.cards;
            }
            // log('Result: UpdateSeat: show winnners updating cards for seat: ${seat.player.seatNo} player: ${seat.player.name} cards: ${seat.player.cards}');
          }
        }
        AudioService.playWinner(mute: gameState.playerLocalConfig.mute);
        //AudioService.playApplause(mute: gameState.playerLocalConfig.mute);
        // log('Result: 1 Show winners');
        bool oneWinner = false;
        if (boardWinners.hiWinners.values.toList().length == 1) {
          oneWinner = true;
        }
        if (boardWinners.lowWinners.values.toList().length > 1) {
          oneWinner = false;
        }
        if (!showdown && oneWinner) {
          final winners = boardWinners.hiWinners.values.toList();
          final winner = winners[0];
          // there is only one winner
          for (final w in boardWinners.lowWinners.values.toList()) {
            winner.amount += w.amount;
          }
          await _showWinners(
            board,
            rankText,
            winners,
            low: false,
          );
        } else {
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

            resetResult();

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
      }

      // UN highlight the req pot no
      tableState.updatePotToHighlightSilent(-1);
      tableState.notifyAll();
    }

    if (replay) return;

    // see whether this high hand
    if (result.highHandWinners.length > 0) {
      /* wait for 5 seconds, then remove the notification */
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
    await gameState.clear();
    tableState.clear();
    tableState.notifyAll();
    gameState.myState.notify();

    // update the players stack
    for (final player in result.playerInfo.values) {
      final playerInSeat = gameState.getPlayerById(player.id.toInt());
      if (playerInSeat != null) {
        playerInSeat.stack = player.balance.after;
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
    // log('Result: Show winners');
    for (int i = 0; i < winners.length; i++) {
      final winner = winners[i];
      final playerRank = board.playerRank[winner.seatNo];
      List<int> winningCards = [];
      final playerInfo = result.playerInfo[winner.seatNo];
      if (playerRank != null) {
        if (low) {
          winningCards = playerRank.loCards;
          rank = 'Low';
          log('HiLo: Low winners: players cards: ${winningCards}');
        } else {
          winningCards = playerRank.hiCards;
        }
      }
      Winner winningPlayer = Winner(winner.seatNo, playerInfo.cards,
          board.cards, winningCards, winner.amount, rank, low);
      bool setState = false;
      if (i == winners.length - 1) {
        // log('ShowWinners low: ${low}');
        setState = true;
      }

      this.showWinner(
        rank: rank,
        winner: winningPlayer,
        boardIndex: board.boardNo,
        setState: setState,
        low: low,
      );
    }
    log('Result: pause time: ${result.pauseTimeSecs}');
    await Future.delayed(Duration(milliseconds: result.pauseTimeSecs));
  }

  /* only resets the highlights, and winners */
  void resetResult({
    int boardIndex = 1,
  }) {
    for (final player in gameState.playersInGame) {
      player.winner = false;
      player.highlight = false;
      player.highlightCards = [];
      player.animatingFold = false;
      player.rankText = '';
      player.action.animateAction = false;
    }

    tableState.updateRankStrSilent(null);

    gameState.resetSeatActions(newHand: true);
    tableState.refreshTable();
    gameState.notifyAllSeats();
    gameState.communityCardState.resetHighlightCards();
  }

  Future<void> showWinner({
    final String rank,
    final Winner winner,
    final boardIndex = 1,
    final bool setState = false,
    final bool low = false,
  }) async {
    // for (final seat in gameState.seats) {
    //   log('ResultMessage 111: ${seat.serverSeatPos} name: ${seat.player.name} winner: ${seat.player.winner}');
    // }

    /* highlight the hi winners */
    final seat = gameState.getSeat(winner.seatNo);
    seat.player.winner = true;
    if (low) {
      seat.player.loWinner = low;
    }

    // highlight winning cards and rank if we are in showdown
    if (result.wonAt == proto.HandStatus.SHOW_DOWN) {
      /* highlight the winning cards for players */
      seat.player.highlightCards = winner.playerCards;

      gameState.communityCardState.markHighlightCards(winner.boardCards);

      /* update the rank str */
      tableState.updateRankStrSilent(rank);
    }

    /* update the stack amount for the winners */
    seat.player.action.amount = winner.amount.toDouble();
    seat.player.action.winner = true;
    seat.player.action.animateAction = true;

    /** set state */
    if (setState) {
      /* update state */
      gameState.notifyAllSeats();
      tableState.notifyAll();

      // we don't need this as we don't wanna do animation for all the seats
      /* finally animate the moving stack */
      // gameState.animateSeatActions();

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.chipMovingAnimationDuration);

      gameState.notifyAllSeats();
      for (final seat in gameState.seats) {
        if (seat == null || seat.player == null) {
          continue;
        }
        // log('ShowWinners show animation');
        // log('HiLo: Rebuild seat low: ${winner.low} player: ${seat.player.name} highlight cards: ${seat.player.highlightCards}');
        seat.notify();
      }
    }
  }
}
