import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:provider/src/provider.dart';

class GameUIState {
  // table key - we need this to calculate the exact dimension of the table image
  final GlobalKey tableKey = GlobalKey();

  final ValueNotifier<Size> tableSizeVn = ValueNotifier<Size>(null);
  Size holeCardsViewSize = Size(0, 0);
  Size cardSize;
  double cardsDisplacement;
  double cardsSizeRatio;

  Map<int, Rect> cardEyes = Map<int, Rect>();

  void calculateTableSizePostFrame({bool force = false}) {
    if (!force && tableSizeVn.value != null) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (true) {
        final box = tableKey.currentContext.findRenderObject() as RenderBox;
        if (box.size.shortestSide != 0.0) {
          tableSizeVn.value = box.size;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 10));
      }
    });
  }

  void calculateCardSize(
      BuildContext context, GameState gameState, int cardsLength) {
    int screenDiagonalSize =
        context.read<BoardAttributesObject>().screenDiagnolSize;

    if (cardsLength == 2) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 5;
      if (screenDiagonalSize >= 7) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.25;
      }
    } else if (cardsLength == 3) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 8;
      if (screenDiagonalSize >= 7) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.17;
      }
    } else if (cardsLength == 4) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 10;
      if (screenDiagonalSize >= 7) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.14;
      }
    } else if (cardsLength == 5) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 15;
      if (context.read<BoardAttributesObject>().screenDiagnolSize >= 7) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.12;
      }
    } else if (cardsLength == 6) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 20;
      if (screenDiagonalSize >= 7) {
        cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width * 0.1;
      }
    }

    // print(displacementValue);

    // double maxCardWidth = gameState.holeCardsViewSize.width / 1.6;
    // double cardWidth = (gameState.holeCardsViewSize.width / cards.length);
    // double overlapValue = gameState.holeCardsViewSize.width / (cards.length);
    // cardWidth += overlapValue;
    // if (cardWidth > maxCardWidth) {
    //   cardWidth = maxCardWidth;
    // }
    var cardWidth = gameState.gameUIState.holeCardsViewSize.width -
        (cardsDisplacement * cardsLength);
    cardSize = Size(cardWidth, cardWidth * 38 / 30);
  }
}
