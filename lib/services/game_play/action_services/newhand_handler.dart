import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/proto/enums.pb.dart' as proto;
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';

class NewHandHandler {
  proto.NewHand newHand;
  GameState gameState;
  Function(String) playSoundEffect;
  GameType gameType;

  NewHandHandler({
    @required this.newHand,
    @required this.gameState,
    @required this.playSoundEffect,
  });

  void resetBoard() {}

  void initialize() {
    gameState.resetSeatActions(newHand: true);
    gameState.resetDealerButton();
    gameType = GameType.values
        .firstWhere((element) => element.index == newHand.gameType.value);

    final handInfo = gameState.handInfo;
    handInfo.update(
      handNum: newHand.handNum,
      noCards: newHand.noCards,
      gameType: gameType,
      smallBlind: newHand.smallBlind,
      bigBlind: newHand.bigBlind,
      bombPot: newHand.bombPot,
      bombPotBet: newHand.bombPotBet,
      doubleBoard: newHand.doubleBoardBombPot,
    );
  }

  Future<void> updatePlayers() async {
    // only count active players in this hand
    int noOfPlayers = 0;
    for (final playerInSeat in newHand.playersInSeats.values) {
      if (playerInSeat.playerId != 0) {
        noOfPlayers++;
      }
    }

    if (gameState.playersInGame.length != noOfPlayers) {
      log('gameState seats does not match with new hand. * Refreshing *');
      await gameState.refresh();
      log('gameState seats does not match with new hand. * Refreshing Done *');
    }

    // update player's state and stack
    final playersInSeats = newHand.playersInSeats;
    log('NEW_HAND: Hand num: ${newHand.handNum} button: ${newHand.buttonPos} sbPos: ${newHand.sbPos} bbPos: ${newHand.bbPos} sb: ${newHand.smallBlind} bb: ${newHand.bigBlind} bombPot: ${newHand.bombPot}');
    for (final seatNo in playersInSeats.keys) {
      final playerInSeat = playersInSeats[seatNo];
      log('NEW_HAND: Player: ${playerInSeat.name} seatNo: $seatNo status: ${playerInSeat.status} missedBlind: ${playerInSeat.missedBlind} postedBlind: ${playerInSeat.postedBlind} inhand: ${playerInSeat.inhand} stack: ${playerInSeat.stack} breakTime: ${playerInSeat.breakExpTime}');
    }
    int retryCount = 0;
    while (retryCount < 2) {
      // show buyin button/timer if the player is in middle of buyin
      for (final seatNo in playersInSeats.keys) {
        if (seatNo == 0) {
          continue;
        }
        final playerInSeat = playersInSeats[seatNo];

        if (playerInSeat.playerId == 0) {
          // open seat
          final seat = gameState.getSeat(seatNo);
          seat.player = null;
          continue;
        }

        PlayerModel playerFound;
        bool newPlayer = true;
        for (final player in gameState.playersInGame) {
          if (player.playerId == playerInSeat.playerId.toInt()) {
            playerFound = player;
            break;
          }
        }
        PlayerModel playerObj;
        if (playerFound != null) {
          newPlayer = false;
          playerObj = playerFound;
        } else {
          playerObj = new PlayerModel();
        }
        playerObj.seatNo = seatNo;
        playerObj.stack = playerInSeat.stack.toInt();
        // if (newHand.bombPot) {
        //   playerObj.stack = playerObj.stack + newHand.bombPotBet.toInt();
        // }
        playerObj.status = playerInSeat.status.name;
        playerObj.inhand = playerInSeat.inhand;
        playerObj.missedBlind = playerInSeat.missedBlind;
        playerObj.postedBlind = playerInSeat.postedBlind;
        playerObj.muckLosingHand = playerInSeat.muckLosingHand;
        playerObj.buttonStraddle = playerInSeat.buttonStraddle;
        playerObj.autoStraddle = playerInSeat.autoStraddle;

        playerObj.muckLosingHand = true;

        if (playerInSeat.buyInExpTime != null &&
            playerInSeat.breakExpTime.length > 0 &&
            playerInSeat.stack == 0) {
          playerObj.showBuyIn = true;
          final buyInTimeExpAt = DateTime.tryParse(playerInSeat.buyInExpTime);
          playerObj.buyInTimeExpAt = buyInTimeExpAt.toLocal();
        }
        if (playerInSeat.status == proto.PlayerStatus.IN_BREAK &&
            playerInSeat.breakExpTime.length > 0) {
          playerObj.inBreak = true;
          final time = DateTime.tryParse(playerInSeat.breakExpTime);
          playerObj.breakTimeExpAt = time.toLocal();
        }

        if (newPlayer) {
          //playerObj.playerUuid = playerInSeat.playerId;
          gameState.newPlayer(playerObj);
        }
        if (playerObj.playerUuid == gameState.currentPlayerUuid) {
          playerObj.isMe = true;
        }
        final seat = gameState.getSeat(seatNo);
        seat.player = playerObj;
        // log('****** INHAND: NEWHAND seatNo: ${seatNo} seatNo: ${playerObj.seatNo} name: ${playerObj.name} inhand: ${playerObj.inhand}');
      }

      // make sure no two users in the same seat
      Map<int, int> seatNos = Map<int, int>();
      for (final player in gameState.playersInGame) {
        if (!seatNos.containsKey(player.seatNo)) {
          seatNos[player.seatNo] = 1;
        } else {
          seatNos[player.seatNo] = seatNos[player.seatNo] + 1;
        }
      }

      // more than one player in a seat. May be some seat change has happened
      // let us refresh the table
      bool refresh = false;
      for (final seatNo in seatNos.keys) {
        if (seatNos[seatNo] > 1) {
          log('gameState: ${gameState.gameCode}:${gameState.handInfo.handNum} more than one player is sitting in seat: $seatNo');
          refresh = true;
          break;
        }
      }

      if (refresh) {
        // the game state does not have all the players, refresh
        if (gameState.uiClosing) return;
        log('gameState seats does not match with new hand. * Refreshing *');
        await gameState.refresh();
        log('gameState seats does not match with new hand. * Refreshing Done *');
      } else {
        break;
      }
    }
  }

