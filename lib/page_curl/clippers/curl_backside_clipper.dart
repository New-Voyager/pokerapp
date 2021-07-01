import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pokerapp/page_curl/models/vector_2d.dart';

class CurlBackSideClipper extends CustomClipper<Path> {
  final Vector2D mA, /*mD,*/ mE, mF, mG;

  CurlBackSideClipper({
    @required this.mA,
    //@required this.mD,
    @required this.mE,
    @required this.mF,
    @required this.mG,
  });

  Path createCurlEdgePath2() {
    Path path = Path();
    path.moveTo(mA.x, mA.y);
    //path.lineTo(mD.x, math.max(0, mD.y));
    path.lineTo(mE.x, mE.y);
    path.lineTo(mF.x, mF.y);
    path.lineTo(mA.x, mA.y);

    return path;
  }

  Path createCurlEdgePath() {
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
