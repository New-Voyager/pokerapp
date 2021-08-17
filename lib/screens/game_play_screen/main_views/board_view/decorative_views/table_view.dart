import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:provider/provider.dart';

class TableView extends StatelessWidget {
  final double height;
  final double width;

  TableView({
    @required this.height,
    @required this.width,
  });

  Widget build(BuildContext context) {
    final boardAttrObj = context.read<BoardAttributesObject>();
    final gameState = GameState.getState(context);

    return Center(
      child: Container(
        width: boardAttrObj.tableSize.width,
        height: boardAttrObj.tableSize.height,
        clipBehavior: Clip.none,
        child: Image.memory(
          gameState.assets.getBoard(),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
