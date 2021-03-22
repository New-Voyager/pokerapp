import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class NewHandService {
  NewHandService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    /* play the new hand sound effect */
    Audio.play(
      context: context,
      assetFile: AppAssets.newHandSound,
    );

    /* data contains the dealer, small blind and big blind seat Positions
    * Update the Players object with these information */

    var newHand = data['newHand'];

    // there are seat nos
    int dealerPos = newHand['buttonPos'];
    int sbPos = newHand['sbPos'];
    int bbPos = newHand['bbPos'];
    int noCards = newHand['noCards'];
    int bigBlind = double.parse(newHand['bigBlind'].toString()).toInt();
    int smallBlind = double.parse(newHand['smallBlind'].toString()).toInt();

    // put the no Cards information
    /*
    Provider.of<ValueNotifier<int>>(
      context,
      listen: false,
    ).value = noCards;
    */

    GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    final handInfo = gameState.getHandInfo(context);
    handInfo.update(noCards: noCards);

    final Players players = gameState.getPlayers(context);

    final TableState tableState = gameState.getTableState(context);

    gameState.resetPlayers(context, notify: false);

    /* clean up from result views */
    /* set footer status to none  */
    /* clearing the footer result */
    Provider.of<FooterResult>(
      context,
      listen: false,
    ).reset();

    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.None;

    /* marking the small blind */
    int smallBlindIdx = players.players.indexWhere((p) => p.seatNo == sbPos);
    assert(smallBlindIdx != -1);

    players.updatePlayerTypeSilent(
      smallBlindIdx,
      TablePosition.SmallBlind,
      coinAmount: smallBlind,
    );

    /* marking the big blind */
    int bigBlindIdx = players.players.indexWhere((p) => p.seatNo == bbPos);
    assert(bigBlindIdx != -1);
    players.updatePlayerTypeSilent(
      bigBlindIdx,
      TablePosition.BigBlind,
      coinAmount: bigBlind,
    );

    /* marking the dealer */
    int dealerIdx = players.players.indexWhere((p) => p.seatNo == dealerPos);
    //print('dealer index: $dealerIdx');
    assert(dealerIdx != -1);
    players.updatePlayerTypeSilent(
      dealerIdx,
      TablePosition.Dealer,
    );

    players.notifyAll();

    /* get a new card back asset to be shown */
    Provider.of<ValueNotifier<String>>(
      context,
      listen: false,
    ).value = CardBackAssets.getRandom();

    // wait for the fastAnimationDuration completion
    // this is done to wait until the footerResult section is removed
    await Future.delayed(AppConstants.fastAnimationDuration);

    // remove all the community cards
    tableState.clear();
    /* put new hand message */
    tableState.updateTableStatusSilent(AppConstants.NEW_HAND);

    tableState.notifyAll();
  }
}
