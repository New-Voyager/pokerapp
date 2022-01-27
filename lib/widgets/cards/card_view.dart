import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';
import 'package:pokerapp/widgets/cards/pulsating_card_container.dart';

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
                ),
              ),
            ),
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

const double namePlateCardViewWidth = 35.0;
const double namePlateCardViewHeight = 48.0;

class NamePlateCardView extends StatelessWidget {
  final CardObject card;
  final Uint8List cardBackBytes;
  final bool doubleBoard;
  final int index;

  NamePlateCardView({
    @required this.card,
    @required this.cardBackBytes,
    this.doubleBoard = false,
    this.index = 1,
  });

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
    BuildContext context,
  ) {
    String suitImage = CardHelper.getSuitImage(this.card.suit);
    Widget cardWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // card suit and label
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    this.card.label == 'T' ? '10' : this.card.label ?? 'X',
                    style: TextStyle(
                      color: this.card.color,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppAssets.fontFamilyLato,
                    ),
                  ),
                  Image.asset(
                    suitImage,
                    height: 18,
                    width: 18,
                    color: this.card.color,
                  )
                ],
              ),
            ),
          ),
        ),

        // card label
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              child: Text(
                this.card.label == 'T' ? '10' : this.card.label ?? 'X',
                style: TextStyle(
                  height: 0.30,
                  color: this.card.color,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppAssets.fontFamilyLato,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );

    double opacity = 1.0;
    Color color = Colors.white;
    if (card.highlight) {
      color = Colors.white;
    } else {
      opacity = 0.30;
      //color = Colors.grey[700];
    }

    BoxDecoration fgDecoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        const BoxShadow(
          color: Colors.black54,
          blurRadius: 15.0,
        )
      ],
    );

    Widget child = Container(
      width: namePlateCardViewWidth,
      height: namePlateCardViewHeight,
      decoration: fgDecoration,
      child: card.highlight
          ? PulsatingCardContainer(
              height: namePlateCardViewHeight,
              width: namePlateCardViewWidth,
              child: cardWidget,
              color: Colors.green,
            )
          : cardWidget,
    );

    if (!card.highlight && !card.reveal) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.modulate),
        child: child,
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardUI(null, null, context);
  }
}
