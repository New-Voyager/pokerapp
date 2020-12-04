import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:provider/provider.dart';

class YourActionService {
  YourActionService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    var seatAction = data['seatAction'];

    int clubID = data['clubId'];
    int gameID = data['gameId'];
    int seatNo = seatAction['seatNo'];

    Provider.of<ValueNotifier<ActionInfo>>(
      context,
      listen: false,
    ).value = ActionInfo(
      clubID: clubID,
      gameID: gameID,
      seatNo: seatNo,
    );

    // instantiate a player action and notify the corresponding listeners
    Provider.of<ValueNotifier<PlayerAction>>(
      context,
      listen: false,
    ).value = PlayerAction(seatAction);

    // also change the footer status --> this would show the action buttons
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Action;
  }
}
