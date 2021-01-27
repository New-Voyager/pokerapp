import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:provider/provider.dart';

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
    return Consumer2<CardDistributionModel, BoardAttributesObject>(
      builder: (_, model, boardAttrObj, __) => model.seatNo == null
          ? const SizedBox.shrink()
          : TweenAnimationBuilder<Offset>(
              key: UniqueKey(),
              child: _buildCardBack(),
              curve: Curves.easeInQuad,
              tween: Tween<Offset>(
                begin: Offset(0, 0),
                end: boardAttrObj
                    .cardDistributionAnimationOffsetMapping[model.seatNo],
              ),
              duration: AppConstants.cardDistributionAnimationDuration,
              builder: (_, Offset offset, Widget child) {
                double offsetPercentageDone = (offset.dy /
                    boardAttrObj
                        .cardDistributionAnimationOffsetMapping[model.seatNo]
                        .dy);

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
