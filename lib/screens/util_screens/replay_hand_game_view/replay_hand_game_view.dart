import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view_vertical.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';

class ReplayHandGameView extends StatelessWidget {
  final GameInfoModel gameInfoModel;
  final BoardAttributesObject boardAttributes;
  ReplayHandGameView({
    @required this.boardAttributes,
    @required this.gameInfoModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isBoardHorizontal = true;
    final boardDimensions = boardAttributes.dimensions(context);
    // var boardDimensions = BoardView.dimensions(context, isBoardHorizontal);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        /* background view */
        BackgroundView(),

        /* main board with players */
        Container(
          width: boardDimensions.width,
          height: boardDimensions.height,
          child: BoardView(
            gameComService: null,
            gameInfo: gameInfoModel,
            onUserTap: (_) {},
            onStartGame: () {},
          ),
        ),
      ],
    );
  }
}
