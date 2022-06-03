import 'package:flutter/material.dart';
import 'package:pokerapp/screens/layouts/delegates/poker_game_delegate.dart';
import 'package:pokerapp/screens/layouts/utils/app_breakpoints.dart';
import 'package:provider/provider.dart';

import 'horizontal_layout/horizontal_layout_delegate.dart';
import 'vertical_layout/vertical_layout_delegate.dart';

enum LayoutType { horizontal, vertical }

class LayoutHolder extends ChangeNotifier {
  void updateLayoutSize(Size size) {
    if (size.width <= AppBreakpoints.small) {
      if (_currentLayout != LayoutType.vertical) {
        notifyListeners();
        // AppLogger.log('LayoutHolder: updateLayoutSize: vertical');
      }
      _currentLayout = LayoutType.vertical;
    } else {
      if (_currentLayout != LayoutType.horizontal) {
        notifyListeners();
        // AppLogger.log('LayoutHolder: updateLayoutSize: horizontal');
      }
      _currentLayout = LayoutType.horizontal;
    }
  }

  LayoutType _currentLayout = LayoutType.horizontal;

  /// instantiate the delegates
  final _horizontalLayoutDelegate = HorizontalLayoutDelegate();
  final _verticalLayoutDelegate = VerticalLayoutDelegate();

  PokerLayoutDelegate get layoutDelegate {
    switch (_currentLayout) {
      case LayoutType.horizontal:
        return _horizontalLayoutDelegate;

      case LayoutType.vertical:
        return _verticalLayoutDelegate;
    }
  }

  static PokerLayoutDelegate getGameDelegate(BuildContext context) {
    return context.read<LayoutHolder>().layoutDelegate;
  }
}
