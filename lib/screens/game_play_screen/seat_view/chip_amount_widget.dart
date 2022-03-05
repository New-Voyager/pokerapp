import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ChipAmountWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    calculateSelfChipPos(context);

    bool showBet = false;
    Offset offset = Offset.zero;

    offset = Offset(0, (NamePlateWidgetParent.namePlateSize.height / 2) + 5);
    final seatPos = seat.seatPos;
    if (seatPos == SeatPos.bottomCenter) {
      offset =
          Offset(-20, -((NamePlateWidgetParent.namePlateSize.height / 2) + 15));
    } else if (seatPos == SeatPos.bottomLeft) {
      offset =
          Offset(20, -((NamePlateWidgetParent.namePlateSize.height / 2) + 15));
    } else if (seatPos == SeatPos.bottomRight) {
      offset =
          Offset(-20, -((NamePlateWidgetParent.namePlateSize.height / 2) + 15));
    }

    if (seat.betWidgetPos == null) {
      seat.betWidgetPos = offset;
    }

    if (seat.player.action.amount != null &&
        seat.player.action.amount != 0 &&
        seat.player.startingStack >= 0) {
      showBet = true;
    }

    final action = seat.player.action;

    Widget betWidget;

    if (!showBet)
      return Container(
        width: 10,
        height: 10,
        color: Colors.transparent,
      );

    List<Widget> children = [];

    Widget coin;
    if (action.amount <= gameInfo.bigBlind / 2) {
      coin = SvgPicture.asset(
        'assets/images/betchips/sb.svg',
        height: 10.0,
      );
    } else if (action.amount == gameInfo.bigBlind) {
      coin = SvgPicture.asset(
        'assets/images/betchips/sb.svg',
        height: 10.0,
      );
    } else if (action.amount == 2 * gameInfo.bigBlind) {
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

    if (animate) {
      if (reverse) {
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

    CrossAxisAlignment crossAxisAlignment;

    if (seatPos == SeatPos.bottomLeft ||
        seatPos == SeatPos.bottomCenter ||
        seatPos == SeatPos.bottomRight)
      crossAxisAlignment = CrossAxisAlignment.end;
    else
      crossAxisAlignment = CrossAxisAlignment.center;

    var scale = 0.75;
    if (Screen.isLargeScreen) {
      scale = 1.0;
    }

    betWidget = Transform.scale(
        scale: scale,
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ));

    if (animate) {
      return betWidget;
    }

    return Transform.translate(
      offset: offset,
      child: betWidget,
    );
  }

  void calculateSelfChipPos(BuildContext context) {
    if (!appState.isPosAvailableFor(seat)) {
      final potViewPos = boardAttributesObject.potGlobalPos;
      if (potViewPos != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox box = context.findRenderObject();
          if (box != null) {
            appState.setPosForSeat(seat, box.globalToLocal(potViewPos));
          }
        });
      }
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
    final appTheme = context.read<AppTheme>();

    Offset end = appState.getPosForSeat(seat);
    Offset begin = seat.betWidgetPos;

    bool isWinningAnimation = reverse ?? false;

    if (isWinningAnimation) {
      var tmp = end;
      end = begin;
      begin = tmp;
    }

    if (end == null || begin == null) return const SizedBox.shrink();

    return NewChipAnimation(
      begin: begin,
      end: end,
      appTheme: appTheme,
      isWinningAnimation: isWinningAnimation,
      winningAmount: seat.player.action.amount,
    );
  }
}

const int startDelay = 200;
const int noOfCoins = 3;

class NewChipAnimation extends StatelessWidget {
  final Offset begin;
  final Offset end;
  final double winningAmount;
  final bool isWinningAnimation;
  final AppTheme appTheme;

  NewChipAnimation({
    @required this.appTheme,
    @required this.begin,
    @required this.end,
    this.winningAmount = 100.0,
    this.isWinningAnimation = false,
  });

  Widget _coin() {
    return SizedBox.square(
      dimension: 18.0,
      child: SvgPicture.asset('assets/images/betchips/green.svg'),
    );
  }

  Widget _tweenAnimator(int idx) {
    final ms = AppConstants.chipMovingAnimationDuration.inMilliseconds;
    final duration = ms + (startDelay * idx);

    return TweenAnimationBuilder(
      key: ValueKey(idx),
      curve: Curves.easeInOutQuad,
      child: _coin(),
      tween: Tween<Offset>(
        begin: begin,
        end: end,
      ),
      duration: Duration(milliseconds: duration),
      builder: (_, Offset offset, child) => AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: offset.dy == end.dy ? 0.0 : 1.0,
        child: Transform.translate(
          offset: offset,
          child: child,
        ),
      ),
    );
  }

  Widget _winningAmountAnimation() {
    return TweenAnimationBuilder(
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 3, milliseconds: 500),
      child: BorderedText(
        strokeColor: appTheme.primaryColorWithDark(),
        strokeWidth: 6.0,
        child: Text(
          '+ ${DataFormatter.chipsFormat(winningAmount)}',
          style: TextStyle(
            color: appTheme.accentColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
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
        isWinningAnimation
            ? _winningAmountAnimation()
            : const SizedBox.shrink(),
      ],
    );
  }
}
