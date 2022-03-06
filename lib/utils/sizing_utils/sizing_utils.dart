import 'package:flutter/material.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';

abstract class SizingUtils {
  static Size getPlayersOnTableSize(Size tableSize) {
    return Size(
      tableSize.width,
      tableSize.height + NamePlateWidgetParent.namePlateSize.height * 1.5,
    );
  }
}
