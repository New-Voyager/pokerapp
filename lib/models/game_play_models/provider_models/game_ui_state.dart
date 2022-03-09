import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/src/provider.dart';
import 'package:tuple/tuple.dart';

class GameUIState {
  // table key - we need this to calculate the exact dimension of the table image
  final GlobalKey tableKey = GlobalKey();

  final ValueNotifier<Size> tableSizeVn = ValueNotifier<Size>(null);
  Size holeCardsViewSize = Size(0, 0);
  Size cardSize;
  double cardsDisplacement;
  double cardsSizeRatio;
  Rect centerViewRect;
  Offset tableGlobalTopLeft;
  Rect playerOnTableRect;
  Rect tableRect;
  Rect playerOnTableRectRelativeBoard;
  Rect tableRectRelativeToBoard;
  // table base height is 10% of the total table height
  double _tableBaseHeight = 1;

  final GlobalKey boardKey = GlobalKey();
  final GlobalKey playerOnTableKey = GlobalKey();
  final ValueNotifier<Offset> playerOnTablePositionVn =
      ValueNotifier<Offset>(null);

  Size _playerOnTableSize;
  Size get playerOnTableSize => _playerOnTableSize;

  Map<int, Rect> cardEyes = Map<int, Rect>();

  void calculateTableSizePostFrame({bool force = false}) {
    if (!force && tableSizeVn.value != null) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (true) {
        final box = tableKey.currentContext.findRenderObject() as RenderBox;
        if (box.size.shortestSide != 0.0) {
          tableGlobalTopLeft = box.localToGlobal(Offset.zero);
          tableSizeVn.value = box.size;
          tableRect = Rect.fromLTWH(tableGlobalTopLeft.dx,
              tableGlobalTopLeft.dy, box.size.width, box.size.height);
          _tableBaseHeight = tableRect.height * 0.10;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 10));
      }
    });
  }

  void calculateCardSize(BuildContext context, GameState gameState,
      int cardsLength, bool isCardVisible) {
    if (cardsLength == 2) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 5;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.25;
      }
    } else if (cardsLength == 3) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 8;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.17;
      }
    } else if (cardsLength == 4) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 12;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.14;
      }
    } else if (cardsLength == 5) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 15;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.12;
      }
    } else if (cardsLength == 6) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 20;
      if (Screen.isLargeScreen) {
        cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width * 0.1;
      }
    }

    if (!isCardVisible) {
      if (cardsLength == 2) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 1.1;
        } else {
          cardsDisplacement = cardsDisplacement * 1.1;
        }
      } else if (cardsLength == 3) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 1.2;
        } else {
          cardsDisplacement = cardsDisplacement * 1.2;
        }
      } else if (cardsLength == 4) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 1.1;
        } else {
          cardsDisplacement = cardsDisplacement * 1.3;
        }
      } else if (cardsLength == 5) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 0.9;
        } else {
          cardsDisplacement = cardsDisplacement * 1.5;
        }
      } else if (cardsLength == 6) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 0.9;
        } else {
          cardsDisplacement = cardsDisplacement * 1.8;
        }
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

  Size getPlayersOnTableSize(Size tableSize) {
    double width = tableSize.width;
    double height =
        tableSize.height + NamePlateWidgetParent.namePlateSize.height * 1.5;
    if (Screen.isLargeScreen) {
      width = tableSize.width + NamePlateWidgetParent.namePlateSize.width;
    }
    return Size(width, height);
  }

  // rectangle relative to board co-ordinates
  Rect getTableRect() {
    if (tableRectRelativeToBoard != null) {
      return tableRectRelativeToBoard;
    }
    final box = this.boardKey.currentContext.findRenderObject() as RenderBox;

    Offset topLeft = box.globalToLocal(Offset(tableRect.left, tableRect.top));
    tableRectRelativeToBoard = Rect.fromLTWH(
        topLeft.dx, topLeft.dy, tableRect.width, tableRect.height);
    return tableRectRelativeToBoard;
  }

  // rectangle relative to board co-ordinates
  Rect getPlayersOnTableRect() {
    if (playerOnTableRectRelativeBoard != null) {
      return playerOnTableRectRelativeBoard;
    }

    final box = this.boardKey.currentContext.findRenderObject() as RenderBox;

    Offset topLeft = box.globalToLocal(Offset(tableRect.left, tableRect.top));
    final tmp = Rect.fromLTWH(
        topLeft.dx, topLeft.dy, tableRect.width, tableRect.height);
    final tmp2 = tmp.inflate(NamePlateWidgetParent.namePlateSize.height);
    playerOnTableRectRelativeBoard = Rect.fromLTWH(
        tmp2.left, tmp2.top, tmp2.width, tmp2.height - _tableBaseHeight);
    return playerOnTableRectRelativeBoard;
  }

  void calculatePlayersOnTablePositionPostFrame() {
    if (playerOnTablePositionVn.value != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (playerOnTableKey.currentContext == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }

      final box =
          playerOnTableKey.currentContext.findRenderObject() as RenderBox;

      _playerOnTableSize = box.size;
      final tempPos = box.localToGlobal(Offset.zero);

      final box1 = boardKey.currentContext.findRenderObject() as RenderBox;
      final playerOnTablePos = box1.globalToLocal(tempPos);

      playerOnTablePositionVn.value = playerOnTablePos;
      playerOnTableRect = Rect.fromLTWH(
          tempPos.dx, tempPos.dy, box.size.width, box.size.height);

      print(
        'calculatePlayersOnTablePositionPostFrame: ${playerOnTablePositionVn.value} rect: ${playerOnTableRect}',
      );
    });
  }

  double get tableBaseHeight {
    return _tableBaseHeight;
  }

  Tuple2<Offset, Size> getCenterViewRect() {
    final namePlateSize = NamePlateWidgetParent.namePlateSize;

    final left = playerOnTableRect.left + namePlateSize.width;
    final top = playerOnTableRect.top + namePlateSize.height;

    final centerViewSize = Size(
      playerOnTableSize.width - namePlateSize.width * 2.0,
      playerOnTableSize.height - namePlateSize.height * 2.0,
    );

    final deflate = Screen.isLargeScreen ? namePlateSize.height / 2 : 10.0;
    final deflateRect = deflate + 10;

    final rect = Rect.fromLTWH(
      left,
      top,
      centerViewSize.width,
      centerViewSize.height,
    ).deflate(deflateRect);

    return Tuple2<Offset, Size>(
      Offset(rect.left, playerOnTableRect.top + namePlateSize.height),
      rect.size,
    );
  }
}
