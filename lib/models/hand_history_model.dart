import 'package:flutter/cupertino.dart';

class HandHistoryListModel extends ChangeNotifier {
  String gameCode;
  bool isOwner;

  HandHistoryListModel(this.gameCode, this.isOwner);
}