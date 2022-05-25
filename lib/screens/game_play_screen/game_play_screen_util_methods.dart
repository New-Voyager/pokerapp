import 'dart:developer';
import 'dart:developer' as developer;

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_hive_store.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../services/test/test_service.dart';

class GamePlayScreenUtilMethods {
  GamePlayScreenUtilMethods._();

  static double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  /* THIS SPEED DIAL IS JUST FOR SHOWING THE TEST BUTTONS */
  static SpeedDial floatingActionButton({
    Function onReload,
    bool isCustomizationMode,
  }) {
    return SpeedDial(
      onOpen: onReload,
      overlayColor: Colors.black,
      visible: TestService.isTesting && !isCustomizationMode,
      overlayOpacity: 0.1,
      icon: Icons.all_inclusive_rounded,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Distribute Cards',
          labelBackgroundColor: Colors.black,
          onTap: () {
            TestService.showCardDistribution();
          },
        ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Flop Cards',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () {
        //     TestService.addFlopCards();
        //   },
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Add Turn',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () {
        //     TestService.addTurnCard();
        //   },
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Add River',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () {
        //     TestService.addRiverCard();
        //   },
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Run It Twice, after Flop',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () {
        //     TestService.addRunItTwiceAfterFlop();
        //   },
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Run It Twice, after Turn',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () {
        //     TestService.addRunItTwiceAfterTurn();
        //   },
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Adds cards',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () {
        //     TestService.addCardsWithoutAnimating();
        //   },
        // ),
        // SpeedDialChild(
        //     child: Icon(
        //       Icons.adb_rounded,
        //       color: Colors.white,
        //     ),
        //     backgroundColor: Colors.red,
        //     label: 'Add Turn/River cards',
        //     labelBackgroundColor: Colors.black,
        //     onTap: () {
        //       TestService.addTurnOrRiverCard();
        //     }),
        // SpeedDialChild(
        //     child: Icon(
        //       Icons.adb_rounded,
        //       color: Colors.white,
        //     ),
        //     backgroundColor: Colors.red,
        //     label: 'Show bets',
        //     labelBackgroundColor: Colors.black,
        //     onTap: () {
        //       TestService.showBets();
        //     }),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   labelBackgroundColor: Colors.black,
        //   label: 'Show double board',
        //   onTap: () => TestService.showDoubleBoard(),
        // ),
        //
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   labelBackgroundColor: Colors.black,
        //   label: 'Fill center view',
        //   onTap: () => TestService.fillCenterView(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   labelBackgroundColor: Colors.black,
        //   label: 'Simulate Bet Movement',
        //   onTap: () => TestService.simulateBetMovement(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Show Rank',
        //   labelBackgroundColor: Colors.black,
        //   onTap: () => TestService.showRank(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   labelBackgroundColor: Colors.black,
        //   label: 'Show holecards',
        //   onTap: () => TestService.showHoleCards(),
        // ),
        //
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   label: 'Fireworks',
        // //   labelBackgroundColor: Colors.black,
        // //   onTap: () => TestService.showFireworks(),
        // // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   labelBackgroundColor: Colors.black,
        //   label: 'Show double board',
        //   onTap: () => TestService.showDoubleBoard(),
        // ),
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   labelBackgroundColor: Colors.black,
        // //   label: 'Show Bets',
        // //   onTap: () => TestService.showBets(),
        // // ),
        // SpeedDialChild(
        //     child: Icon(
        //       Icons.adb_rounded,
        //       color: Colors.white,
        //     ),
        //     backgroundColor: Colors.red,
        //     label: 'Show Bet Widget',
        //     labelBackgroundColor: Colors.black,
        //     onTap: () {
        //       TestService.testBetWidget();
        //     }),
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   label: 'Mic Animation',
        // //   labelBackgroundColor: Colors.black,
        // //   onTap: () => TestService.showMicAnimation(),
        // // ),
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   labelBackgroundColor: Colors.black,
        // //   label: 'Seat Change Prompt',
        // //   onTap: () => TestService.showSeatChangePrompt(),
        // // ),
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   labelBackgroundColor: Colors.black,
        // //   label: 'Show Dealer Widget',
        // //   onTap: () => TestService.showDealerWidget(),
        // // ),
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   labelBackgroundColor: Colors.black,
        // //   label: 'Notification',
        // //   onTap: () => TestService.showTextNotification(),
        // // ),
        // // SpeedDialChild(
        // //   child: Icon(
        // //     Icons.adb_rounded,
        // //     color: Colors.white,
        // //   ),
        // //   backgroundColor: Colors.red,
        // //   labelBackgroundColor: Colors.black,
        // //   label: 'Show Muck Losing Hand',
        // //   onTap: () => TestService.showMuckLosingHand(),
        // // ),
      ],
      backgroundColor: AppColorsNew.appAccentColor,
    );
  }

  static void startGame(String gameCode) async {
    developer.log('Starting the game');
    await GameService.startGame(gameCode);
  }

  /*
  * Call back function, which lets the current player join the game
  * the passed setPosition info is used to join the game
  * This function can be disabled, when the current user get's in the game */

  static Future<PlayerStatus> joinGame({
    @required BuildContext context,
    @required Seat seat,
    @required String gameCode,
    @required GameState gameState,
  }) async {
    assert(seat != null);

    developer.log('joining game with seat no ${seat.serverSeatPos}');

    try {
      ConnectionDialog.show(context: context, loadingText: "Joining...");
      // if setPos is -1 that means block this function call
      if (seat.serverSeatPos == -1) return PlayerStatus.NOT_PLAYING;

      int seatNumber = seat.serverSeatPos;
      debugLog(gameCode,
          'Player ${gameState.currentPlayer.name} joining at seat $seatNumber');
      final newPlayerModel = await GameService.takeSeat(gameCode, seatNumber,
          location: gameState.currentLocation);
      debugLog(gameCode,
          'Player ${gameState.currentPlayer.name} join response: ${newPlayerModel.toString()}');
      PlayerStatus status = playerStatusFromStr(newPlayerModel.status);
      if (gameState.useAgora) {
        debugLog(gameCode, 'Fetching agora token');
        log('Fetching agora token');
        final audioToken = await GameService.getLiveAudioToken(
          gameCode,
        );
        debugLog(gameCode, 'agora token: $audioToken');
        log('agora token: $audioToken');
        gameState.agoraToken = audioToken;
      }
      assert(newPlayerModel != null);
      if (newPlayerModel.playerUuid == gameState.currentPlayerUuid) {
        newPlayerModel.isMe = true;
      }
      gameState.newPlayer(newPlayerModel);
      if (newPlayerModel.stack == 0) {
        newPlayerModel.showBuyIn = true;
      }

      // update hive store
      GameHiveStore ghs = gameState.gameHiveStore;
      ghs.initialize(gameState.gameCode);

      ConnectionDialog.dismiss(context: context);
      if (newPlayerModel.isMe) {
        await Future.delayed(Duration(milliseconds: 100));
        final mySeat = gameState.mySeat;
        mySeat.player.namePlateId = gameState.getNameplateId();
        mySeat.notify();
        gameState.redrawFooterState.notify();
      }
      await gameState.refreshNotes();
      final tableState = gameState.tableState;
      tableState.notifyAll();
      gameState.notifyAllSeats();
      if (newPlayerModel.isMe && status == PlayerStatus.WAIT_FOR_BUYIN) {
        GamePlayScreenUtilMethods.onBuyin(context);
      }

      return status;
    } catch (err) {
      ConnectionDialog.dismiss(context: context);
      throw err;
    }
  }

  /* provider method, returns list of all the providers used in the below hierarchy */
  static List<SingleChildWidget> getProviders({
    @required BuildContext context,
    @required GameState gameState,
    @required GameInfoModel gameInfoModel,
    @required String gameCode,
    //@required Agora agora,
    @required BoardAttributesObject boardAttributes,
    @required GameContextObject gameContextObject,
    List<PlayerInSeat> hostSeatChangePlayers,
    bool seatChangeInProgress = false,
  }) {
    var providers = [
      /* a header object is used to update the header section of
        * the game screen - it contains data regarding the current hand no, club name,
        * club code and so on */
      ListenableProvider<GameContextObject>(
        create: (_) => gameContextObject,
      ),
      Provider<GameState>(
        create: (_) => gameState,
      ),

      /* board object used for changing board attributes */
      /* default is horizontal view */
      ListenableProvider<BoardAttributesObject>(
        create: (_) => boardAttributes,
      ),

      /* a copy of Game Info Model is kept in the provider
        * This is used to get the max or min BuyIn amounts
        * or the game code, or for further info about the game */
      ListenableProvider<ValueNotifier<GameInfoModel>>(
        create: (_) => ValueNotifier(gameInfoModel),
      ),

      /* footer view, is maintained by this Provider - either how action buttons,
        * OR prompt for buy in are shown
        * */
      // ListenableProvider<ValueNotifier<FooterStatus>>(
      //   create: (_) => ValueNotifier(
      //     FooterStatus.None,
      //   ),
      // ),
    ];

    //if (!gameState.customizationMode) {
    providers.addAll([
      /* this is for the seat change animation values */
      ListenableProvider<ValueNotifier<SeatChangeModel>>(
        create: (_) => ValueNotifier<SeatChangeModel>(null),
      ),

      /* this is for general notifications */
      ListenableProvider<ValueNotifier<GeneralNotificationModel>>(
        create: (_) => ValueNotifier<GeneralNotificationModel>(null),
      ),

      /* this is for the highHand Notification */
      ListenableProvider<ValueNotifier<HHNotificationModel>>(
        create: (_) => ValueNotifier<HHNotificationModel>(null),
      ),

      /* managing audio assets as temporary files */
      ListenableProvider<ValueNotifier<Map<String, String>>>(
        create: (_) => ValueNotifier(
          Map<String, String>(),
        ),
      ),

      /* This provider contains the remainingActionTime - this provider
          * is used only when QUERY_CURRENT_HAND message is processed */
      ListenableProvider<RemainingTime>(
        create: (_) => RemainingTime(),
      ),

      /* for game chat notifications - unread messages, counts */
    ]);
    //}

    /* add all the providers in the game state to our providers */
    for (final provider in gameState.providers) {
      if (provider != null) {
        providers.add(provider);
      }
    }
    return providers;
  }

  static Widget breakBuyIntimer(BuildContext context, Seat seat) {
    if (seat.player.status == AppConstants.PLAYING) {
      return SizedBox.shrink();
    }

    if (!(seat.player.status == AppConstants.IN_BREAK ||
        seat.player.status == AppConstants.WAIT_FOR_BUYIN ||
        seat.player.status == AppConstants.WAIT_FOR_BUYIN_APPROVAL)) {
      //log('breakBuyIntimer Rebuild buyin button: seat.player.status: ${seat.player.status}');
      return SizedBox.shrink();
    }

    if (seat.player.inBreak && seat.player.breakTimeExpAt != null) {
      final now = DateTime.now().toUtc();
      final diff = seat.player.breakTimeExpAt?.difference(now);
      return buyInTimer(context, seat, diff?.inSeconds ?? 0);
    }
    //log('breakBuyIntimer Rebuild buyin button: seat.player.action.action: ${seat.player.action.action} seat.player.stack: ${seat.player.stack} seat.player.buyInTimeExpAt: ${seat.player.buyInTimeExpAt}');

    //log('Rebuild buyin button: buyInTimeExpAt:');
    if (seat.player.action.action != HandActions.ALLIN &&
        seat.player.stack == 0 &&
        seat.player.buyInTimeExpAt != null) {
      final now = DateTime.now().toUtc();
      final diff = seat.player.buyInTimeExpAt?.difference(now);
      //log('breakBuyIntimer Rebuild buyin button: buyInTimeExpAt: ${seat.player.buyInTimeExpAt.toIso8601String()} Remaining Diff: ${diff}');
      return buyInTimer(context, seat, diff?.inSeconds ?? 0);
    } else {
      //log('No buyin and no break in buttons');
      return SizedBox.shrink();
    }
  }

  static Widget buyInTimer(BuildContext context, Seat seat, int time) {
    return Countdown(
        seconds: time,
        onFinished: () {
          if (seat.isMe) {
            // hide buyin button
            final gameState = GameState.getState(context);
            seat.player.showBuyIn = false;
            gameState.notifyAllSeats();
            seat.notify();
          }
        },
        build: (_, time) {
          if (time <= 10) {
            return BlinkText(printDuration(Duration(seconds: time.toInt())),
                style: AppStylesNew.itemInfoTextStyle.copyWith(
                  color: Colors.white,
                ),
                beginColor: Colors.white,
                endColor: Colors.orange,
                times: time.toInt(),
                duration: Duration(seconds: 1));
          } else {
            return Text(
              printDuration(Duration(seconds: time.toInt())),
              style: AppStylesNew.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            );
          }
        });
  }

  static Future<void> onBuyin(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    if (gameState.buyInKeyboardShown) {
      return;
    }

    String header;
    if (gameInfo.clubCode != null &&
        gameState.gameSettings.buyInApprovalLimit ==
            BuyInApprovalLimit.BUYIN_CREDIT_LIMIT) {
      ConnectionDialog.show(
          context: context, loadingText: "Fetching available credits...");

      double credits = await ClubsService.getAvailableCredit(
          gameInfo.clubCode, gameState.mySeat.player.playerUuid.toString());

      ConnectionDialog.dismiss(context: context);

      if (gameState.gameSettings.buyInApprovalLimit ==
          BuyInApprovalLimit.BUYIN_CREDIT_LIMIT) {
        header = "Available credits: " + DataFormatter.chipsFormat(credits);
      }
    }

    gameState.buyInKeyboardShown = true;
    String title =
        'Buy In (${DataFormatter.chipsFormat(gameInfo.buyInMin)} - ${DataFormatter.chipsFormat(gameInfo.buyInMax)})';
    /* use numeric keyboard to get buyin */
    double value = await NumericKeyboard2.show(
      context,
      header: header,
      title: title,
      min: gameInfo.buyInMin.toDouble(),
      max: gameInfo.buyInMax.toDouble(),
      decimalAllowed: gameInfo.chipUnit == ChipUnit.CENT,
    );
    gameState.buyInKeyboardShown = false;

    if (value == null) return;

    // buy chips
    final resp = await GameService.buyIn(
      gameInfo.gameCode,
      value,
    );
    if (resp == null) {
      String message = 'Buyin Failed. Retry again!';
      showErrorDialog(context, 'Buyin', message);
      return;
    }
    if (!resp.approved) {
      if (resp.insufficientCredits) {
        String message =
            'Not enough credits available. Available credits: ${DataFormatter.chipsFormat(resp.availableCredits)}';
        showErrorDialog(context, 'Credits', message);
      }
    }
  }
}
