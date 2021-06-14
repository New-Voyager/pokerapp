import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';

class ReplayHandGameView extends StatelessWidget {
  final GameInfoModel gameInfoModel;

  ReplayHandGameView({
    @required this.gameInfoModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isBoardHorizontal = true;
    var boardDimensions = BoardView.dimensions(context, isBoardHorizontal);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        /* background view */
        BackgroundView(),

        /* main board with players */
        Positioned(
          bottom: 10,
          child: Container(
            width: boardDimensions.width,
            height: boardDimensions.height,
            child: BoardView(
              gameComService: null,
              gameInfo: gameInfoModel,
              onUserTap: (_) {},
              onStartGame: () {},
              audioPlayer: null,
            ),
          ),
        ),
      ],
    );
  }
}
