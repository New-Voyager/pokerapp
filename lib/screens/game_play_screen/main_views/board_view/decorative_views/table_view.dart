import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:provider/provider.dart';

class TableView extends StatelessWidget {
  final double height;
  final double width;

  TableView(
    this.height,
    this.width,
  );

  // todo: do we need the center and fitted box?
  Widget build(BuildContext context) {
    return Consumer<BoardAttributesObject>(builder: (_, boardAttrObj, __) {
      log('Table width: ${boardAttrObj.tableSize.width} height: ${boardAttrObj.tableSize.height}');
      return Center(
        child: Container(
          width: boardAttrObj.tableSize.width,
          height: boardAttrObj.tableSize.height,
          child: Image.asset(
            boardAttrObj.isOrientationHorizontal
                ? AppAssets.horizontalTable
                : AppAssets.verticalTable,
            fit: BoxFit.fill,
          ),
        ),
      );
    });
  }
}
