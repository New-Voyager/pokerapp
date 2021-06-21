import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:pokerapp/resources/app_constants.dart';

class RabbitState extends ChangeNotifier {
  bool get show => _show;
  bool _show;

  String _wonAt;
  List<int> _communityCards;
  int _handNo;
  List<int> _myCards;

  RabbitState() {
    _show = false;
  }

  void _clear() {
    _show = false;
    _wonAt = null;
    _communityCards = null;
    _handNo = null;
    _myCards = null;
    notifyListeners();
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void putResult(var result, {List<int> myCards = const []}) {
    if (result == null) _clear();

    result = result['handResult'];

    final handLog = result['handLog'];

    // if run it twice, do nothing
    final bool isRunItTwice = handLog['runItTwice'] as bool;

    if (isRunItTwice) return;

    final String wonAt = handLog['wonAt'];

    print('WONAT: $wonAt');

    // if wonAt is not FLOP or TURN, we dont proceed
    if (wonAt != AppConstants.FLOP && wonAt != AppConstants.TURN) return;

    // fill in the values
    _show = true;
    _wonAt = wonAt;
    _handNo = int.parse(result['handNum'].toString());
    _communityCards =
        result['boardCards'].map<int>((e) => int.parse(e.toString())).toList();
    _myCards = myCards;

    notifyListeners();
  }
}
