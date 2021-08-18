import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:provider/provider.dart';

const kDisplacementConstant = 3.0;

class HiddenCardView extends StatelessWidget {
  HiddenCardView({
    this.noOfCards = 0,
  });

  final noOfCards;

  Widget _buildCardBack(BuildContext context) {
    final GameState gameState = GameState.getState(context);
    final cardBackImage = Image.memory(gameState.assets.getHoleCardBack());

    return Container(
        height: AppDimensions.cardHeight * 0.60,
        width: AppDimensions.cardWidth * 0.60,
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              spreadRadius: 2.0,
              blurRadius: 2.0,
            )
          ],
        ),
        child: cardBackImage);
  }

  @override
  Widget build(BuildContext context) {
    if (noOfCards == 0) return const SizedBox.shrink();

    double mid = (noOfCards ~/ 2) * 0.80;

    return Stack(
      children: List.generate(
        noOfCards,
        (i) => Transform.translate(
          offset: Offset(
            kDisplacementConstant * i,
            -i * 1.50,
          ),
          child: Transform.rotate(
            alignment: Alignment.bottomLeft,
            angle: (i - mid) * 0.20,
            child: _buildCardBack(context),
          ),
        ),
      ),
    );
  }
}
