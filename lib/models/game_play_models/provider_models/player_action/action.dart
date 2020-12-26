import 'package:flutter/foundation.dart';

class Action {
  String actionName;
  int actionValue;
  int minActionValue;

  Action({
    @required this.actionName,
    this.actionValue,
    this.minActionValue,
  });
}
