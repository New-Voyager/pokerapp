import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/app/player_service.dart';

class PopupWidget extends StatefulWidget {
  final GameState gameState;
  final Seat seat;
  final GlobalKey boardViewKey;
  final _PopupWidget state = _PopupWidget();

  // final SeatPos seatPos;
  // final Seat seat;
  // final GameComService gameComService;
  PopupWidget(this.gameState, this.seat, this.boardViewKey);

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
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
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
    //Future.delayed(Duration(milliseconds: 100), () {
    _animationController.forward();
    // });

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
    switch (widget.gameState.getTappedSeatPos) {
      case SeatPos.bottomCenter:
        offset = Offset(180, 260);
        break;
      case SeatPos.bottomLeft:
        offset = Offset(30, 260);
        break;
      case SeatPos.middleLeft:
        offset = Offset(20, 120);
        break;
      case SeatPos.topLeft:
        offset = Offset(20, 0);
        break;
      case SeatPos.topCenter:
        offset = Offset(185, -20);
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
        offset = Offset(340, 120);
        break;
      case SeatPos.bottomRight:
        offset = Offset(330, 260);
        break;

      default:
        offset = Offset(160, 150);
        break;
    }

    return Stack(
      children: [
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
                    Icons.more_horiz_outlined,
                    color: Colors.black,
                  )),
              //  controller: _animationController,
              seatPosition: widget.gameState.getTappedSeatPos,
              itemNo: 1,
              onTapFunc: () {
                log("TAPPED 1");
              },
            )),
      ],
    );
  }

  Offset getOffset() {
    RenderBox globalRenderBox =
        widget.seat.key.currentContext.findRenderObject();
    Offset globalOffset = globalRenderBox.localToGlobal(Offset(0, 0));
    RenderBox localRenderBox =
        widget.boardViewKey.currentContext.findRenderObject();
    Offset localOffset = localRenderBox.globalToLocal(globalOffset);
    return localOffset;
  }

  Offset getMenuOffset(GlobalKey seatKey, GlobalKey boardKey) {
    RenderBox globalRenderBox = seatKey.currentContext.findRenderObject();
    Offset globalOffset = globalRenderBox.localToGlobal(Offset(0, 0));
    RenderBox localRenderBox = boardKey.currentContext.findRenderObject();
    Offset localOffset = localRenderBox.globalToLocal(globalOffset);
    return localOffset;
  }

  showMainMenu(context, GlobalKey seatKey, GlobalKey boardKey) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    double menuItemHeight = 40;
    showMenu(
      context: context,
      color: AppColorsNew.actionRowBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColorsNew.newBorderColor,
        ),
      ),
      position: RelativeRect.fromRect(
          getOffset() & const Size(40, 40),
          // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          height: menuItemHeight,
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Note",
              ),
              Icon(
                Icons.note,
                color: AppColorsNew.yellowAccentColor,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          height: menuItemHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Animation"),
              Lottie.asset(
                'assets/animations/chicken.json',
                height: 32,
                width: 32,
                controller: _controller,
                onLoaded: (composition) {
                  // Configure the AnimationController with the duration of the
                  // Lottie file and start the animation.
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ],
          ),
        ),
        (widget.gameState.currentPlayer.isAdmin())
            ? PopupMenuItem(
                value: 2,
                height: menuItemHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Mute",
                    ),
                    Icon(
                      Icons.volume_off,
                      color: AppColorsNew.yellowAccentColor,
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        (widget.gameState.currentPlayer.isAdmin())
            ? PopupMenuItem(
                value: 3,
                height: menuItemHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Kick",
                    ),
                    Icon(
                      Icons.ios_share,
                      color: AppColorsNew.yellowAccentColor,
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    ).then<void>((delta) async {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)

      if (delta != null) {
        switch (delta) {
          case 0:
            log('user selected NOTE option');
            break;
          case 1:
            final data = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 10,
                  contentPadding: EdgeInsets.zero,
                  content: ProfilePopup(
                    seat: widget.gameState.popupSelectedSeat,
                  ),
                );
              },
            );

            if (data == null) return;
            // log("SEATNO1:: ${widget.gameState.myState.seatNo}");
            // log("SEATNO2:: ${widget.gameState.getMyState(context).seatNo}");
            // log("SEAT FROM:: ${widget.gameState.me(context).seatNo}");
            // log("SEAT TO:: ${widget.gameState.popupSelectedSeat.serverSeatPos}");

            widget.gameState.gameComService.gameMessaging.sendAnimation(
              widget.gameState.me.seatNo,
              widget.gameState.popupSelectedSeat.serverSeatPos,
              data['animationID'],
            );
            break;

          case 2:
            log('user selected mute option');
            break;
          case 3:
            log('calling kickPlayer with ${widget.gameState.gameCode} and ${widget.seat.player.playerUuid}');
            PlayerService.kickPlayer(
                widget.gameState.gameCode, widget.seat.player.playerUuid);
            showSimpleNotification(
              Text('Player will be removed after this hand'),
              position: NotificationPosition.top,
              duration: Duration(seconds: 10),
            );
            break;
        }
      }
      widget.gameState.dismissPopup(context);
    });
  }

  showCustomMenu(context, int index) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          getOffset() & const Size(40, 40),
          // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Mute",
                  ),
                  Icon(
                    Icons.star_border_outlined,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                ],
              ),
              Divider(
                color: AppColorsNew.listViewDividerColor,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Kick",
                  ),
                  Icon(
                    Icons.ios_share,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                ],
              ),
              Divider(
                color: AppColorsNew.listViewDividerColor,
              ),
            ],
          ),
        )
      ],
    ).then<void>((delta) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)
      if (delta == null) {
        return;
      } else {
        switch (delta) {
          case 0:
            log('user selected mute option');
            break;
          case 1:
            log('calling kickPlayer with ${widget.gameState.gameCode} and ${widget.seat.player.playerUuid}');
            PlayerService.kickPlayer(
                widget.gameState.gameCode, widget.seat.player.playerUuid);
            showSimpleNotification(
              Text('Player will be removed after this hand'),
              position: NotificationPosition.top,
              duration: Duration(seconds: 10),
            );
            break;
        }
      }
    });
  }
}

class FloatingMenuItem extends StatelessWidget {
  final Widget child;
  //final AnimationController controller;
  final SeatPos seatPosition;
  final int itemNo;
  final Function onTapFunc;

  FloatingMenuItem(
      {this.child,
      //  this.controller,
      this.seatPosition,
      this.itemNo,
      this.onTapFunc});

  @override
  Widget build(BuildContext context) {
    debugPrint('popup widget build');
    double angleInDegrees = 45.0;
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
        //controller.value * offsetDistance,
        0,
      ),
      child: GestureDetector(onTap: onTapFunc, child: child),
    );
  }
}
