import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'hole_card_view.dart';

class PlayerHoleCardView extends StatelessWidget {
  final CardObject card;
  final bool dim;
  final bool isCardVisible;
  final bool marked;
  final Function onMarkTapCallback;

  PlayerHoleCardView({
    @required this.card,
    this.onMarkTapCallback,
    this.marked = false,
    this.dim = false,
    this.isCardVisible = false,
  });

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
    BuildContext context,
  ) {
    final gameState = GameState.getState(context);
<<<<<<< HEAD
    final cardAsset = SvgPicture.memory(gameState.assets
        .getHoleCard(card.cardNum, color: gameState.colorCards));
=======
    final cardAsset =
        SvgPicture.memory(gameState.assets.getHoleCard(card.cardNum, 
            color: gameState.colorCards));
>>>>>>> fb22eef6693311595ee3915f4ee929db1d8a0acc
    //final cardAsset = SvgPicture.asset('assets/images/card_face/${card.cardNum}.svg');
    return Stack(fit: StackFit.expand, children: [
      cardAsset,
      /* visible marker */
      Positioned(
        top: 50,
        left: 5,
        child: marked
            ? Icon(
                Icons.visibility,
                color: Colors.green,
              )
            : const SizedBox.shrink(),
      ),

      /* tap widget */
      Positioned(
        top: 0,
        left: 0,
        bottom: 50.pw,
        width: 30.pw,
        child: GestureDetector(
          onTap: onMarkTapCallback,
        ),
      )
    ]);
    //return Image.asset('assets/images/card_face/${card.cardNum}.png');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final cardBackBytes = gameState.assets.getHoleCardBack();
    if (cardBackBytes == null) {
      return Container();
    }

    return HoleCardWidget(
      backCardBytes: cardBackBytes,
      highlight: false,
      card: card,
      dim: dim,
      shadow: true,
      isCardVisible: isCardVisible,
      cardBuilder: _buildCardUI,
      cardFace: isCardVisible ? CardFace.FRONT : CardFace.BACK,
    );
  }
}
