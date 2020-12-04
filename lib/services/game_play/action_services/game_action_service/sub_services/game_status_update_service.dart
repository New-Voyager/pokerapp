import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:provider/provider.dart';

class GameStatusUpdateService {
  GameStatusUpdateService._();

  static void updateStatus({
    BuildContext context,
    var status,
  }) {
    Provider.of<TableState>(
      context,
      listen: false,
    ).updateTableStatus(status['tableStatus']);
  }
}
