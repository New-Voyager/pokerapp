import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:provider/provider.dart';

Map<int, Offset> _finalPositionCache = Map();

class CardDistributionAnimatingWidget extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  Widget _buildCardBack() => Container(
        height: AppDimensions.cardHeight,
        width: AppDimensions.cardWidth,
        decoration: BoxDecoration(),
        child: Consumer<ValueNotifier<String>>(
          builder: (_, cardBackAssetImageNotifier, __) => Image.asset(
            cardBackAssetImageNotifier.value,
          ),
        ),
      );

  Offset _getPositionOffsetFromKey(GlobalKey key) {
    final RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero);
  }

  Offset _getFinalPosition(
    BuildContext context,
    int seatNo,
  ) {
    if (_finalPositionCache.containsKey(seatNo)) {
      // log('final position from cache');
      return _finalPositionCache[seatNo];
    }

    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(context, seatNo);

    final RenderBox parentBox =
        this._globalKey.currentContext.findRenderObject();

    final Offset offset = parentBox.globalToLocal(
      _getPositionOffsetFromKey(seat.key),
    );

    return _finalPositionCache[seatNo] = Offset(
      offset.dx,
      offset.dy + 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardDistributionModel>(
      key: _globalKey,
      builder: (_, model, __) {
        if (model.seatNo == null) return SizedBox.shrink();

        final Offset finalOffset = _getFinalPosition(
          context,
          model.seatNo,
        );

        return TweenAnimationBuilder<Offset>(
          key: ValueKey(model.seatNo),
          child: _buildCardBack(),
          curve: Curves.easeOut,
          tween: Tween<Offset>(
            begin: Offset(0, 0),
            end: finalOffset,
          ),
          duration: AppConstants.cardDistributionAnimationDuration,
          builder: (_, Offset offset, Widget child) {
            double offsetPercentageDone = (offset.dy / finalOffset.dy);

            double scale = 1.5 + offsetPercentageDone * (0.50 - 1.5);

            return Transform.translate(
              offset: offset,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: offsetPercentageDone > 0.99 ? 0.0 : 1.0,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
