import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

Map<int, Offset> _finalPositionCache = Map();

class ChipAmountWidget extends StatelessWidget {
  final Seat seat;
  ChipAmountWidget({
    Key key,
    @required this.seat,
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
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* show the coin svg */
          Container(
            height: 20,
            width: 20.0,
            child: SvgPicture.asset(
              AppAssets.coinsImages,
            ),
          ),
          const SizedBox(height: 5.0),

          /* show the coin amount */
          Text(
            seat.player?.coinAmount.toString(),
            style: AppStyles.gamePlayScreenPlayerChips,
          ),
        ],
      );
    }

    final Offset p = _getFinalPosition(
      context,
      seat.serverSeatPos,
    );

    // final boardAttribute = Provider.of<BoardAttributesObject>(
    //   context,
    //   listen: false,
    // );

    final Offset c = _getCenterPos(
      context,
    );

    /* get the angle theta */
    final double yy = c.dy - p.dy;
    final double xx = c.dx - p.dx;

    final double theta = math.atan(yy / xx);

    final double moveByConstant = 60.0 * (xx < 0 ? -1 : 1);

    log('${seat.serverSeatPos} : $yy : $xx : $theta');

    final offset = Offset(
      moveByConstant * math.cos(theta),
      moveByConstant * math.sin(theta),
    );

    return Transform.translate(
      offset: offset,
      child: child,
    );
  }
}
