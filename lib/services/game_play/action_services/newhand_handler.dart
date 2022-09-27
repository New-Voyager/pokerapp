import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/proto/enums.pb.dart' as proto;
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/utils/platform.dart';

class NewHandHandler {
  proto.NewHand newHand;
  GameState gameState;
  GameContextObject gameContext;
  GameType gameType;

  NewHandHandler({
    @required this.newHand,
    @required this.gameState,
    @required this.gameContext,
  });

  void resetBoard() {}

  void initialize() {
    gameState.resetSeats();
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
      doubleBoard: newHand.doubleBoard,
    );
  }

  Future<void> leaveAudioConference() async {
    if (!gameState.gameInfo.audioConfEnabled) {
      return;
    }
    log('AudioConf: Leaving audio conference');
    if (didILeaveTheGame()) {
      // leave the conference
      try {
        this.gameContext?.leaveAudio();
      } catch (err) {}
    }
  }

  bool didILeaveTheGame() {
    bool didILeave = false;
    bool inGame = false;
    int myId = 0;
    // was in the previous hand
    for (final player in gameState.playersInGame) {
      if (player.isMe) {
        inGame = true;
        myId = player.playerId;
        break;
      }
    }
    if (!inGame) {
      return didILeave;
    }
    didILeave = true;
    for (final playerInSeat in newHand.playersInSeats.values) {
      if (playerInSeat.playerId != 0 && playerInSeat.playerId.toInt() == myId) {
        didILeave = false;
      }
    }
    return didILeave;
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
    // log('NEW_HAND: Hand num: ${newHand.handNum} button: ${newHand.buttonPos} sbPos: ${newHand.sbPos} bbPos: ${newHand.bbPos} sb: ${newHand.smallBlind} bb: ${newHand.bigBlind} bombPot: ${newHand.bombPot}');
    // for (final seatNo in playersInSeats.keys) {
    //   final playerInSeat = playersInSeats[seatNo];
    // }
    int retryCount = 0;
    bool newPlayerInTable = false;
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
          if (seat == null) {
            continue;
          }
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
        playerObj.stack = playerInSeat.stack;
        playerObj.status = playerInSeat.status.name;
        playerObj.inhand = playerInSeat.inhand;
        playerObj.missedBlind = playerInSeat.missedBlind;
        playerObj.postedBlind = playerInSeat.postedBlind;
        playerObj.muckLosingHand = playerInSeat.muckLosingHand;
        playerObj.buttonStraddle = playerInSeat.buttonStraddle;
        playerObj.autoStraddle = playerInSeat.autoStraddle;
        playerObj.playerFolded = false;
        playerObj.revealCards = [];

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
          newPlayerInTable = true;
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
    log('NEWHAND: ${newHand.writeToJson()}');
    gameState.handState = HandState.STARTED;
    gameState.handChangeState.notify();
    gameState.highHand = null;
    gameState.handInProgress = true;
    gameState.actionState.reset();
    gameState.actionState.notify();
    gameState.tableState.updateDealerChoicePrompt(false, '');
    gameState.communityCardState.reset();
    ////log('Hand Message: ::handleNewHand:: START');
    //AudioService.playNewHand(mute: gameState.playerLocalConfig.mute);
    if (gameState.uiClosing) return;

    gameState.clear();
    if (gameState.uiClosing) return;
    await leaveAudioConference();

    if (gameState.uiClosing) return;
    await updatePlayers();
    // set small blind and big blind
    if (gameState.uiClosing) return;
    final TableState tableState = gameState.tableState;
    gameState.resetSeatActions(newHand: true);
    gameState.communityCardState.reset();
    if (gameState.isTournament) {
      gameState.tournamentLevelState.current.sb = newHand.smallBlind;
      gameState.tournamentLevelState.current.bb = newHand.bigBlind;
      gameState.tournamentLevelState.current.ante = newHand.ante;
      gameState.tournamentLevelState.notify();
    }

    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();
    if (gameState.uiClosing) return;

    /* marking the dealer */
    // it could be a dead button
    final Seat seat = gameState.getSeat(newHand.buttonPos);
    seat.dealer = true;

    if (gameState.uiClosing) return;

    await showDeal();
    if (gameState.uiClosing) return;

    tableState.updatePotChipsSilent(
        potChips: [], potUpdatesChips: newHand.potUpdates);

    if (newHand.ante != null && newHand.ante > 0.0) {
      double pot = 0;
      // show ante animation
      for (final seatNo in newHand.playersInSeats.keys) {
        final seat = gameState.getSeat(seatNo);
        if (seat != null && seat.player != null) {
          seat.player.resetSeatAction();
        }
        if (newHand.playersInSeats[seatNo].inhand) {
          seat.player.action.setAnte(newHand.ante);
          pot += newHand.ante;
          seat.player.action.animateAction = false;
          seat.player.action.animateBet = true;
          seat.player.action.anteBet = true;
          seat.player.inhand = true;
        }
      }
      for (final seatNo in newHand.playersInSeats.keys) {
        if (newHand.playersInSeats[seatNo].inhand) {
          final seat = gameState.getSeat(seatNo);
          seat.notify();
        }
      }
      // play the bet sound effect
      AudioService.playBet(mute: gameState.playerLocalConfig.mute);

      await Future.delayed(Duration(milliseconds: 300));
      for (final seatNo in newHand.playersInSeats.keys) {
        if (newHand.playersInSeats[seatNo].inhand) {
          final seat = gameState.getSeat(seatNo);
          seat.player.action.animateAction = false;
          seat.player.action.animateBet = false;
          seat.player.action.anteBet = true;
          seat.notify();
        }
      }
      await Future.delayed(Duration(milliseconds: 300));
      log('ChipAnimation: Showing ante animation');
      for (final seatNo in newHand.playersInSeats.keys) {
        final seat = gameState.getSeat(seatNo);
        if (newHand.playersInSeats[seatNo].inhand) {
          seat.player.action.anteBet = false;
          seat.player.action.animateBet = false;
          seat.player.action.animateAction = true;
          seat.notify();
        }
      }
      await Future.delayed(Duration(milliseconds: 300));
      log('ChipAnimation: Showing ante animation done');

      // for (final seatNo in newHand.playersInSeats.keys) {
      //   if (newHand.playersInSeats[seatNo].inhand) {
      //     final seat = gameState.getSeat(seatNo);
      //     seat.notify();
      //   }
      // }

      //await Future.delayed(Duration(milliseconds: 300));
      tableState.notifyAll();

      if (gameState.uiClosing) return;
    }

    if (!newHand.bombPot) {
      final sbSeat = gameState.getSeat(newHand.sbPos);
      if (sbSeat.player.inhand) {
        sbSeat.player.action.sb = true;
        sbSeat.player.action.amount = gameState.gameInfo.smallBlind.toDouble();
        if (!PlatformUtils.isWeb) {
          sbSeat.player.action.animateAction = false;
          sbSeat.player.action.animateBet = true;
          sbSeat.notify();
        }
      }

      if (gameState.uiClosing) return;

      // play the bet sound effect
      AudioService.playBet(mute: gameState.playerLocalConfig.mute);
      final bbSeat = gameState.getSeat(newHand.bbPos);
      bbSeat.player.action.bb = true;
      bbSeat.player.action.amount = gameState.gameInfo.bigBlind.toDouble();
      if (!PlatformUtils.isWeb) {
        bbSeat.player.action.animateAction = false;
        bbSeat.player.action.animateBet = true;
        bbSeat.notify();
        await Future.delayed(Duration(milliseconds: 250));
      }
      bbSeat.player.action.animateAction = false;
      bbSeat.player.action.animateBet = false;
      if (sbSeat.player.inhand) {
        sbSeat.player.action.animateAction = false;
        sbSeat.player.action.animateBet = false;
      }
      sbSeat.notify();
      bbSeat.notify();
    }

    if (gameState.uiClosing) return;

    // next action seat is me
    if (!newHand.bombPot) {
      final nextActionSeat = gameState.getSeat(newHand.nextActionSeat);
      if (nextActionSeat != null && nextActionSeat.isMe) {
        // if straddle is allowed, my stack size > straddle value, and I haven't turned off straddle option
        if (gameState.gameInfo.utgStraddleAllowed &&
            nextActionSeat.player.stack >= 2 * gameState.gameInfo.bigBlind) {
          // set straddlePrompt true
          if (gameState.playerLocalConfig.straddle) {
            // we show the straddle dialog only when the auto straddle is off
            if (gameState.playerSettings.autoStraddle == true) {
              // set straddle bet
              gameState.straddleBetThisHand = true;
            } else {
              // prompt for the straddle dialog
              gameState.straddlePrompt = true;

              OverlayStraddle.showPrompt(
                gameContextObject: gameContext,
                gameState: gameState,
                expiresAtInSeconds: gameState.gameInfo.actionTime,
                context: gameState.mainScreenContext,
              );
            }
          }
        }
      }
    }

    // set player actions
    for (final seatNo in newHand.playersActed.keys) {
      final seat = gameState.getSeat(seatNo);
      if (seat != null && seat.player != null) {
        seat.player.resetSeatAction();
      }

      final action = newHand.playersActed[seatNo];
      if (action.action != proto.ACTION.NOT_ACTED) {
        final seat = gameState.getSeat(seatNo);
        seat.player.action.setActionProto(action.action, action.amount);
      }
    }

    /* get a new card back asset to be shown */
    if (gameState.uiClosing) return;
    final myState = gameState.myState;
    if (gameState.me != null) {
      gameState.me.rankText = '';
    }
    gameState.handState = HandState.NEW_HAND;
    myState.notify();
    gameState.handInfo.notify();

    if (gameState.playersWithNotes == null) {
      gameState.refreshNotes().then((value) {
        if (!gameState.uiClosing) {
          gameState.notifyAllSeats();
        }
      });
    } else {
      gameState.updatePlayersWithNotes();
    }
    gameState.notifyAllSeats();
    tableState.notifyAll();

    if (gameState.handInfo.handNum == 1) {
      gameState.myState.notify();
      gameState.redrawFooter();
    }
  }

  Future<void> showDeal() async {
    if (gameState.uiClosing) return;
    try {
      final TableState tableState = gameState.tableState;

      tableState.clear();
      tableState.notifyAll();

      if (gameState.uiClosing) return;

      // play the deal sound effect
      // AudioService.playDeal(mute: gameState.playerLocalConfig.mute);

      /* show card shuffling*/
      if (gameState.handInfo.bombPot) {
        // tableState.updateCardShufflingAnimation(true);
        // await Future.delayed(AppConstants.bombPotTotalWaitDuration); // wait
      } else {
        // await Future.delayed(
        //   AppConstants.cardShufflingTotalWaitDuration,
        // ); // wait
      }

      await HandActionProtoService.cardDistribution(
        gameState,
        gameState.handInfo.noCards,
      );
      // stop showing shuffle cards, after animation is done
      tableState.updateCardShufflingAnimation(false);
      // AudioService.stopSound();
    } catch (e) {}
  }
}
