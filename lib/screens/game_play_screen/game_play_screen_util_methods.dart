import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GamePlayScreenUtilMethods {
  GamePlayScreenUtilMethods._();

  /* After the entire table is drawn, if the current player (isMe == true)
    * is waiting for buyIn,then show the footer prompt */
  static void checkForCurrentUserPrompt(BuildContext context) =>
      Provider.of<Players>(
        context,
        listen: false,
      ).players.forEach(
        (p) {
          if (p.isMe && p.stack == 0)
            Provider.of<ValueNotifier<FooterStatus>>(
              context,
              listen: false,
            ).value = FooterStatus.Prompt;
        },
      );

  static void startGame(String gameCode) async {
    developer.log('Starting the game');
    await GameService.startGame(gameCode);
  }

  /*
  * Call back function, which lets the current player join the game
  * the passed setPosition info is used to join the game
  * This function can be disabled, when the current user get's in the game */

  static void joinGame({
    @required int seatPos,
    @required String gameCode,
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
  }

  /* provider method, returns list of all the providers used in the below hierarchy */
  static List<SingleChildWidget> getProviders({
    @required GameInfoModel gameInfoModel,
    @required String gameCode,
    @required int playerID,
    @required String playerUuid,
    @required Function(String) sendPlayerToHandChannel,
  }) =>
      [
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

        /* a simple value notifier, holding INT which
        * resembles number of cards to deal with */
        ListenableProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier(2),
        ),

        /* a header object is used to update the header section of
        * the game screen - it contains data regarding the current hand no, club name,
        * club code and so on */
        ListenableProvider<HeaderObject>(
          create: (_) => HeaderObject(
            gameCode: gameCode,
            playerId: playerID,
            playerUuid: playerUuid,
          ),
        ),

        /* board object used for changing board attributes */
        /* default is horizontal view */
        ListenableProvider<BoardAttributesObject>(
          create: (_) => BoardAttributesObject(),
        ),

        /* a copy of Game Info Model is kept in the provider
        * This is used to get the max or min BuyIn amounts
        * or the game code, or for further info about the game */
        ListenableProvider<ValueNotifier<GameInfoModel>>(
          create: (_) => ValueNotifier(gameInfoModel),
        ),

        /*
        * This Listenable Provider updates the activities of players
        * Player joins, buy Ins, Stacks, everything is notified by the Players objects
        * */
        ListenableProvider<Players>(
          create: (_) => Players(
            players: gameInfoModel.playersInSeats,
          ),
        ),

        /* TableStatus is updated as a string value */
        ListenableProvider<TableState>(
          create: (_) => TableState(
            tableStatus: gameInfoModel.tableStatus,
          ),
        ),

        /* footer view, is maintained by this Provider - either how action buttons,
        * OR prompt for buy in are shown
        * */
        ListenableProvider<ValueNotifier<FooterStatus>>(
          create: (_) => ValueNotifier(
            FooterStatus.None,
          ),
        ),

        /* If footer status become RESULT, then we need to have the
        * result data available, the footer result model holds the result data */
        ListenableProvider<FooterResult>(
          create: (_) => FooterResult(),
        ),

        /* This provider gets a value when YOUR_ACTION message is received,
        * other time this value is kept null, signifying,
        * there is no action to take on THIS user's end
        * */
        ListenableProvider<ValueNotifier<PlayerAction>>(
          create: (_) => ValueNotifier<PlayerAction>(
            null,
          ),
        ),

        /* This provider contains and updates the game info
        * required for player to make an action
        * this provider holds --> clubID, gameID and seatNo */
        ListenableProvider<ValueNotifier<ActionInfo>>(
          create: (_) => ValueNotifier<ActionInfo>(
            null,
          ),
        ),

        /* This provider contains the sendPlayerToHandChannel function
        * so that the function can be called from anywhere down the widget tree */
        Provider<Function(String)>(
          create: (_) => sendPlayerToHandChannel,
        ),

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
      ];
}
