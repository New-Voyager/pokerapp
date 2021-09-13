import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:provider/provider.dart';

class BoardService {
  BoardService._();

  static void reset(BuildContext context) async {
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    gameState.clear();

    /* clean up from result views */
    /* set footer status to none  */
    // Provider.of<ValueNotifier<FooterStatus>>(
    //   context,
    //   listen: false,
    // ).value = FooterStatus.None;
  }
}
