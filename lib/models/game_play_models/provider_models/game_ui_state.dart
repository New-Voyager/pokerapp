import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/utils.dart';

class GameUIState {
  // table key - we need this to calculate the exact dimension of the table image
  final GlobalKey tableKey = GlobalKey();

  final ValueNotifier<Size> tableSizeVn = ValueNotifier<Size>(null);
  Size holeCardsViewSize = Size(0, 0);
  Size cardSize;
  double cardsDisplacement;
  double cardsSizeRatio;
  Rect _centerViewRect;
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
  double tableWidthFactor = 1.0;
  Map<SeatPos, Offset> seatPosToOffsetMap = {};
  Map<int, Rect> cardEyes = Map<int, Rect>();

  void init() {
    NamePlateWidgetParent.setWidth(80);
    if (Screen.diagonalInches >= 7 && Screen.diagonalInches < 9) {
      tableWidthFactor = 0.70;
    } else if (Screen.diagonalInches >= 9) {
      NamePlateWidgetParent.setWidth(100);
      tableWidthFactor = 0.70;
    }
  }

  void initSeatPos() {
    final pot = this.playerOnTableRect;
    final table = this.tableRect;

    double widthGap = 0;
    double heightGap = 0;
    double topLeftLeft = 0;

    if (pot != null) {
      widthGap = table.left - pot.left;
      heightGap = table.top - pot.top;
    }

    double left = 0;
    double top = 0;
    double namePlateWidth = NamePlateWidgetParent.namePlateSize.width;
    double namePlateHeight = NamePlateWidgetParent.namePlateSize.height;

    // top left
    left = widthGap;
    top = heightGap / 2;
    topLeftLeft = left;
    seatPosToOffsetMap[SeatPos.topLeft] = Offset(left, top);

    // top right
    left = topLeftLeft + table.width - namePlateWidth;
    top = heightGap / 2;
    seatPosToOffsetMap[SeatPos.topRight] = Offset(left, top);

    // middle left
    left = 0;
    top = heightGap + (table.height - namePlateHeight) / 3;
    seatPosToOffsetMap[SeatPos.middleLeft] = Offset(left, top);

    // top center 1
    double remainingWidth = seatPosToOffsetMap[SeatPos.topRight].dx -
        (seatPosToOffsetMap[SeatPos.topLeft].dx + namePlateWidth);
    remainingWidth = (remainingWidth - (2 * namePlateWidth));
    double gap = remainingWidth / 3;

    double topCenter1Left =
        seatPosToOffsetMap[SeatPos.topLeft].dx + namePlateWidth + gap;
    top = (heightGap - namePlateHeight);
    seatPosToOffsetMap[SeatPos.topCenter1] = Offset(topCenter1Left, top);

    // top center 2
    double topCenter2Left =
        seatPosToOffsetMap[SeatPos.topCenter1].dx + namePlateWidth + gap;
    seatPosToOffsetMap[SeatPos.topCenter2] = Offset(topCenter2Left, top);

    // top center
    top = (heightGap - namePlateHeight);
    seatPosToOffsetMap[SeatPos.topCenter] = Offset(topCenter2Left, top);

    // middle right
    left = pot.width - namePlateWidth;
    top = heightGap + (table.height - namePlateHeight) / 3;
    seatPosToOffsetMap[SeatPos.middleRight] = Offset(left, top);

    // bottom left
    left = widthGap;
    top = pot.height - namePlateHeight - heightGap / 4;
    seatPosToOffsetMap[SeatPos.bottomLeft] = Offset(left, top);

    // bottom center
    left = (pot.width / 2) - namePlateWidth / 2;
    top = pot.height - namePlateHeight;
    seatPosToOffsetMap[SeatPos.bottomCenter] = Offset(left, top);

    // bottom right
    left = topLeftLeft + table.width - namePlateWidth;
    top = pot.height - namePlateHeight - heightGap / 4;
    seatPosToOffsetMap[SeatPos.bottomRight] = Offset(left, top);
  }

  double _centerViewDeflationBy([f = 0.10]) {
    return 10.0;
  }

