import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';

import 'dart:math' as math;

Map<int, Offset> _finalPositionCache = Map();

class ChipAmountWidget extends StatelessWidget {
  final Seat seat;
  final BoardAttributesObject boardAttributesObject;
  ChipAmountWidget({
    Key key,
    @required this.seat,
    @required this.boardAttributesObject,
  }) : super(key: key);

  Offset _getCenterPos(BuildContext context) {
    List<Offset> _playerPositions = [];

    // go through all the seat nos
    for (int i = 1; i <= 9; i++) {
      try {
        _playerPositions.add(_getFinalPosition(context, i));
      } catch (_) {}
    }

    double xAvg = 0;
    double yAvg = 0;

    for (Offset offset in _playerPositions) {
      xAvg += offset.dx;
      yAvg += offset.dy;
    }

    xAvg /= _playerPositions.length;
    yAvg /= _playerPositions.length;

    return Offset(
      xAvg,
      yAvg,
    );
  }

  Offset _getFinalPosition(
    BuildContext context,
    int seatNo,
  ) {
    Offset _getPositionOffsetFromKey(GlobalKey key) {
      final RenderBox renderBox = key.currentContext.findRenderObject();
      return renderBox.localToGlobal(Offset.zero);
    }

    if (_finalPositionCache.containsKey(seatNo)) {
      // log('final position from cache');
      return _finalPositionCache[seatNo];
    }

    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(context, seatNo);

    return _getPositionOffsetFromKey(seat.key);
  }

