import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option/seat_change_bottom_sheet.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option/waiting_list.dart';
import 'package:pokerapp/widgets/list_tile.dart';

class Actions4Widget extends StatelessWidget {
  final AppTextScreen text;
  final GameState gameState;
  const Actions4Widget({Key key, @required this.text, @required this.gameState})
      : super(key: key);

  void onOpenQueue(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return WaitingListBottomSheet(
            gameState, gameState.gameCode, gameState.currentPlayerUuid);
      },
    );
  }

  void onSeatChange(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SeatChangeBottomSheet(
            gameState, gameState.gameCode, gameState.currentPlayerUuid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidgetTile(
          icon: Icons.queue,
          title: text["queue"],
          onPressed: () async {
            // open waiting list screen
            Navigator.of(context).pop();
            onOpenQueue(context);
          },
        ),
        gameState.isPlaying
            ? IconWidgetTile(
                svgIconPath: 'assets/images/seat.svg',
                title: text['seatChange'],
                onPressed: () async {
                  // open waiting list screen
                  Navigator.of(context).pop();
                  onSeatChange(context);
                },
              )
            : Container(),
      ],
    );
  }
}
