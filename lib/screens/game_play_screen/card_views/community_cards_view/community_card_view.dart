/*
*
* community card view (SINGLE CARD)
*
* */
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/card_view.dart';

class CommunityCardView extends StatelessWidget {
  final CardObject card;

  CommunityCardView({
    Key key,
    @required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CardView cardView = CardView(
      card: card,
      grayOut: false,
      widthRatio: 1.5,
    );
    final Widget cardWidget = cardView.buildCardWidget(context);
    /* for visible cards, the smaller card size is shown to the left of user,
    * and the bigger size is shown as the community card */

    // String cardBackAsset = CardBackAssets.asset1_1;
    // TODO:  WAY TO GET THE CARD BACK ASSET FOR CURRENT SETTINGS
    // try {
    //   cardBackAsset =
    //       Provider.of<ValueNotifier<String>>(context, listen: false).value;
    // } catch (_) {}

    return Transform.scale(
      scale: 1.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          3.0,
        ),
        child: Container(
          height: cardView.height,
          width: cardView.width,
          child: cardWidget,
          // child: FlipCard(
          //   flipOnTouch: false,
          //   // key: cardKey,
          //   back: SizedBox(
          //     height: AppDimensions.cardHeight * 1.3,
          //     width: AppDimensions.cardWidth * 1.3,
          //     child: Image.asset(
          //       cardBackAsset,
          //       fit: BoxFit.fitHeight,
          //     ),
          //   ),
          //   front: cardWidget,
          // ),
        ),
      ),
    );
  }
}
