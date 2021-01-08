import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/card_back_assets.dart';

const cardHeight = AppDimensions.cardHeight * 3.0;
const cardWidth = AppDimensions.cardWidth * 3.0;

class CardBack {
  String cardBackImageAsset;
  double dx;
  double dy;

  double xTarget;
  double yTarget;

  CardBack({
    this.cardBackImageAsset = CardBackAssets.asset1_1,
    this.dx = 0,
    this.dy = 0,
    this.xTarget,
    this.yTarget,
  });

  Widget _buildCardBack() => Transform.translate(
        offset: Offset(
          dx,
          dy,
        ),
        child: Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 0.15,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: Image.asset(
            cardBackImageAsset,
          ),
        ),
      );

  Widget get widget => _buildCardBack();
}
