import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pokerapp/page_curl/models/vector_2d.dart';

class CurlBackSideClipper extends CustomClipper<Path> {
  final Vector2D mA, /*mD,*/ mE, mF, mG, mN, mEnd;

  CurlBackSideClipper(
      {@required this.mA,
      //@required this.mD,
      @required this.mE,
      @required this.mF,
      @required this.mG,
      @required this.mN,
      @required this.mEnd});

  Path createCurlEdgePath() {
    Path path = Path();

    path.moveTo(mA.x, mA.y);
    path.moveTo(mN.x, mN.y);
    if (mG.y >= mEnd.y) {
      path.moveTo(mG.x, mG.y);
    } else {
      path.moveTo(mN.x, mN.y);
      path.moveTo(mG.x, mG.y);
    }
    //path.lineTo(mD.x, math.max(0, mD.y));
    //path.lineTo(mE.x, mE.y);
    //path.lineTo(mF.x, mF.y);
    path.lineTo(mA.x, mA.y);

    return path;
  }

  Path createCurlEdgePath2() {
    // A -> N -> [X ->] G -> A
    // A -> E -> G -> A
    Path path = Path();
    path.moveTo(mA.x, mA.y);
    //path.lineTo(mD.x, math.max(0, mD.y));
    path.lineTo(mE.x, mE.y);
    path.lineTo(mG.x, mG.y);
    path.lineTo(mA.x, mA.y);

    return path;
  }

  @override
  Path getClip(Size size) {
    return createCurlEdgePath();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
