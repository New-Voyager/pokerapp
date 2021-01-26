import 'package:flutter/material.dart';

enum BoardLayout { HORIZONTAL, VERTICAL }

class BoardObject extends ChangeNotifier {
  BoardLayout _boardLayout = BoardLayout.HORIZONTAL;
  get boardLayout => _boardLayout;
  bool get horizontal => _boardLayout == BoardLayout.HORIZONTAL;
  bool get vertical => _boardLayout == BoardLayout.VERTICAL;
}
