import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_controls/replay_hand_controls_utils.dart';

class ReplayHandControls extends StatelessWidget {
  ReplayHandControls({
    @required this.gameReplayController,
  }) : assert(gameReplayController != null);

  final GameReplayController gameReplayController;

  @override
  Widget build(BuildContext context) => Container(
        color: AppColorsNew.screenBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: gameReplayController.isEnded,
          builder: (_, gameEndedSnapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ! LOW PRIORITY: WILL WORK ON LATER
              // /* repeat button */
              // ReplayHandControlsUtils.buildControlButton(
              //   iconData: Icons.repeat_rounded,
              //   onPressed: gameReplayController.repeat,
              // ),

              /* play / pause button */
              StreamBuilder<bool>(
                stream: gameReplayController.isPlaying,
                initialData: true,
                builder: (_, snapshot) =>
                    ReplayHandControlsUtils.buildControlButton(
                  isActive: !gameEndedSnapshot.data,
                  iconData: snapshot.data
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  onPressed: gameReplayController.playOrPause,
                ),
              ),

              /* skip next button */
              ReplayHandControlsUtils.buildControlButton(
                isActive: !gameEndedSnapshot.data,
                iconData: Icons.skip_next_rounded,
                onPressed: gameReplayController.skipNext,
              ),

              /* close button */
              ReplayHandControlsUtils.buildControlButton(
                isActive: true,
                iconData: Icons.close_rounded,
                onPressed: () => gameReplayController.dispose(context),
              ),
            ],
          ),
        ),
      );
}
