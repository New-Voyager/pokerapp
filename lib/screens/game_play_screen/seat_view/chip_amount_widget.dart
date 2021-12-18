import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ChipAmountWidget extends StatefulWidget {
  final bool animate;
  final GlobalKey potKey;
  final Seat seat;
  final BoardAttributesObject boardAttributesObject;
  final GameInfoModel gameInfo;
  final GlobalKey key;
  final bool reverse;

  ChipAmountWidget({
    @required this.animate,
    @required this.potKey,
    @required this.key,
    @required this.seat,
    @required this.boardAttributesObject,
    @required this.gameInfo,
    this.reverse = false,
  });

  @override
  _ChipAmountWidgetState createState() => _ChipAmountWidgetState();
}

class _ChipAmountWidgetState extends State<ChipAmountWidget>
    with AfterLayoutMixin<ChipAmountWidget> {
  @override
  Widget build(BuildContext context) {
    // log('ChipAmountWidget: Rebuilding ChipAmountWidget seat ${widget.seat.seatPos.toString()} position: ${widget.seat.potViewPos}');

    bool showBet = false;
    Offset offset = Offset.zero;

    final BoardAttributesObject boardAttributesObject =
        context.read<BoardAttributesObject>();

    Map<SeatPos, Offset> betAmountPos = boardAttributesObject.betAmountPosition;

    if (betAmountPos[widget.seat.seatPos] != null) {
      offset = betAmountPos[widget.seat.seatPos];
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
    Color color = Colors.transparent;
    if (action.action == HandActions.ALLIN) {
      color = Colors.teal[700];
    } else if (action.action == HandActions.BET) {
      color = Colors.blue[800];
    } else if (action.action == HandActions.RAISE) {
      color = Colors.red[700];
    } else if (action.action == HandActions.CALL) {
      color = Colors.green[900];
    }

    if (widget.animate) {
      if (widget.reverse) {
        color = Colors.green[900];
      } else {
        color = Colors.black;
      }
    }

    /* show the coin amount */
    Widget amount = Text(
      DataFormatter.chipsFormat(action.amount),
      style: TextStyle(
        color: Colors.white,
        fontSize: 10.dp,
        fontWeight: FontWeight.bold,
        fontFamily: AppAssets.fontFamilyLato,
      ),
    );
    amount = Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        // height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),
        child: amount);

    final widthSep = SizedBox(width: 2.0);

    final SeatPos seatPos = widget.seat.seatPos;
    final textPos = betTextPos[seatPos] ?? BetTextPos.Right;
    if (textPos == BetTextPos.Left) {
      children.add(amount);
      children.add(widthSep);
      children.add(coin);
    } else {
      children.add(coin);
      children.add(widthSep);
      children.add(amount);
    }

    // if (seatPos == SeatPos.topCenter ||
    //     seatPos == SeatPos.topCenter1 ||
    //     seatPos == SeatPos.topCenter2) {
    //   children = [];
    //   children.add(coin);
    //   children.add(widthSep);
    //   children.add(amount);
    // } else {
    // }

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
    final potViewPos = widget.boardAttributesObject.potGlobalPos;
    final RenderBox box = context.findRenderObject();
    if (box != null && potViewPos != null) {
      appState.setPosForSeat(widget.seat, box.globalToLocal(potViewPos));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (!appState.isPosAvailableFor(widget.seat)) {
      calculatePotViewPos(context);
    }
  }
}

class ChipAmountAnimatingWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(seatPos);

    Offset end = appState.getPosForSeat(seat);
    Offset begin = seat.betWidgetPos;

    print('ChipAmountAnimatingWidget: end:$end begin:$begin');

    if (reverse ?? false) {
      return WinnerChipAnimation(
        begin: end,
        end: begin,
      );
    }

    return TweenAnimationBuilder(
      child: child,
      tween: Tween<Offset>(
        begin: begin,
        end: end,
      ),
      duration: AppConstants.chipMovingAnimationDuration,
      builder: (_, offset, child) => Transform.translate(
        offset: offset,
        child: child,
      ),
    );
  }
}

const int startDelay = 200;
const int noOfCoins = 6;

class WinnerChipAnimation extends StatelessWidget {
  final Offset begin;
  final Offset end;
  final double winningAmount;

  WinnerChipAnimation({
    @required this.begin,
    @required this.end,
    this.winningAmount = 100.0,
  });

  Widget _coin() {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow,
        border: Border.all(
          color: Colors.red,
          width: 3.0,
        ),
      ),
    );
  }

  Widget _tweenAnimator(int idx) {
    return TweenAnimationBuilder(
      key: ValueKey(idx),
      curve: Curves.easeInOutQuad,
      child: _coin(),
      tween: Tween<Offset>(
        begin: begin,
        end: end,
      ),
      duration: Duration(
        milliseconds: AppConstants.chipMovingAnimationDuration.inMilliseconds +
            (startDelay * idx),
      ),
      builder: (_, offset, child) => Transform.translate(
        offset: offset,
        child: child,
      ),
    );
  }

  Widget _winningAmountAnimation() {
    return TweenAnimationBuilder(
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 2000),
      child: Text(
        '+ $winningAmount',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 50.0,
        ),
      ),
      builder: (_, v, child) => Opacity(
        opacity: 1 - v,
        child: Transform.translate(
          offset: Offset(0.0, -v * 40),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // coins animation
        ...List.generate(noOfCoins, (i) => i + 1)
            .reversed
            .map<Widget>((i) => _tweenAnimator(i))
            .toList(),

        // winning amount
        _winningAmountAnimation(),
      ],
    );
  }
}
