import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class Screen {
  final BuildContext c;
  Screen(this.c);

  double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;
  bool isLandscape() =>
      MediaQuery.of(this.c).orientation == Orientation.landscape;
  //PIXELS
  Size size() => MediaQuery.of(this.c).size;
  double width() => size().width;
  double height() => size().height;
  double diagonal() {
    Size s = size();
    return sqrt((s.width * s.width) + (s.height * s.height));
  }

  //INCHES
  Size inches() {
    Size pxSize = size();
    return Size(pxSize.width / _ppi, pxSize.height / _ppi);
  }

  double widthInches() => inches().width;
  double heightInches() => inches().height;
  double diagonalInches() => diagonal() / _ppi;
}
