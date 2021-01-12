import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_object.dart';
import 'package:provider/provider.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math' as math;

const innerWidth = 5.0;
const outerWidth = 20.0;

Matrix4 _pmat(num pv) {
  return new Matrix4(
    1.0, 0.0, 0.0, 0.0, //
    0.0, 1.0, 0.0, 0.0, //
    0.0, 0.0, 1.0, pv * 0.001, //
    0.0, 0.0, 0.0, 1.0,
  );
}

Matrix4 perspective = _pmat(1.0);

const verticalBorderRadius = BorderRadius.all(
  const Radius.circular(
    1000.0,
  ),
);

const horizontalBorderRadius = BorderRadius.all(
  const Radius.elliptical(300.0, 250.0),
);

const _borderRadius = const BorderRadius.all(
  const Radius.circular(
    1000.0,
  ),
);

class TableView extends StatelessWidget {
  final double height;
  final double width;
  TableView(this.height, this.width);

  Widget build(BuildContext context) {
    final board = Provider.of<BoardObject>(context);
    Container child = Container(
      width: width,
      height: board.horizontal ? height + 40 : height,
      padding: EdgeInsets.all(innerWidth),
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
            spreadRadius: 1.0,
          )
        ],
        color: const Color(0xff646464),
        borderRadius:
            board.horizontal ? horizontalBorderRadius : verticalBorderRadius,
        border: Border.all(
          color: const Color.fromRGBO(0xc0, 0x40, 0, 0.5),
          width: outerWidth,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            radius: 0.80,
            colors: const [
              const Color(0xff0d47a1),
              const Color(0xff08142b),
            ],
          ),
          borderRadius:
              board.horizontal ? horizontalBorderRadius : verticalBorderRadius,
        ),
      ),
    );

    return new Center(
      child: new Transform(
          child: new FittedBox(
            fit: BoxFit.fill,
            child: child,
          ),
          alignment: FractionalOffset.center,
          transform: perspective.scaled(1.0, 1.0, 1.0)
            ..rotateX(math.pi - 10 * math.pi / 180)
            ..rotateY(0.0)
            ..rotateZ(0.0)),
    );
  }
}

class ZTableView extends StatelessWidget {
  final double height;
  final double width;
  ZTableView(this.height, this.width);

  Widget build(BuildContext context) {
    final board = Provider.of<BoardObject>(context);
    return ZIllustration(children: [
      ZPositioned(
          rotate: ZVector.only(x: 70),
          child: ZRoundedRect(
            width: width - 20,
            height: height + 50,
            borderRadius: 120,
            stroke: 20,
            color: Color.fromRGBO(0xc0, 0x40, 0, 0.5),
          )),
    ]);
  }
}
