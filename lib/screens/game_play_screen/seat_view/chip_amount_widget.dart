import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';

Map<int, Offset> _finalPositionCache = Map();

class ChipAmountWidget extends StatefulWidget {
  final bool animate;
  final GlobalKey potKey;
  final Seat seat;
  final BoardAttributesObject boardAttributesObject;
  final GlobalKey key;

  ChipAmountWidget({
    @required this.animate,
    @required this.potKey,
    @required this.key,
    @required this.seat,
    @required this.boardAttributesObject,
  });

  @override
  _ChipAmountWidgetState createState() => _ChipAmountWidgetState();
}

class _ChipAmountWidgetState extends State<ChipAmountWidget>
    with AfterLayoutMixin<ChipAmountWidget> {
  Offset betOffset;
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
    final gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);
    if (boardAttributes.betImage == null) {
      log('betimage is null');
    } else {
      log('betimage is not null');
    }

    bool showBet = true;
    if (widget.seat.player?.coinAmount == null ||
        widget.seat.player?.coinAmount == 0) {
      showBet = false;
    }

    bool bb = false;
    bool sb = false;
    bool bigbet = true;

    if (widget.seat.serverSeatPos == 1) {
      sb = true;
    }
    if (widget.seat.serverSeatPos == 2) {
      bb = true;
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

      Widget coin;
      if (sb) {
        coin = Container(
          height: 15,
          width: 15.0,
          child: SvgPicture.asset(
            'assets/images/betchips/sb.svg',
          ),
        );
      } else if (bb) {
        coin = Container(
          height: 20,
          width: 20.0,
          child: SvgPicture.asset(
            'assets/images/betchips/bb.svg',
          ),
        );
      } else if (widget.seat.serverSeatPos == 3) {
        coin = Container(
          height: 15,
          width: 15.0,
          child: SvgPicture.asset(
            'assets/images/betchips/straddle.svg',
          ),
        );
      } else {
        if (widget.seat.serverSeatPos == 5 || widget.seat.serverSeatPos == 7) {
          coin = Container(
            height: 25,
            width: 15.0,
            child: SvgPicture.asset(
              'assets/images/betchips/callbig.svg',
            ),
          );
        } else if (widget.seat.serverSeatPos == 4 ||
            widget.seat.serverSeatPos == 9) {
          coin = Container(
            height: 25,
            width: 15.0,
            child: SvgPicture.asset(
              'assets/images/betchips/raisebig.svg',
            ),
          );
        } else {
          coin = Container(
            height: 25,
            width: 15.0,
            child: SvgPicture.asset(
              'assets/images/betchips/allin.svg',
            ),
          );
        }
      }

      /* show the coin amount */
      final amount = Text(widget.seat.player?.coinAmount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            fontFamily: AppAssets.fontFamilyLato,
          ));

      if (widget.seat.uiSeatPos == SeatPos.middleRight ||
          widget.seat.uiSeatPos == SeatPos.bottomRight ||
          widget.seat.uiSeatPos == SeatPos.topRight) {
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

    Size namePlateSize = widget.boardAttributesObject.namePlateSize;
    // 5 inches
    Map<SeatPos, Offset> betAmountPos = {
      SeatPos.bottomCenter: Offset(0, -namePlateSize.height / 2 - 20),
      SeatPos.bottomLeft:
          Offset(namePlateSize.width / 2, -namePlateSize.height / 2 - 10),
      SeatPos.middleLeft: Offset(0, namePlateSize.height / 2 + 10),
      SeatPos.topLeft:
          Offset(namePlateSize.width / 2, namePlateSize.height / 2 + 10),
      SeatPos.topCenter: Offset(0, namePlateSize.height / 2 + 10),
      SeatPos.topCenter1: Offset(0, namePlateSize.height / 2 + 10),
      SeatPos.topCenter2: Offset(0, namePlateSize.height / 2 + 10),
      SeatPos.topRight:
          Offset(-namePlateSize.width / 2 - 10, namePlateSize.height / 2 + 10),
      SeatPos.middleRight: Offset(-10, namePlateSize.height / 2 + 10),
      SeatPos.bottomRight:
          Offset(-namePlateSize.width / 2 - 10, -namePlateSize.height / 2 - 10),
    };
    if (widget.boardAttributesObject.screenSize > 7) {
      betAmountPos = {
        SeatPos.bottomCenter:
            Offset(0, -widget.boardAttributesObject.namePlateSize.height - 30),
        SeatPos.bottomLeft:
            Offset(0, -widget.boardAttributesObject.namePlateSize.height - 30),
        SeatPos.middleLeft: Offset(
            widget.boardAttributesObject.namePlateSize.width + 30,
            -(widget.boardAttributesObject.namePlateSize.height / 2)),
        SeatPos.topLeft: Offset(
            widget.boardAttributesObject.namePlateSize.width,
            widget.boardAttributesObject.namePlateSize.height + 10),
        SeatPos.topCenter:
            Offset(0, widget.boardAttributesObject.namePlateSize.height + 30),
        SeatPos.topCenter1:
            Offset(0, widget.boardAttributesObject.namePlateSize.height + 30),
        SeatPos.topCenter2:
            Offset(0, widget.boardAttributesObject.namePlateSize.height + 30),
        SeatPos.topRight:
            Offset(-10, widget.boardAttributesObject.namePlateSize.height + 20),
        SeatPos.middleRight: Offset(
            -widget.boardAttributesObject.namePlateSize.width - 50,
            -(widget.boardAttributesObject.namePlateSize.height / 2)),
        SeatPos.bottomRight: Offset(
            -30, -widget.boardAttributesObject.namePlateSize.height - 30),
      };
    } else if (widget.boardAttributesObject.screenSize == 7) {
      betAmountPos = {
        SeatPos.bottomCenter:
            Offset(0, -widget.boardAttributesObject.namePlateSize.height),
        SeatPos.bottomLeft:
            Offset(0, -widget.boardAttributesObject.namePlateSize.height),
        SeatPos.middleLeft: Offset(
            widget.boardAttributesObject.namePlateSize.width,
            (widget.boardAttributesObject.namePlateSize.height) / 2),
        SeatPos.topLeft: Offset(
            widget.boardAttributesObject.namePlateSize.width / 2,
            widget.boardAttributesObject.namePlateSize.height),
        SeatPos.topCenter:
            Offset(0, widget.boardAttributesObject.namePlateSize.height),
        SeatPos.topCenter1:
            Offset(0, widget.boardAttributesObject.namePlateSize.height),
        SeatPos.topCenter2:
            Offset(0, widget.boardAttributesObject.namePlateSize.height),
        SeatPos.topRight:
            Offset(-10, widget.boardAttributesObject.namePlateSize.height),
        SeatPos.middleRight: Offset(
            -widget.boardAttributesObject.namePlateSize.width - 20,
            (widget.boardAttributesObject.namePlateSize.height / 2)),
        SeatPos.bottomRight:
            Offset(-30, -widget.boardAttributesObject.namePlateSize.height),
      };
    }

    if (betAmountPos[widget.seat.uiSeatPos] != null) {
      offset = betAmountPos[widget.seat.uiSeatPos];
    }
    betOffset = offset;
    final betWidget = Transform.scale(
        scale: widget.boardAttributesObject.getBetWidgetScale(), child: child);
    if (widget.animate) {
      return betWidget;
    }
    return Transform.translate(
      offset: offset,
      child: betWidget,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (this.widget.animate) {
      return;
    }

    final RenderBox potViewBox =
        this.widget.potKey.currentContext.findRenderObject();
    final potViewPos = potViewBox.localToGlobal(Offset(0, 0));
    final RenderBox box = context.findRenderObject();
    final pos = box.localToGlobal(Offset(0, 0));
    widget.seat.seatBet.betWidgetPos = betOffset; //Offset(0,0);
    widget.seat.seatBet.potViewPos = box.globalToLocal(potViewPos);
  }
}

class ChipAmountAnimatingWidget extends StatefulWidget {
  final int seatPos;
  final Widget child;
  final bool reverse;

  ChipAmountAnimatingWidget({
    this.seatPos,
    this.child,
    this.reverse,
  });

  @override
  _ChipAmountAnimatingWidgetState createState() =>
      _ChipAmountAnimatingWidgetState();
}

class _ChipAmountAnimatingWidgetState extends State<ChipAmountAnimatingWidget>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<Offset> animation;
  Offset end;
  Offset begin;

  @override
  void initState() {
    /* calling animate in init state */
    animate();

    super.initState();
  }

  void animate() async {
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));

    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(context, widget.seatPos);
    Offset end = seat.seatBet.potViewPos;
    Offset begin = Offset(0, 0);
    begin = seat.seatBet.betWidgetPos;
    this.begin = begin;

    if (widget.reverse) {
      Offset swap = end;
      end = begin;
      begin = swap;
    }

    this.end = end;

    animation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(animationController);

    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* if animation is NULL do nothing */
    if (animation == null) return Container();
    return Transform.translate(
      offset: animation.value,
      child: widget.child,
    );
  }
}
