import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';
import 'communication_view.dart';
import 'game_action.dart';
import 'hand_analyse_view.dart';
import 'seat_change_confirm_widget.dart';

class FooterView extends StatelessWidget {
  final GameComService gameComService;
  final String gameCode;
  final String clubCode;
  final String playerUuid;
  final Function chatVisibilityChange;

  FooterView(
    this.gameComService,
    this.gameCode,
    this.playerUuid,
    this.chatVisibilityChange,
    this.clubCode,
  );

  @override
  Widget build(BuildContext context) =>
      Consumer2<ValueNotifier<FooterStatus>, Players>(
        builder: (_, footerStatusValueNotifier, players, __) {
          return Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HandAnalyseView(gameCode, clubCode),
                  CommunicationView(chatVisibilityChange, gameComService.chat),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Expanded(
                  flex: 1,
                  child: players.me == null
                      ? const SizedBox.shrink()
                      : GameAction(
                          footerStatus: footerStatusValueNotifier.value,
                          playerModel: players.me,
                        ),
                ),
              ),
              Consumer2<HostSeatChange, GameContextObject>(
                builder: (context, hostSeatChange, gameContextObject, _) =>
                    hostSeatChange.seatChangeInProgress &&
                            gameContextObject.playerId ==
                                hostSeatChange.seatChangeHost
                        ? Align(
                            alignment: Alignment.center,
                            child: SeatChangeConfirmWidget(),
                          )
                        : SizedBox.shrink(),
              )
            ],
          );
        },
      );
}
