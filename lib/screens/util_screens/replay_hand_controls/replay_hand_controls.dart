import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_controls/replay_hand_controls_utils.dart';

class ReplayHandControls extends StatelessWidget {
  ReplayHandControls({
    @required this.gameReplayController,
  }) : assert(gameReplayController != null);

  final GameReplayController gameReplayController;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /* repeat button */
          ReplayHandControlsUtils.buildControlButton(
            iconData: Icons.repeat_rounded,
            onPressed: gameReplayController.repeat,
          ),

          /* skip previous button */
          ReplayHandControlsUtils.buildControlButton(
            iconData: Icons.skip_previous_rounded,
            onPressed: gameReplayController.skipPrevious,
          ),

          /* play / pause button */
          StreamBuilder<bool>(
            stream: gameReplayController.isPlaying,
            initialData: false,
            builder: (_, snapshot) =>
                ReplayHandControlsUtils.buildControlButton(
              iconData: snapshot.data
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              onPressed: gameReplayController.playOrPause,
            ),
          ),

          /* skip next button */
          ReplayHandControlsUtils.buildControlButton(
            iconData: Icons.skip_next_rounded,
            onPressed: gameReplayController.skipNext,
          ),

          /* close button */
          ReplayHandControlsUtils.buildControlButton(
            iconData: Icons.close_rounded,
            onPressed: () {
              gameReplayController.dispose();
              Navigator.pop(context);
            },
          ),
        ],
      );
}
