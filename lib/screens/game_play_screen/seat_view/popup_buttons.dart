import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:lottie/lottie.dart';

class PopupWidget extends StatefulWidget {
  final _PopupWidget state = _PopupWidget();
  final SeatPos seatPos;
  PopupWidget(this.seatPos);

  @override
  _PopupWidget createState() {
    return state;
  }

  void toggle() {
    state.toggle();
  }
}

class _PopupWidget extends State<PopupWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _controller;
  void toggle() {
    if (_animationController.value == null) {
      setState(() {});
    } else {
      _animationController.value > 0
          ? _animationController.reverse()
          : _animationController.forward();
    }
  }

  @override
  void initState() {
    log('PopupWidget initState');
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(milliseconds: 100),
    );
    _controller = AnimationController(vsync: this);

    _animationController.addListener(() {
      // print("11234 value : ${_animationController.value}");
      setState(() {});
    });
    Future.delayed(Duration(milliseconds: 100), () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      child: buttons(),
    );
  }

  Widget buttons() {
    Offset offset = Offset(160, 150);
    switch (widget.seatPos) {
      case SeatPos.bottomCenter:
        offset = Offset(180, 230);
        break;
      case SeatPos.bottomLeft:
        offset = Offset(30, 230);
        break;
      case SeatPos.middleLeft:
        offset = Offset(20, 110);
        break;
      case SeatPos.topLeft:
        offset = Offset(20, 0);
        break;
      case SeatPos.topCenter1:
        offset = Offset(140, -20);
        break;
      case SeatPos.topCenter2:
        offset = Offset(230, -20);
        break;
      case SeatPos.topRight:
        offset = Offset(340, 0);
        break;
      case SeatPos.middleRight:
        offset = Offset(360, 110);
        break;
      case SeatPos.bottomRight:
        offset = Offset(330, 230);
        break;

      default:
        offset = Offset(160, 150);
        break;
    }

    return Stack(
      children: [
        //Container(color: Colors.blue),
        Transform.translate(
            offset: offset,
            child: FloatingMenuItem(
              child: Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green[200]),
                    color: Colors.green[200],
                  ),
                  child: Icon(
                    Icons.note_outlined,
                    color: Colors.black,
                  )),
              controller: _animationController,
              seatPosition: widget.seatPos,
              itemNo: 1,
              onTapFunc: () {
                log("TAPPED 1");
              },
            )),
        Transform.translate(
            offset: offset,
            child: FloatingMenuItem(
              child: Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green[200]),
                  color: Colors.green[200],
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.black,
                ),
              ),
              controller: _animationController,
              seatPosition: widget.seatPos,
              itemNo: 2,
              onTapFunc: () {
                log("TAPPED 2");
              },
            )),
        Transform.translate(
            offset: offset,
            child: FloatingMenuItem(
              child: Container(
                width: 32,
                height: 32,
                child: Lottie.asset(
                  'assets/animations/chicken.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
              controller: _animationController,
              seatPosition: widget.seatPos,
              itemNo: 3,
              onTapFunc: () {
                log("TAPPED 3");
              },
            )),
      ],
    );
  }
}

class FloatingMenuItem extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final SeatPos seatPosition;
  final int itemNo;
  final Function onTapFunc;

  FloatingMenuItem(
      {this.child,
      this.controller,
      this.seatPosition,
      this.itemNo,
      this.onTapFunc});

  @override
  Widget build(BuildContext context) {
    debugPrint('popup widget build');
    double angleInDegrees = 45.0;
    double offsetDistance = 60.0;
    switch (seatPosition) {
      case SeatPos.bottomCenter:
        angleInDegrees = 180.0;
        break;
      case SeatPos.bottomLeft:
        angleInDegrees = 245.0;
        break;
      case SeatPos.bottomRight:
        angleInDegrees = 135.0;
        break;
      case SeatPos.middleRight:
        angleInDegrees = 90.0;
        break;
      case SeatPos.middleLeft:
        angleInDegrees = -90;
        break;
      case SeatPos.topCenter:
      case SeatPos.topCenter1:
      case SeatPos.topCenter2:
        angleInDegrees = 0.0;
        break;
      case SeatPos.topLeft:
        angleInDegrees = -45;
        break;
      case SeatPos.topRight:
        angleInDegrees = 45.0;
        break;
    }

    return Transform.translate(
      offset: Offset.fromDirection(
          GamePlayScreenUtilMethods.getRadiansFromDegree(
              angleInDegrees + (itemNo * 45)),
          controller.value * offsetDistance),
      child: GestureDetector(
          onTap: () {
            onTapFunc();
          },
          child: child),
    );
  }
}
