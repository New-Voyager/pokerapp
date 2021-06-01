import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';
import 'package:pokerapp/resources/app_assets.dart';

final cardBackImage = new Image(
  image: AssetImage('assets/images/card_back/set2/Asset 6.png'),
);

class CardView extends StatelessWidget {
  final CardObject card;

  CardView({
    @required this.card,
  });

  Widget _buildCardUIStack(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
  ) {
    debugPrint('label: ${card.label} card suit: ${card.suit} ${card.color}');
    return Stack(
      //mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, 0),
              child: Text(
                card.label == 'T' ? '10' : card.label ?? 'X',
                style: TextStyle(
                  color: card.color,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppAssets.fontFamilyDomine,
                ),
                textAlign: TextAlign.center,
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            card.suit,
            style: TextStyle(
              color: card.color,
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
              fontFamily: AppAssets.fontFamilyLato,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 8,
          child: FittedBox(
            child: Text(
              card.label == 'T' ? '10' : card.label ?? 'X',
              style: TextStyle(
                color: card.color,
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
                fontFamily: AppAssets.fontFamilyDomine,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: FittedBox(
            child: Text(
              card.suit,
              style: TextStyle(
                color: card.color,
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
                fontFamily: AppAssets.fontFamilyLato,
              ),
              textAlign: TextAlign.center,
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
      highlight: card.highlight,
      isCardVisible: true,
      cardBuilder: _buildCardUI,
      roundRadius: 2.5,
      cardFace: card.cardFace,
    );
  }
}
