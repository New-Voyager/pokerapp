import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/cards/pulsating_card_container.dart';
import 'package:provider/provider.dart';

// todo: turn off the pulsating highlight if you don't like it ;-)
bool keepPulsatingHighlight = true;

class CardBuilderWidget extends StatelessWidget {
  final CardObject card;
  final bool isCardVisible;
  final Function cardBuilder;
  final bool dim;
  final bool highlight;
  final bool shadow;
  final double roundRadius;
  final CardFace cardFace;
  final Uint8List backCardBytes;
  final bool doubleBoard;

  CardBuilderWidget({
    @required this.card,
    @required this.dim,
    @required this.highlight,
    @required this.isCardVisible,
    @required this.backCardBytes,
    @required
        Widget this.cardBuilder(TextStyle _, TextStyle __, BuildContext ___),
    this.shadow = false,
    this.roundRadius = 5.0,
    this.doubleBoard = false,
    this.cardFace,
  }) : assert(card != null &&
            dim != null &&
            isCardVisible != null &&
            cardBuilder != null);

  /* this method returns the correct RATIO for a particular CARD TYPE */
  static double getCardRatioFromCardType(
      CardType cardType, BuildContext context,
      {bool doubleBoard = false}) {
    switch (cardType) {
      case CardType.CommunityCard:
        /* if we have a card type of community cards, then we must be on the 
          game screen, thus we can safely call BoardAttributesObject */
        final bao = context.read<BoardAttributesObject>();
        if (doubleBoard) {
          return bao.centerDoubleBoardScale;
        } else {
          return bao.centerBoardScale;
        }
        break;
      //return 1.2 * bao.boardScale;

      case CardType.HoleCard:
        final bao = context.read<BoardAttributesObject>();
        return bao.holeCardSizeRatio;

      case CardType.PlayerCard:
        return 0.90;

      case CardType.HandLogOrHandHistoryCard:
        return 0.80;

      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle cardTextStyle = AppStylesNew.cardTextStyle.copyWith(fontSize: 12);
    TextStyle suitTextStyle = AppStylesNew.cardTextStyle.copyWith(fontSize: 12);

    cardTextStyle = AppStylesNew.cardTextStyle.copyWith(
      color: card.color,
      fontSize: 12,
    );

    suitTextStyle = AppStylesNew.cardTextStyle.copyWith(
      color: card.color,
      fontSize: 8,
    );

    bool highlight = card.highlight ?? false;

    cardTextStyle = AppStylesNew.cardTextStyle.copyWith(
      color: card.color,
    );

    suitTextStyle = AppStylesNew.cardTextStyle.copyWith(
      color: card.color,
    );

    double _ratio = getCardRatioFromCardType(
      card.cardType,
      context,
      doubleBoard: this.doubleBoard,
    );

    // IMP: we ignore "dim" value if "highlight" is true
    bool toDim = dim;
    if (highlight || card.reveal) {
      toDim = false;
    }

    // log('Card ${CardConvUtils.getString(card.cardNum)} shadow: $shadow reveal: ${card.reveal} dimboard: ${card.dimBoard} highlight : $highlight, dim: ${toDim} type: ${card.cardType.toString()}');
    BoxDecoration fgDecoration;
    if (toDim) {
      fgDecoration = BoxDecoration(
        color: Colors.black45,
        backgroundBlendMode: BlendMode.darken,
      );
    }
    if (card.dimBoard) {
      fgDecoration = BoxDecoration(
        color: Color(0x99000000),
        backgroundBlendMode: BlendMode.darken,
      );
    }

    if (card.reveal) {
      fgDecoration = null;
    }

    final double height = AppDimensions.cardHeight * _ratio;
    final double width = AppDimensions.cardWidth * _ratio;

    Widget cardWidget = Container(
      height: height,
      width: width,
      foregroundDecoration: fgDecoration,
      decoration: BoxDecoration(
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 20.0,
                  spreadRadius: 10.0,
                ),
              ]
            : [],
        borderRadius: BorderRadius.all(
          Radius.circular(roundRadius),
        ),
        color: Colors.white,
      ),
      child: _buildCardBackSide(cardTextStyle, suitTextStyle, context),
    );

    if (highlight && keepPulsatingHighlight)
      return PulsatingCardContainer(
        child: cardWidget,
        height: height,
        width: width,
        color: Colors.green.withOpacity(0.80),
        animationUpToWidth: 4.0,
      );

    return cardWidget;
  }

  _buildCardBackSide(
      TextStyle cardTextStyle, TextStyle suitTextStyle, BuildContext context) {
    if (cardFace == CardFace.FRONT) {
      return isCardVisible
          ? cardBuilder(cardTextStyle, suitTextStyle, context)
          : Container();
    }

    // final gameState = GameState.getState(context);
    // final image = Image.memory(gameState.assets.getHoleCardBack());
    Image cardBackImage;
    if (this.backCardBytes != null) {
      cardBackImage = Image.memory(this.backCardBytes);
    } else {
      cardBackImage = Image.asset('assets/images/card_back/set2/Asset 8.png');
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(roundRadius)),
      child: cardBackImage,
    );
  }
}
