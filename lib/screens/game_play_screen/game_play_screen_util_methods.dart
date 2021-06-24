import 'dart:developer' as developer;
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_hive_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';

import '../../resources/app_colors.dart';
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
  }) {
    return SpeedDial(
      onOpen: onReload,
      overlayColor: Colors.black,
      visible: TestService.isTesting,
      overlayOpacity: 0.1,
      icon: Icons.all_inclusive_rounded,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Fireworks',
          labelBackgroundColor: Colors.black,
          onTap: () => TestService.showFireworks(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Mic Animation',
          labelBackgroundColor: Colors.black,
          onTap: () => TestService.showMicAnimation(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          labelBackgroundColor: Colors.black,
          label: 'Seat Change Prompt',
          onTap: () => TestService.showSeatChangePrompt(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          labelBackgroundColor: Colors.black,
          label: 'Notification',
          onTap: () => TestService.showTextNotification(),
        ),

        SpeedDialChild(
            child: Icon(
              Icons.adb_rounded,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            labelBackgroundColor: Colors.black,
            label: 'reload stack',
            onTap: () => TestService.reloadStack()),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Hand result',
        //   onTap: () => TestService.showHandResult(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Show Bets',
        //   onTap: () => TestService.showBets(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Simulate Bet Movement',
        //   onTap: () => TestService.simulateBetMovement(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Move Pot to Player',
        //   onTap: () => TestService.movePotToPlayer(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'distribute cards',
        //   onTap: () => TestService.distributeCards(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'player stopped talking',
        //   onTap: () => TestService.setPlayerStoppedTalking(),
        // ),

        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set isAdmin false',
        //   onTap: () => TestService.setIsAdminFalse(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Bet Widget',
        //   onTap: () => TestService.testBetWidget(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Number Keyboard',
        //   onTap: () => TestService.showKeyboard(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Show holecards',
        //   onTap: () => TestService.showHoleCards(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'addTurnOrRiverCard',
        //   onTap: () => TestService.addTurnOrRiverCard(),
        // ),

        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Flop',
        //   onTap: () => TestService.addFlopCards(),
        // ),

        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Reset & fold all players',
        //   onTap: () => TestService.resetGameState(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Remove showdown cards',
        //   onTap: () => TestService.removeShowDownCards(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set isAdmin true',
        //   onTap: () => TestService.setIsAdminTrue(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set isAdmin true',
        //   onTap: () => TestService.setIsAdminTrue(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Showdown cards',
        //   onTap: () => TestService.showDownCards(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Dealer Choice',
        //   onTap: () => TestService.dealerChoiceGame(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set current player not playing',
        //   onTap: () => TestService.setCurrentPlayerStatusNotPlaying(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set current player as playing',
        //   onTap: () => TestService.setCurrentPlayerStatusPlaying(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set game status active',
        //   onTap: () => TestService.setGameStateActive(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'set game status inactive',
        //   onTap: () => TestService.setGameStateInActive(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Fill center view',
        //   onTap: () => TestService.fillCenterView(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Waitlist',
        //   onTap: () => TestService.waitlistDialog(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Fold card',
        //   onTap: () => TestService.fold(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Run It Twice Prompt',
        //   onTap: () => TestService.runItTwicePrompt(),
        // ),
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.adb_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red,
        //   label: 'Hand Message',
        //   onTap: () => TestService.handMessage(),
        // ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          labelBackgroundColor: Colors.black,
          label: 'Show holecards',
          onTap: () => TestService.showHoleCards(),
        ),
        /*
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Countdown Timer',
          onTap: () => TestService.testCountdownTimer(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Flushbar',
          onTap: () => TestService.showFlushBar(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Distribute Cards',
          onTap: () => TestService.distributeCards(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Add River / Turn Card',
          onTap: () => TestService.addTurnOrRiverCard(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Add Flop Cards',
          onTap: () => TestService.addFlopCards(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Clear Cards',
          onTap: () => TestService.clearBoardCards(),
        ),

        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Move Pot to Player',
          onTap: () => TestService.movePotToPlayer(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Buyin Test',
          onTap: () => TestService.buyInTest(),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Show Bets',
          onTap: () => TestService.testBetWidget(),
        ),
          */
      ],
      backgroundColor: AppColors.appAccentColor,
    );
  }

  /* After the entire table is drawn, if the current player (isMe == true)
    * is waiting for buyIn,then show the footer prompt */
  // static void checkForCurrentUserPrompt(BuildContext context) {
  //   final players =
  //       Provider.of<GameState>(context, listen: false).getPlayers(context);

  //   if (players.showBuyinPrompt) {
  //     Provider.of<ValueNotifier<FooterStatus>>(
  //       context,
  //       listen: false,
  //     ).value = FooterStatus.Prompt;
  //   }
  // }

  static void startGame(String gameCode) async {
    developer.log('Starting the game');
    await GameService.startGame(gameCode);
  }

  /*
  * Call back function, which lets the current player join the game
  * the passed setPosition info is used to join the game
  * This function can be disabled, when the current user get's in the game */

  static Future joinGame({
    @required int seatPos,
    @required String gameCode,
    @required GameState gameState,
  }) async {
    assert(seatPos != null);

    developer.log('joining game with seat no $seatPos');

    // if setPos is -1 that means block this function call
    if (seatPos == -1) return;

    int seatNumber = seatPos;
    await GameService.joinGame(
      gameCode,
      seatNumber,
    );

    GameHiveStore ghs = gameState.gameHiveStore;

    // we can offer user inital reward here, as well as reset timers here
    if (ghs.isFirstJoin()) {
      // on first join, we give 10 diamonds
      ghs.addDiamonds(num: 10);

      // MARK first join is done
      ghs.setIsFirstJoinDone();
    } else {
      // for any subsequent joins, reset the timer
      ghs.updateLastDiamondUpdateTime();
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
    // initialize game state object
    final seatChangeProvider = SeatChangeNotifier(
        seatChangeInProgress: seatChangeInProgress,
        players: hostSeatChangePlayers);

    var providers = [
      /* rabbit state */
      ListenableProvider<RabbitState>(create: (_) => RabbitState()),

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

      /* this is for having random card back for every new hand */
      ListenableProvider<CardDistributionModel>(
        create: (_) => CardDistributionModel(),
      ),

      /* this is for having random card back for every new hand */
      ListenableProvider<ValueNotifier<String>>(
        create: (_) => ValueNotifier<String>(CardBackAssets.getRandom()),
      ),

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
      ListenableProvider<ValueNotifier<FooterStatus>>(
        create: (_) => ValueNotifier(
          FooterStatus.None,
        ),
      ),

      /* This provider contains the sendPlayerToHandChannel function
        * so that the function can be called from anywhere down the widget tree */
      // Provider<Function(String)>(
      //   create: (_) => sendPlayerToHandChannel,
      // ),

      /* This provider holds the audioPlayer object, which facilitates playing
        * audio in the game */
      Provider<AudioPlayer>(
        create: (_) => AudioPlayer(
          mode: PlayerMode.LOW_LATENCY,
        ),
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

      /* communication provider */
      // ListenableProvider<ValueNotifier<Agora>>(
      //   create: (_) => ValueNotifier(agora),
      // ),

      /* Provider to deal with host seat change functionality */
      ListenableProvider<SeatChangeNotifier>(
        create: (_) => seatChangeProvider,
      ),

      /* for game chat notifications - unread messages, counts */
      ListenableProvider<GameChatNotifState>(
        create: (_) => GameChatNotifState(),
      ),
    ];

    /* add all the providers in the game state to our providers */
    providers.addAll(gameState.providers);
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
      final diff = seat.player.breakTimeExpAt.difference(now);
      return buyInTimer(context, seat, diff.inSeconds);
    }
    //log('breakBuyIntimer Rebuild buyin button: seat.player.action.action: ${seat.player.action.action} seat.player.stack: ${seat.player.stack} seat.player.buyInTimeExpAt: ${seat.player.buyInTimeExpAt}');

    //log('Rebuild buyin button: buyInTimeExpAt:');
    if (seat.player.action.action != HandActions.ALLIN &&
        seat.player.stack == 0 &&
        seat.player.buyInTimeExpAt != null) {
      final now = DateTime.now().toUtc();
      final diff = seat.player.buyInTimeExpAt.difference(now);
      //log('breakBuyIntimer Rebuild buyin button: buyInTimeExpAt: ${seat.player.buyInTimeExpAt.toIso8601String()} Remaining Diff: ${diff}');
      return buyInTimer(context, seat, diff.inSeconds);
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
            final players = gameState.getPlayers(context);
            seat.player.showBuyIn = false;
            players.notifyAll();
            seat.notify();
          }
        },
        build: (_, time) {
          if (time <= 10) {
            return BlinkText(printDuration(Duration(seconds: time.toInt())),
                style: AppStyles.itemInfoTextStyle.copyWith(
                  color: Colors.white,
                ),
                beginColor: Colors.white,
                endColor: Colors.orange,
                times: time.toInt(),
                duration: Duration(seconds: 1));
          } else {
            return Text(
              printDuration(Duration(seconds: time.toInt())),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            );
          }
        });
  }

  static Future<void> onBuyin(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;

    /* use numeric keyboard to get buyin */
    double value = await NumericKeyboard2.show(
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