  Future<void> handle() async {
    gameState.handState = HandState.STARTED;
    gameState.handChangeState.notify();
    gameState.highHand = null;
    gameState.handInProgress = true;
    ////log('Hand Message: ::handleNewHand:: START');
    playSoundEffect(AppAssets.newHandSound);

    if (gameState.uiClosing) return;
    gameState.clear();

    if (gameState.uiClosing) return;
    await updatePlayers();
    // set small blind and big blind
    if (gameState.uiClosing) return;

    if (!newHand.bombPot) {
      final sbSeat = gameState.getSeat(newHand.sbPos);
      sbSeat.player.action.sb = true;
      sbSeat.player.action.amount = gameState.gameInfo.smallBlind.toDouble();

      if (gameState.uiClosing) return;
      final bbSeat = gameState.getSeat(newHand.bbPos);
      bbSeat.player.action.bb = true;
      bbSeat.player.action.amount = gameState.gameInfo.bigBlind.toDouble();
    }

    if (gameState.uiClosing) return;
    final TableState tableState = gameState.tableState;
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    if (gameState.uiClosing) return;

    // next action seat is me
    if (!newHand.bombPot) {
      final nextActionSeat = gameState.getSeat(newHand.nextActionSeat);
      if (nextActionSeat != null && nextActionSeat.isMe) {
        // if straddle is allowed, my stack size > straddle value, and I haven't turned off straddle option
        if (gameState.gameInfo.utgStraddleAllowed &&
            nextActionSeat.player.stack >= 2 * gameState.gameInfo.bigBlind) {
          // set straddlePrompt true
          if (gameState.settings.straddleOption) {
            // we show the straddle dialog only when the auto straddle is off
            if (gameState.settings.autoStraddle == true) {
              // set straddle bet
              gameState.straddleBetThisHand = true;
            } else {
              // prompt for the straddle dialog
              gameState.straddlePrompt = true;
            }
          }
        }
      }
    }

    // set player actions
    for (final seatNo in newHand.playersActed.keys) {
      final action = newHand.playersActed[seatNo];
      if (action.action != proto.ACTION.NOT_ACTED) {
        final seat = gameState.getSeat(seatNo);
        seat.player.action.setActionProto(action.action, action.amount);
      }
    }

    /* marking the dealer */
    // it could be a dead button
    if (gameState.uiClosing) return;
    final Seat seat = gameState.getSeat(newHand.buttonPos);
    seat.dealer = true;
    /* get a new card back asset to be shown */
    if (gameState.uiClosing) return;
    final myState = gameState.myState;
    if (gameState.me != null) {
      gameState.me.rankText = '';
    }
    gameState.handState = HandState.NEW_HAND;
    myState.notify();
    gameState.handInfo.notify();
    gameState.notifyAllSeats();
    tableState.notifyAll();
  }

  Future<void> showDeal() async {
    //log('Hand Message: ::handleDealStarted:: START');
    // final me = _gameState.me(_context);

    /* if I am present in this game,
     Deal Start message is unnecessary */
    // if (fromGameReplay == false && me == null) return;

    if (gameState.uiClosing) return;
    try {
      final TableState tableState = gameState.tableState;

      tableState.clear();
      tableState.notifyAll();

      if (gameState.uiClosing) return;

      // play the deal sound effect
      playSoundEffect(AppAssets.dealSound);

      /* show card shuffling*/
      tableState.updateCardShufflingAnimation(true);
      if (gameState.handInfo.bombPot) {
        await Future.delayed(AppConstants.bombPotTotalWaitDuration); // wait
      } else {
        await Future.delayed(
            AppConstants.cardShufflingTotalWaitDuration); // wait
      }
      tableState.updateCardShufflingAnimation(false);
      /* end card shuffling animation */

      if (gameState.uiClosing) return;

      List<int> seatNos = gameState.playersInGame.map((p) => p.seatNo).toList();
      seatNos.sort();

      if (gameState.uiClosing) return;

      final handInfo = gameState.handInfo;

      if (gameState.uiClosing) return;

      /* distribute cards to the players */
      /* this for loop will distribute cards one by one to all the players */
      //for (int i = 0; i < handInfo.noCards; i++) {
      /* for distributing the ith card, go through all the players, and give them */
      for (int seatNo in seatNos) {
        if (gameState.uiClosing) return;
        final seat = gameState.getSeat(seatNo);
        if (seat.player == null || !seat.player.inhand) {
          continue;
        }

        // start the animation
        gameState.cardDistributionState.seatNo = seatNo;
        if (gameState.uiClosing) return;

        // wait for the animation to finish
        await Future.delayed(AppConstants.cardDistributionAnimationDuration);
        if (gameState.uiClosing) return;
        seat.player.noOfCardsVisible = handInfo.noCards;
        seat.notify();
      }
      //}

      /* card distribution ends, put the value to NULL */
      gameState.cardDistributionState.seatNo = null;
      if (gameState.uiClosing) return;
      gameState.notifyAllSeats();
    } finally {
      //log('Hand Message: ::handleDealStarted:: END');
    }
  }
}
