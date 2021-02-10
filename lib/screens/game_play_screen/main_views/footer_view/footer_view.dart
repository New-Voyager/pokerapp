import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';
import 'communication_view.dart';
import 'game_action.dart';
import 'hand_analyse_view.dart';

class FooterView extends StatelessWidget {
  final GameComService gameComService;
  final String gameCode;
  final String playerUuid;
  final Function chatVisibilityChange;
  FooterView(this.gameComService, this.gameCode, this.playerUuid,
      this.chatVisibilityChange);

  @override
  Widget build(BuildContext context) =>
      Consumer2<ValueNotifier<FooterStatus>, Players>(
        builder: (_, footerStatusValueNotifier, players, __) {
          PlayerModel playerModel;

          try {
            playerModel = players.players.firstWhere(
              (p) => p.isMe,
              orElse: null,
            );
          } catch (_) {
            playerModel = null;
          }

          return Stack(
            children: [
              playerModel == null
                  ? const SizedBox.shrink()
                  : GameAction(
                      footerStatus: footerStatusValueNotifier.value,
                      playerModel: playerModel,
                    ),
              HandAnalyseView(),
              CommunicationView(chatVisibilityChange)
            ],
          );
        },
      );
}
