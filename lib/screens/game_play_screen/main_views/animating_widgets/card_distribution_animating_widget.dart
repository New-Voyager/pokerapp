import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class MultipleCardDistributionAnimatingWidget extends StatelessWidget {
  final GameState _gameState;

  const MultipleCardDistributionAnimatingWidget(
    this._gameState, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _gameState.cardDistributionMap.entries.map<Widget>((e) {
        return CardDistributionAnimatingWidget(
          key: ValueKey(e.key),
          forSeatNo: e.key,
          showDistributionVn: e.value,
        );
      }).toList(),
    );
  }
}

class CardDistributionAnimatingWidget extends StatelessWidget {
  final int forSeatNo;
  final ValueNotifier<bool> showDistributionVn;

  CardDistributionAnimatingWidget({
    Key key,
    @required this.forSeatNo,
    @required this.showDistributionVn,
  }) : super(key: key);

  final _globalKey = GlobalKey();

  Widget _buildCardBack(BuildContext context) {
    final GameState gameState = GameState.getState(context);
    final cardBackImage = Image.memory(gameState.assets.getHoleCardBack());

    return SizedBox(
      height: AppDimensions.cardHeight,
      width: AppDimensions.cardWidth,
      child: cardBackImage,
    );
  }

  Offset _getPositionOffsetFromKey(GlobalKey key) {
    if (key.currentContext == null) {
      return Offset(0, 0);
    }
    final RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero);
  }

  Offset _getFinalPosition(
    BuildContext context,
    int seatNo,
  ) {
    // if (_finalPositionCache.containsKey(seatNo)) {
    //   // log('final position from cache');
    //   return _finalPositionCache[seatNo];
    // }

    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(seatNo);
    if (seat == null || seat.key == null) {
      return Offset(0, 0);
    }

    final RenderBox parentBox =
        this._globalKey.currentContext.findRenderObject();
    if (parentBox == null) {
      return Offset(0, 0);
    }

    final Offset offset = parentBox.globalToLocal(
      _getPositionOffsetFromKey(seat.key),
    );

    return Offset(offset.dx, offset.dy + 50);
  }

  Widget _animatingWidget(BuildContext context) {
    final Offset finalOffset = _getFinalPosition(
      context,
      forSeatNo,
    );

    return TweenAnimationBuilder<Offset>(
      key: UniqueKey(),
      child: _buildCardBack(context),
      curve: Curves.easeInOut,
      tween: Tween<Offset>(
        begin: Offset(0, 0),
        end: finalOffset,
      ),
      duration: AppConstants.cardDistributionAnimationDuration,
      builder: (_, Offset offset, Widget child) {
        final dy = finalOffset.dy == 0 ? 0.01 : finalOffset.dy;
        double offsetPercentageDone = (offset.dy / dy);
        double scale = 1.2 + offsetPercentageDone * (0.50 - 1.2);
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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showDistributionVn,
      key: _globalKey,
      builder: (_, showDistribution, __) {
        return showDistribution
            ? _animatingWidget(context)
            : const SizedBox.shrink();
      },
    );
  }
}