  @override
  Widget build(BuildContext context) {
    bool showBet = true;
    if (seat.player?.coinAmount == null || seat.player?.coinAmount == 0) {
      showBet = false;
    }

    Widget child;
    if (!showBet) {
      // show bet position
      child = Container(
        width: 10,
        height: 10,
        color: Colors.transparent,
      );
    } else {
      List<Widget> children = [];

      /* show the coin svg */
      final coin = Container(
        height: 20,
        width: 20.0,
        child: SvgPicture.asset(
          AppAssets.coinsImages,
        ),
      );

      /* show the coin amount */
      final amount = Text(seat.player?.coinAmount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            fontFamily: AppAssets.fontFamilyLato,
          ));

      if (seat.uiSeatPos == SeatPos.middleRight ||
          seat.uiSeatPos == SeatPos.bottomRight ||
          seat.uiSeatPos == SeatPos.topRight) {
        children.add(amount);
        children.add(SizedBox(height: 2.0));
        children.add(coin);
      } else {
        children.add(coin);
        children.add(SizedBox(height: 2.0));
        children.add(amount);
      }

      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    // final Offset p = _getFinalPosition(
    //   context,
    //   seat.serverSeatPos,
    // );

    // final Offset c = _getCenterPos(
    //   context,
    // );

    // /* get the angle theta */
    // final double yy = c.dy - p.dy;
    // final double xx = c.dx - p.dx;

    // final double theta = math.atan(yy / xx);

    // final double moveByConstant =
    //     boardAttributesObject.getBetPos() * (xx < 0 ? -1 : 1); // 100: 10 inch, 60: 5 inch,  75: 7 inch

    // // log('${seat.serverSeatPos} : $yy : $xx : $theta');

    // Offset offset = Offset(
    //   moveByConstant * math.cos(theta),
    //   moveByConstant * math.sin(theta),
    // );

    // log('${seat.uiSeatPos.toString()}: nameplate size: ${boardAttributesObject.namePlateSize}');
    Offset offset = Offset(0, 0);

    // 5 inches
    Map<SeatPos, Offset> betAmountPos = {
      SeatPos.bottomCenter:
          Offset(0, -boardAttributesObject.namePlateSize.height + 10),
      SeatPos.bottomLeft:
          Offset(0, -boardAttributesObject.namePlateSize.height + 20),
      SeatPos.middleLeft: Offset(boardAttributesObject.namePlateSize.width - 20,
          boardAttributesObject.namePlateSize.height / 2),
      SeatPos.topLeft: Offset(boardAttributesObject.namePlateSize.width / 2,
          boardAttributesObject.namePlateSize.height / 2 + 10),
      SeatPos.topCenter:
          Offset(0, boardAttributesObject.namePlateSize.height - 20),
      SeatPos.topCenter1:
          Offset(0, boardAttributesObject.namePlateSize.height - 20),
      SeatPos.topCenter2:
          Offset(0, boardAttributesObject.namePlateSize.height - 20),
      SeatPos.topRight:
          Offset(-20, boardAttributesObject.namePlateSize.height - 20),
      SeatPos.middleRight: Offset(
          -boardAttributesObject.namePlateSize.width + 10,
          boardAttributesObject.namePlateSize.height / 2),
      SeatPos.bottomRight:
          Offset(-20, -boardAttributesObject.namePlateSize.height + 20),
    };
    if (boardAttributesObject.screenSize > 7) {
      betAmountPos = {
        SeatPos.bottomCenter:
            Offset(0, -boardAttributesObject.namePlateSize.height - 30),
        SeatPos.bottomLeft:
            Offset(0, -boardAttributesObject.namePlateSize.height - 30),
        SeatPos.middleLeft: Offset(
            boardAttributesObject.namePlateSize.width + 30,
            -(boardAttributesObject.namePlateSize.height / 2)),
        SeatPos.topLeft: Offset(boardAttributesObject.namePlateSize.width,
            boardAttributesObject.namePlateSize.height + 10),
        SeatPos.topCenter:
            Offset(0, boardAttributesObject.namePlateSize.height + 30),
        SeatPos.topCenter1:
            Offset(0, boardAttributesObject.namePlateSize.height + 30),
        SeatPos.topCenter2:
            Offset(0, boardAttributesObject.namePlateSize.height + 30),
        SeatPos.topRight:
            Offset(-10, boardAttributesObject.namePlateSize.height + 20),
        SeatPos.middleRight: Offset(
            -boardAttributesObject.namePlateSize.width - 50,
            -(boardAttributesObject.namePlateSize.height / 2)),
        SeatPos.bottomRight:
            Offset(-30, -boardAttributesObject.namePlateSize.height - 30),
      };
    } else if (boardAttributesObject.screenSize == 7) {
      betAmountPos = {
        SeatPos.bottomCenter:
            Offset(0, -boardAttributesObject.namePlateSize.height),
        SeatPos.bottomLeft:
            Offset(0, -boardAttributesObject.namePlateSize.height),
        SeatPos.middleLeft: Offset(boardAttributesObject.namePlateSize.width,
            (boardAttributesObject.namePlateSize.height) / 2),
        SeatPos.topLeft: Offset(boardAttributesObject.namePlateSize.width / 2,
            boardAttributesObject.namePlateSize.height),
        SeatPos.topCenter:
            Offset(0, boardAttributesObject.namePlateSize.height),
        SeatPos.topCenter1:
            Offset(0, boardAttributesObject.namePlateSize.height),
        SeatPos.topCenter2:
            Offset(0, boardAttributesObject.namePlateSize.height),
        SeatPos.topRight:
            Offset(-10, boardAttributesObject.namePlateSize.height),
        SeatPos.middleRight: Offset(
            -boardAttributesObject.namePlateSize.width - 20,
            (boardAttributesObject.namePlateSize.height / 2)),
        SeatPos.bottomRight:
            Offset(-30, -boardAttributesObject.namePlateSize.height),
      };
    }

    if (betAmountPos[seat.uiSeatPos] != null) {
      offset = betAmountPos[seat.uiSeatPos];
    }

    return Transform.translate(
      offset: offset,
      child: Transform.scale(
          scale: boardAttributesObject.getBetWidgetScale(), child: child),
    );
  }
}
