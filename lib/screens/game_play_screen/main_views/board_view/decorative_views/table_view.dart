import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:provider/provider.dart';

const innerWidth = 5.0;
const outerWidth = 20.0;

class TableView extends StatelessWidget {
  final double height;
  final double width;

  TableView(
    this.height,
    this.width,
  );

  Widget build(BuildContext context) {
    // todo: do we need the center and fitted box?
    return Consumer<BoardAttributesObject>(
      builder: (_, boardAttrObj, __) => Center(
        child: FittedBox(
          fit: BoxFit.fill,
          child: Container(
            width: width,
            height: boardAttrObj.isOrientationHorizontal ? height + 40 : height,
            padding: EdgeInsets.all(innerWidth),
            child: Image.asset(
              boardAttrObj.isOrientationHorizontal
                  ? AppAssets.horizontalTable
                  : AppAssets.verticalTable,
            ),
          ),
        ),
      ),
    );
  }
}
