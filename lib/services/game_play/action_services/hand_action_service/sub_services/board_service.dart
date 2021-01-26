import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:provider/provider.dart';

class BoardService {
  BoardService._();

  static void reset(BuildContext context) async {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    // remove all highlight winners
    players.removeWinnerHighlightSilent();

    // before marking the small, big blind or the dealer, remove any marking from the old hand
    players.removeMarkersFromAllPlayerSilent();

    // remove all the status (last action) of all the players
    players.removeAllPlayersStatusSilent();

    // remove all the folder players
    players.removeAllFoldedPlayersSilent();

    players.notifyAll();

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

    // remove all the community cards
    tableState.updateCommunityCardsSilent([]);
    tableState.updatePotChipsSilent(
      potChips: null,
      potUpdatesChips: null,
    );
    tableState.notifyAll();
  }
}
