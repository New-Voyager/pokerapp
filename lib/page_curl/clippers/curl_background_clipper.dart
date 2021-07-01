import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pokerapp/page_curl/models/vector_2d.dart';
// Clip path: N F A E

class CurlBackgroundClipper extends CustomClipper<Path> {
  final Vector2D mA, /*mD,*/ mE, mF, mM, mN, mP, mG, mEnd;
  final bool shouldClip;
  CurlBackgroundClipper(
      {@required this.mA,
      //@required this.mD,
      @required this.mE,
      @required this.mF,
      @required this.mM,
      @required this.mN,
      @required this.mP,
      @required this.mG,
      @required this.mEnd,
      @required this.shouldClip});

  Path createBackgroundPath2() {
    Path path = Path();

    path.moveTo(mM.x, mM.y);
    path.lineTo(mP.x, mP.y);
    path.lineTo(mE.x, math.max(0, mE.y));
    //path.lineTo(mD.x, math.max(0, mD.y));
    path.lineTo(mA.x, mA.y);
    path.lineTo(mN.x, mN.y);
    if (mF.x < 0) path.lineTo(mF.x, mF.y);
    path.lineTo(mM.x, mM.y);

    return path;
  }

  Path createBackgroundPath() {
    Path path = Path();

    // Clip path: M A G P M
    path.moveTo(mM.x, mM.y);
    path.lineTo(mA.x, mA.y);
    path.lineTo(mG.x, mG.y);
    path.lineTo(mEnd.x, mEnd.y);
    path.lineTo(mP.x, mP.y);
    path.lineTo(mM.x, mM.y);

    return path;
  }

  @override
  Path getClip(Size size) {
    return createBackgroundPath();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return this.shouldClip;
  }
}
