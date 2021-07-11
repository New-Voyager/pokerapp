import 'package:flutter/material.dart';
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
    return Center(
      child: Container(
        width: boardAttrObj.tableSize.width,
        height: boardAttrObj.tableSize.height,
        clipBehavior: Clip.none,
        child: Image.asset(
          boardAttrObj.isOrientationHorizontal
              ? AppAssets.horizontalTable
              : AppAssets.verticalTable,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
