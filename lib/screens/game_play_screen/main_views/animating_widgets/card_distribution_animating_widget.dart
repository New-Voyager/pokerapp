import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:provider/provider.dart';

const offsetMapping = {
  1: Offset(0, 200.0),
  2: Offset(-130, 180),
  3: Offset(-150, 70),
  4: Offset(-150, -50),
  5: Offset(-50, -170),
  6: Offset(50, -170),
  7: Offset(150, -50),
  8: Offset(150, 70),
  9: Offset(130, 180),
};

class CardDistributionAnimatingWidget extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CardDistributionModel>(
      builder: (_, model, __) => model.seatNo == null
          ? const SizedBox.shrink()
          : TweenAnimationBuilder<Offset>(
              key: UniqueKey(),
              child: _buildCardBack(),
              curve: Curves.easeInQuad,
              tween: Tween<Offset>(
                begin: Offset(0, 0),
                end: offsetMapping[model.seatNo],
              ),
              duration: AppConstants.cardDistributionAnimationDuration,
              builder: (_, Offset offset, Widget child) {
                double offsetPercentageDone =
                    (offset.dy / offsetMapping[model.seatNo].dy);

                double scale = 1.5 + offsetPercentageDone * (0.50 - 1.5);

                return Transform.translate(
                  offset: offset,
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: offsetPercentageDone > 0.95 ? 0.0 : 1.0,
                      child: child,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
