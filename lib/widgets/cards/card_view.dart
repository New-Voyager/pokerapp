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
    // final aclub =
    // Row (
    //   children: [
    //       Container(
    //             // decoration: BoxDecoration(
    //             //   shape: BoxShape.circle,
    //             //   color: optionItemModel.backGroundColor,
    //             // ),
    //             padding: EdgeInsets.all(5),
    //             child: Transform.scale(
    //               scale: 1.2,
    //               child: Image.asset(
    //               'assets/images/cards/aclub.png',
    //               // height: 40,
    //               // width: 20,
    //               //color: Colors.white,
    //             )),
    //           ),
    //   ]);
    // return aclub;

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
            child: Text(
              card.suit,
              style: TextStyle(
                color: card.color,
                fontSize: 24.0,
                fontWeight: FontWeight.w800,
                fontFamily: AppAssets.fontFamilyLiterata,
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
