import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';

class CardView extends StatelessWidget {
  final CardObject card;
  final Uint8List cardBackBytes;
  final bool doubleBoard;
  CardView(
      {@required this.card,
      @required this.cardBackBytes,
      this.doubleBoard = false});

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
    BuildContext context,
  ) {
    String suitImage = CardHelper.getSuitImage(card.suit);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: FittedBox(
            child: Transform.translate(
                offset: Offset(0, -2),
                child: Transform.scale(
                    scale: 1.8,
                    child: Text(
                      card.label == 'T' ? '10' : card.label ?? 'X',
                      style: TextStyle(
                        color: card.color,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppAssets.fontFamilyLiterata,
                      ),
                      textAlign: TextAlign.center,
                    ))),
          ),
        ),
        SizedBox(height: 4.0),
        Expanded(
          flex: 6,
          child: FittedBox(
            child: Image.asset(
              suitImage,
              height: 20,
              width: 20,
              color: card.color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardBuilderWidget(
      card: card,
      dim: card.dim,
      backCardBytes: cardBackBytes,
      highlight: card.highlight,
      isCardVisible: true,
      cardBuilder: _buildCardUI,
      roundRadius: 2.5,
      cardFace: card.cardFace,
      doubleBoard: this.doubleBoard,
    );
  }
}