  void calculateCenterViewRect() {
    if (_centerViewRect != null) {
      return;
    }

    double namePlateWidth = NamePlateWidgetParent.namePlateSize.width;
    double namePlateHeight = NamePlateWidgetParent.namePlateSize.height;

    double left, top, right, bottom, topTop, bottomTop;
    topTop = seatPosToOffsetMap[SeatPos.topCenter].dy + namePlateHeight;
    bottomTop = seatPosToOffsetMap[SeatPos.bottomCenter].dy;

    left = seatPosToOffsetMap[SeatPos.topLeft].dx + namePlateWidth;
    top = seatPosToOffsetMap[SeatPos.topLeft].dy + namePlateHeight;
    bottom = seatPosToOffsetMap[SeatPos.bottomRight].dy;
    right = seatPosToOffsetMap[SeatPos.bottomRight].dx;

    final boardBox = boardKey.currentContext.findRenderObject() as RenderBox;
    final playerOnTableBox =
        playerOnTableKey.currentContext.findRenderObject() as RenderBox;

    Offset topLeftGlobal = playerOnTableBox.localToGlobal(Offset(left, top));
    Offset bottomRightGlobal = playerOnTableBox.localToGlobal(
      Offset(right, bottom),
    );
    Offset topTopGlobal = playerOnTableBox.localToGlobal(Offset(0.0, topTop));
    Offset bottomTopGlobal = playerOnTableBox.localToGlobal(
      Offset(0.0, bottomTop),
    );

    Offset topLeft = boardBox.globalToLocal(topLeftGlobal);
    Offset bottomRight = boardBox.globalToLocal(bottomRightGlobal);

    // topTopLocal is Top player's bottom position
    Offset topTopLocal = boardBox.globalToLocal(topTopGlobal);
    Offset bottomTopLocal = boardBox.globalToLocal(bottomTopGlobal);

    final centerTopGap = topLeft.dy - topTopLocal.dy;
    final centerBottomGap = bottomTopLocal.dy - bottomRight.dy;

    // to make the bottom and top gap uniform
    final extraBottomGap = centerTopGap - centerBottomGap;

    final rect = Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      bottomRight.dx - topLeft.dx,
      bottomRight.dy - topLeft.dy - extraBottomGap,
    );

    _centerViewRect = rect;
  }

  void calculateTableSizePostFrame({bool force = false}) {
    if (!force && tableSizeVn.value != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (true) {
        final box = tableKey.currentContext.findRenderObject() as RenderBox;
        if (box.size.shortestSide != 0.0) {
          tableGlobalTopLeft = box.localToGlobal(Offset.zero);
          tableSizeVn.value = box.size;
          tableRect = Rect.fromLTWH(
            tableGlobalTopLeft.dx,
            tableGlobalTopLeft.dy,
            box.size.width,
            box.size.height,
          );
          _tableBaseHeight = tableRect.height * 0.10;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 10));
      }
    });
  }

  void calculateCardSize(
    BuildContext context,
    GameState gameState,
    int cardsLength,
    bool isCardVisible,
  ) {
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

    var cardWidth = gameState.gameUIState.holeCardsViewSize.width -
        (cardsDisplacement * cardsLength);

    cardSize = Size(cardWidth, cardWidth * 38 / 30);
  }

  // rectangle relative to board co-ordinates
  Rect getTableRect() {
    if (tableRectRelativeToBoard != null) {
      return tableRectRelativeToBoard;
    }

    final box = this.boardKey.currentContext.findRenderObject() as RenderBox;

    Offset topLeft = box.globalToLocal(Offset(tableRect.left, tableRect.top));
    tableRectRelativeToBoard = Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      tableRect.width,
      tableRect.height,
    );
    return tableRectRelativeToBoard;
  }

  // rectangle relative to board co-ordinates
  Rect getPlayersOnTableRect() {
    if (playerOnTableRectRelativeBoard != null) {
      return playerOnTableRectRelativeBoard;
    }

    final box = this.boardKey.currentContext.findRenderObject() as RenderBox;
    final screenSize = Screen.size;
    Offset topLeft = box.globalToLocal(Offset(tableRect.left, tableRect.top));
    final tmp = Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      tableRect.width,
      tableRect.height,
    );
    Rect tmp2 = tmp.inflate(NamePlateWidgetParent.namePlateSize.height);
    double left = tmp2.left;
    double right = tmp2.right;
    if (tmp2.left < 0) {
      left = 0;
    }
    if (tmp2.right > screenSize.width) {
      right = screenSize.width;
    }
    tmp2 = Rect.fromLTWH(left, tmp2.top, right - left, tmp2.height);

    playerOnTableRectRelativeBoard = Rect.fromLTWH(
      tmp2.left,
      tmp2.top,
      tmp2.width,
      tmp2.height - _tableBaseHeight,
    );

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

      playerOnTableRect = Rect.fromLTWH(
        tempPos.dx,
        tempPos.dy,
        box.size.width,
        box.size.height,
      );

      getTableRect();
      getPlayersOnTableRect();
      initSeatPos();
      calculateCenterViewRect();
      playerOnTablePositionVn.value = playerOnTablePos;
    });
  }

  double get tableBaseHeight {
    return _tableBaseHeight;
  }

  Rect get centerViewRect {
    return _centerViewRect;
  }
}
