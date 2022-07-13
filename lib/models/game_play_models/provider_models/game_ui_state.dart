import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/utils/utils.dart';
import 'dart:math' as math;

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
  Size prevSize;
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
  Map<SeatPos, Offset> seatPosCenterMap = {};
  Map<SeatPos, Offset> chipPotViewPos = Map<SeatPos, Offset>();
  Offset betBtnPos;

  Map<int, Rect> cardEyes = Map<int, Rect>();
  double chipAmountScale = 1.0;

  // hole card UI
  GlobalKey rearrangeKey = GlobalKey();
  Rect rearrangeRect;

  bool init(BuildContext context) {
    print('TableResize: GameUIState::init');

    if (prevSize == null) {
      prevSize = MediaQuery.of(context).size;
    } else {
      Size currentSize = MediaQuery.of(context).size;
      if (currentSize == prevSize) {
        // do nothing
        return false;
      }
      prevSize = currentSize;
    }

    NamePlateWidgetParent.setWidth(160);
    tableWidthFactor = 0.90;

    if (PlatformUtils.isWeb) {
      // web is same as 7inch screen
      tableWidthFactor = 0.60 * (prevSize.height / prevSize.width);
      double width = (prevSize.width * tableWidthFactor) / 4;
      log('GameUI: Nameplate width: $width');
      //NamePlateWidgetParent.setWidth(90);
      NamePlateWidgetParent.setWidth(width);
      chipAmountScale = 0.70;
    } else {
      if (Screen.diagonalInches < 7) {
        double width = (Screen.width) / 4.2;
        width = 105;
        NamePlateWidgetParent.setWidth(width);
        tableWidthFactor = 1.0;
        chipAmountScale = 0.90;
      }
      if (Screen.diagonalInches >= 7 && Screen.diagonalInches < 9) {
        tableWidthFactor = 0.70;
        chipAmountScale = 1.0;
      } else if (Screen.diagonalInches >= 9) {
        NamePlateWidgetParent.setWidth(110);
        tableWidthFactor = 0.70;
        chipAmountScale = 1.0;
      }
    }
    return true;
  }

  void initSeatPos({bool force = false}) {
    final pot = this.playerOnTableRect;
    final table = this.tableRect;

    double widthGap = 0;
    double heightGap = 0;
    double topLeftLeft = 0;

    double topRowAdjust = 0;
    if (pot != null) {
      widthGap = table.left - pot.left;
      heightGap = table.top - pot.top;
    }

    double left = 0;
    double top = 0;
    double namePlateWidth = NamePlateWidgetParent.namePlateSize.width;
    double namePlateHeight = NamePlateWidgetParent.namePlateSize.height;

    if (GameState.getState(boardKey.currentContext)
        .getBoardAttributes(boardKey.currentContext)
        .isOrientationHorizontal) {
      // top left
      left = widthGap - topRowAdjust;
      top = heightGap / 2;
      topLeftLeft = left;
      seatPosToOffsetMap[SeatPos.topLeft] = Offset(left, top);

      // top right
      left = (topLeftLeft + table.width + 2 * topRowAdjust) - namePlateWidth;
      top = heightGap / 2;
      seatPosToOffsetMap[SeatPos.topRight] = Offset(left, top);

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
      left = (pot.width / 2) - namePlateWidth / 2;
      seatPosToOffsetMap[SeatPos.topCenter] = Offset(left, top);

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

      double remainingHeight = seatPosToOffsetMap[SeatPos.bottomLeft].dy -
          (seatPosToOffsetMap[SeatPos.topLeft].dy + namePlateHeight);
      gap = (remainingHeight / 3.5);

      // middle left
      left = 0;
      top = seatPosToOffsetMap[SeatPos.topLeft].dy + namePlateHeight + gap;
      seatPosToOffsetMap[SeatPos.middleLeft] = Offset(left, top);

      // middle right
      left = pot.width - namePlateWidth;
      seatPosToOffsetMap[SeatPos.middleRight] = Offset(left, top);
    } else {
      // top left
      left = widthGap - topRowAdjust;
      top = heightGap * 3;
      topLeftLeft = left;
      seatPosToOffsetMap[SeatPos.topLeft] = Offset(left, top);

      // top right
      left = (topLeftLeft + table.width + 2 * topRowAdjust) - namePlateWidth;
      top = heightGap * 3;
      seatPosToOffsetMap[SeatPos.topRight] = Offset(left, top);

      // top center 1
      double remainingWidth = seatPosToOffsetMap[SeatPos.topRight].dx -
          (seatPosToOffsetMap[SeatPos.topLeft].dx + namePlateWidth);
      remainingWidth = (remainingWidth - (2 * namePlateWidth));
      double gap = remainingWidth / 3;

      double topCenter1Left = (pot.width / 2) - namePlateWidth * 1.5;
      top = (heightGap - namePlateHeight / 2);
      seatPosToOffsetMap[SeatPos.topCenter1] = Offset(topCenter1Left, top);

      // top center 2
      double topCenter2Left = (pot.width / 2) + namePlateWidth * 0.5;
      seatPosToOffsetMap[SeatPos.topCenter2] = Offset(topCenter2Left, top);

      // top center
      left = (pot.width / 2) - namePlateWidth / 2;
      seatPosToOffsetMap[SeatPos.topCenter] = Offset(left, top);

      // bottom left
      left = widthGap;
      top = pot.height - namePlateHeight - 2 * heightGap;
      seatPosToOffsetMap[SeatPos.bottomLeft] = Offset(left, top);

      // bottom center
      left = (pot.width / 2) - namePlateWidth / 2;
      top = pot.height - namePlateHeight;
      seatPosToOffsetMap[SeatPos.bottomCenter] = Offset(left, top);

      // bottom right
      left = topLeftLeft + table.width - namePlateWidth;
      top = pot.height - namePlateHeight - 2 * heightGap;
      seatPosToOffsetMap[SeatPos.bottomRight] = Offset(left, top);

      double remainingHeight = seatPosToOffsetMap[SeatPos.bottomLeft].dy -
          (seatPosToOffsetMap[SeatPos.topLeft].dy + namePlateHeight);
      gap = (remainingHeight / 3.5);

      // middle left
      left = 0;
      top =
          seatPosToOffsetMap[SeatPos.topLeft].dy + namePlateHeight + 1.5 * gap;
      seatPosToOffsetMap[SeatPos.middleLeft] = Offset(left, top);

      // middle right
      left = pot.width - namePlateWidth;
      seatPosToOffsetMap[SeatPos.middleRight] = Offset(left, top);
    }
  }

  Rect _deflatedRect({
    @required Rect rect,
    double factor = 1.0,
  }) {
    assert(0 <= factor && factor <= 1);

    final diagonal = math.sqrt(
      math.pow(rect.width, 2) + math.pow(rect.height, 2),
    );

    final gap = diagonal * (1 - factor);
    final deflateBy = gap / 2.0;

    return rect.deflate(deflateBy);
  }

  double _getDeflateFactor() {
    // todo: if needed, we can put factor here
    if (Screen.isLargeScreen) {
      return 0.90;
    }
    return 1.0;
  }

  void calculateCenterViewRect({bool force = false}) {
    if (!force && _centerViewRect != null) {
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
    right = seatPosToOffsetMap[SeatPos.topRight].dx;

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
    // final extraBottomGap = centerTopGap - centerBottomGap;
    final extraBottomGap = centerTopGap;

    double horizontalOffset = 0;
    double verticalOffsetFactor = 1;
    double topPosOffset = 0;
    final boardAttributes =
        GameState.getState(boardKey.currentContext).getBoardAttributes(null);
    if (!boardAttributes.isOrientationHorizontal) {
      horizontalOffset = namePlateWidth / 8;
      verticalOffsetFactor = 1.5;
      topPosOffset = namePlateHeight;
    }

    final rect = Rect.fromLTWH(
      topLeft.dx - horizontalOffset,
      topLeft.dy - topPosOffset,
      bottomRight.dx - topLeft.dx + horizontalOffset * 2,
      (bottomRight.dy - topLeft.dy - extraBottomGap) * verticalOffsetFactor,
    );

    _centerViewRect = _deflatedRect(rect: rect, factor: _getDeflateFactor());
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
    double adjust = 0;

    if (cardsLength == 2) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 3.8;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.25;
      }
    } else if (cardsLength == 3) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 5.5;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.17;
      }
    } else if (cardsLength == 4) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 7.5;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.14;
      }
    } else if (cardsLength == 5) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 10;
      if (Screen.isLargeScreen) {
        cardsDisplacement =
            gameState.gameUIState.holeCardsViewSize.width * 0.12;
      }
    } else if (cardsLength == 6) {
      cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width / 10;
      if (Screen.isLargeScreen) {
        cardsDisplacement = gameState.gameUIState.holeCardsViewSize.width * 0.1;
      }
    }

    if (!isCardVisible) {
      if (cardsLength == 2) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 1.1;
        } else {
          cardsDisplacement = cardsDisplacement * 1;
        }
      } else if (cardsLength == 3) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 1.2;
        } else {
          cardsDisplacement = cardsDisplacement * 1;
        }
      } else if (cardsLength == 4) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 1.1;
        } else {
          cardsDisplacement = cardsDisplacement * 1.1;
        }
      } else if (cardsLength == 5) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 0.9;
        } else {
          cardsDisplacement = cardsDisplacement * 1.2;
        }
      } else if (cardsLength == 6) {
        if (Screen.isLargeScreen) {
          cardsDisplacement = cardsDisplacement * 0.9;
        } else {
          cardsDisplacement = cardsDisplacement * 1.05;
        }
      }
    }
    if (cardsLength == 2) {
      adjust = 30;
    } else if (cardsLength == 4) {
      adjust = 20;
    } else if (cardsLength == 5) {
      adjust = 30;
    } else if (cardsLength == 6) {
      adjust = 0;
    }

    var cardWidth = (gameState.gameUIState.holeCardsViewSize.width - adjust) -
        (cardsDisplacement * (cardsLength - 1));

    //cardSize = Size(cardWidth, cardWidth * 38 / 30);
    cardSize = Size(cardWidth, cardWidth * 38 / 30);
  }

  // rectangle relative to board co-ordinates
  Rect getTableRect({bool force}) {
    if (!force && tableRectRelativeToBoard != null) {
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
  Rect getPlayersOnTableRect({bool force = false}) {
    if (!force && playerOnTableRectRelativeBoard != null) {
      return playerOnTableRectRelativeBoard;
    }

    log('Recalculating players on table rect');

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
      left = 4;
    }
    if (tmp2.right > screenSize.width) {
      right = screenSize.width - 4;
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

  void calculatePlayersOnTablePositionPostFrame({bool force = false}) {
    // log('TableResize: calculatePlayersOnTablePositionPostFrame');
    if (!force && playerOnTablePositionVn.value != null) return;
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

      getTableRect(force: force);
      getPlayersOnTableRect(force: force);
      initSeatPos(force: force);
      calculateCenterViewRect(force: force);
      playerOnTablePositionVn.value = playerOnTablePos;
      print(
          'TableResize: screenSize: ${prevSize} board: (${playerOnTableRect.width}x${playerOnTableRect.height}) tableSize: (${tableRect.width}x${tableRect.height}), centerView: (${_centerViewRect.width}x(${_centerViewRect.height}))');
    });
  }

  double get tableBaseHeight {
    return _tableBaseHeight;
  }

  Rect get centerViewRect {
    return _centerViewRect;
  }
}
