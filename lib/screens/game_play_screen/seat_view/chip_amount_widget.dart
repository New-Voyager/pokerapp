import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/player_view.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/formatter.dart';

class ChipAmountWidget extends StatefulWidget {
  final bool animate;
  final GlobalKey potKey;
  final Seat seat;
  final BoardAttributesObject boardAttributesObject;
  final GameInfoModel gameInfo;
  final GlobalKey key;
  final NeedRecalculating recalculatingNeeded;

  ChipAmountWidget({
    @required this.recalculatingNeeded,
    @required this.animate,
    @required this.potKey,
    @required this.key,
    @required this.seat,
    @required this.boardAttributesObject,
    @required this.gameInfo,
  });

  @override
  _ChipAmountWidgetState createState() => _ChipAmountWidgetState();
}

class _ChipAmountWidgetState extends State<ChipAmountWidget>
    with AfterLayoutMixin<ChipAmountWidget> {
  @override
  Widget build(BuildContext context) {
    //log('potViewPos: Rebuilding ChipAmountWidget seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos}');

    bool showBet = false;
    Offset offset = Offset.zero;

    final BoardAttributesObject boardAttributesObject =
        context.read<BoardAttributesObject>();

    Map<SeatPos, Offset> betAmountPos = boardAttributesObject.betAmountPosition;

    if (betAmountPos[widget.seat.uiSeatPos] != null) {
      offset = betAmountPos[widget.seat.uiSeatPos];
    }

    if (widget.seat.betWidgetPos == null) {
      widget.seat.betWidgetPos = offset;
    }

    if (widget.seat.player.action.amount != null &&
        widget.seat.player.action.amount != 0 &&
        widget.seat.player.startingStack >= 0) {
      showBet = true;
    }

    final action = widget.seat.player.action;

    Widget betWidget;

    if (!showBet)
      return Container(
        width: 10,
        height: 10,
        color: Colors.transparent,
      );

    List<Widget> children = [];

    // TODO: FIX THE LOGIC FOR SHOWING CHIPS
    Widget coin;
    if (action.amount <= widget.gameInfo.bigBlind / 2) {
      coin = SvgPicture.asset(
        'assets/images/betchips/sb.svg',
        height: 10.0,
      );
    } else if (action.amount == widget.gameInfo.bigBlind) {
      coin = SvgPicture.asset(
        'assets/images/betchips/sb.svg',
        height: 10.0,
      );
    } else if (action.amount == 2 * widget.gameInfo.bigBlind) {
      coin = SvgPicture.asset(
        'assets/images/betchips/straddle.svg',
        height: 10.0,
      );
    } else if (action.amount > 0.0) {
      coin = SvgPicture.asset(
        'assets/images/betchips/raisebig.svg',
        height: 25.0,
        width: 15.0,
      );
    }

    /* show the coin amount */
    final amount = Text(
      DataFormatter.chipsFormat(action.amount),
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        fontFamily: AppAssets.fontFamilyLato,
      ),
    );

    final widthSep = SizedBox(width: 2.0);

    final SeatPos seatPos = widget.seat.uiSeatPos;

    if (seatPos == SeatPos.middleRight ||
        seatPos == SeatPos.bottomRight ||
        seatPos == SeatPos.topRight) {
      children.add(amount);
      children.add(widthSep);
      children.add(coin);
    } else {
      children.add(coin);
      children.add(widthSep);
      children.add(amount);
    }

    CrossAxisAlignment crossAxisAlignment;

    if (seatPos == SeatPos.bottomLeft ||
        seatPos == SeatPos.bottomCenter ||
        seatPos == SeatPos.bottomRight)
      crossAxisAlignment = CrossAxisAlignment.end;
    else
      crossAxisAlignment = CrossAxisAlignment.center;

    betWidget = Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    if (widget.animate) {
      return betWidget;
    }

    return Transform.translate(
      offset: offset,
      child: betWidget,
    );
  }

  void calculatePotViewPos(BuildContext context) {
    // ONLY checking if widget.seat.potViewPos is Null is not helpful, as AFTER SEAT CHANGE, the potViewPos changes, but due to this condition
    // the new seat position are not calculated, thus calculating the potViewPos every hand
    // if (widget.seat.potViewPos != null && !widget.recalculatingNeeded) {
    //   return;
    // }

    // // log('potViewPos: 2 afterFirstLayout ChipAmountWidget seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos}');
    // when widget.animate is true, I am not in this widget
    // if (this.widget.animate) {
    //   // log('potViewPos: 2 return afterFirstLayout ChipAmountWidget seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos}');
    //   return;
    // }

    final potKey = widget.boardAttributesObject.getPotsKey(0);
    //  log('potViewPos: 3 afterFirstLayout potKey: $potKey ChipAmountWidget seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos}');

    if (potKey == null || potKey.currentContext == null) {
      // log('potViewPos: 3 return afterFirstLayout ChipAmountWidget seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos} potKey: ${potKey} potKey.currentContext: ${potKey.currentContext}');
      return;
    }

    log('pauldebug: CALCULATING SEAT POS');

    //  log('potViewPos: 4 afterFirstLayout ChipAmountWidget seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos}');
    final RenderBox potViewBox = potKey.currentContext.findRenderObject();
    final potViewPos = potViewBox.localToGlobal(Offset(0, 0));
    final RenderBox box = context.findRenderObject();
    widget.seat.potViewPos = box.globalToLocal(potViewPos);
    // log('potViewPos: Setting potViewPos for seat ${widget.seat.serverSeatPos} position: ${widget.seat.potViewPos}');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.recalculatingNeeded.value || widget.seat.potViewPos == null) {
      calculatePotViewPos(context);
      // widget.recalculatingNeeded.value = false;

      Future.delayed(const Duration(seconds: 2)).then((_) {
        // set to false, ONLY after recalculation for all the players are DONE
        widget.recalculatingNeeded.value = false;
      });
    }
  }
}

class ChipAmountAnimatingWidget extends StatefulWidget {
  final int seatPos;
  final Widget child;
  final bool reverse;

  ChipAmountAnimatingWidget({
    Key key,
    this.seatPos,
    this.child,
    this.reverse,
  }) : super(key: key);

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
      vsync: this,
      duration: AppConstants.chipMovingAnimationDuration,
    );

    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(context, widget.seatPos);
    Offset end = seat.potViewPos;
    Offset begin = Offset(0, 0);
    begin = seat.betWidgetPos;
    this.begin = begin;
    log('Chip Animation: chip amount animation end: $end');
    //log('reverse animation: ${widget.reverse ?? false}, winner: ${seat.player.action.winner}');
    if (widget.reverse ?? false) {
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
