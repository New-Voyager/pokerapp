import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:provider/provider.dart';

class NewHandUpdateService {
  NewHandUpdateService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    /* data contains the dealer, small blind and big blind seat Positions
    * Update the Players object with these information */

    var newHand = data['newHand'];

    // there are seat nos
    int dealerPos = newHand['buttonPos'];
    int sbPos = newHand['sbPos'];
    int bbPos = newHand['bbPos'];
    int noCards = newHand['noCards'];

    // put the no Cards information
    Provider.of<ValueNotifier<int>>(
      context,
      listen: false,
    ).value = noCards;

    // get the players list
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    // remove all highlight winners
    Provider.of<Players>(
      context,
      listen: false,
    ).removeWinnerHighlight();

    // before marking the small, big blind or the dealer, remove any marking from the old hand
    Provider.of<Players>(
      context,
      listen: false,
    ).removeMarkersFromAllPlayer();

    // remove all the status (last action) of all the players
    Provider.of<Players>(
      context,
      listen: false,
    ).removeAllPlayersStatus();

    // remove all the folder players
    Provider.of<Players>(
      context,
      listen: false,
    ).removeAllFoldedPlayers();

    /* clean up from result views */
    /* set footer status to none  */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.None;
    /* clearing the footer result */
    Provider.of<FooterResult>(
      context,
      listen: false,
    ).reset();

    /* marking the small blind */
    int smallBlindIdx = players.players.indexWhere((p) => p.seatNo == sbPos);
    assert(smallBlindIdx != -1);
    Provider.of<Players>(
      context,
      listen: false,
    ).updatePlayerTypeInSilent(
      smallBlindIdx,
      PlayerType.SmallBlind,
    );

    /* marking the big blind */
    int bigBlindIdx = players.players.indexWhere((p) => p.seatNo == bbPos);
    assert(bigBlindIdx != -1);
    Provider.of<Players>(
      context,
      listen: false,
    ).updatePlayerType(
      bigBlindIdx,
      PlayerType.BigBlind,
    );

    /* marking the dealer */
    int dealerIdx = players.players.indexWhere((p) => p.seatNo == dealerPos);
    print('dealer index: $dealerIdx');
    assert(dealerIdx != -1);
    Provider.of<Players>(
      context,
      listen: false,
    ).updatePlayerType(
      dealerIdx,
      PlayerType.Dealer,
    );

    /* get a new card back asset to be shown */
    Provider.of<ValueNotifier<String>>(
      context,
      listen: false,
    ).value = CardBackAssets.getRandom();

    // wait for the fastAnimationDuration completion
    // this is done to wait until the footerResult section is removed
    await Future.delayed(AppConstants.fastAnimationDuration);

    // remove all the community cards
    Provider.of<TableState>(
      context,
      listen: false,
    ).updateCommunityCardsSilent([]);

    Provider.of<TableState>(
      context,
      listen: false,
    ).updatePotChips(
      potChips: null,
      potUpdatesChips: null,
    );
  }
}
