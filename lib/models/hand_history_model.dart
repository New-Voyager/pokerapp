import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/formatter.dart';

class Winner {
  String name;
  int id;
  List<int> cards;
  double amount;
  bool showCards;
  bool low;

  static Winner fromJson(int noCards, dynamic jsonData,
      {bool low = false, bool showCards = false}) {
    Winner winner = new Winner();
    winner.id = int.parse(jsonData['playerId'].toString());
    winner.name = winner.id.toString();
    if (showCards) {
      winner.showCards = true;
      winner.cards = List<int>.from(jsonData['cards']);
    } else {
      winner.cards = new List<int>();
      for (int i = 0; i < noCards; i++) {
        winner.cards.add(0);
      }
    }
    winner.amount = double.parse(jsonData['amount'].toString());
    return winner;
  }
}

class HandHistoryItem {
  int handNum;
  List<Winner> winners;
  List<Winner> lowWinners;
  int noCards;
  List<int> community;
  List<int> community1;
  String handTime;
}

class HandHistoryListModel extends ChangeNotifier {
  String gameCode;
  bool isOwner;
  dynamic jsonData;
  List<HandHistoryItem> history;
  HandHistoryListModel(this.gameCode, this.isOwner);

  void load() async {
    history = new List<HandHistoryItem>();
    final hands = jsonData['hands'];
    for (final hand in hands) {
      HandHistoryItem item = new HandHistoryItem();
      item.handNum = int.parse(hand['handNum'].toString());
      Map<String, dynamic> summary = json.decode(hand['summary']);
      item.noCards = int.parse(summary['noCards'].toString());
      item.handTime = DataFormatter.minuteFormat(int.parse(hand['handTime'].toString()));

      dynamic boardCards = summary['boardCards'];

      if (boardCards != null) {
        if (boardCards.length > 1) {
          item.community1 = List<int>.from(boardCards[1]);
        }

        if (boardCards.length >= 1) {
          item.community = List<int>.from(boardCards[0]);
        }
      }
      bool showCards = false;
      String wonAt = hand['wonAt'].toString();
      if (wonAt == 'SHOW_DOWN') {
        showCards = true;
      }

      if (wonAt == 'FLOP') {
        item.community = item.community.sublist(0, 3);
      } else if (wonAt == 'TURN') {
        item.community = item.community.sublist(0, 4);
      } else if (wonAt == 'RIVER') {
        item.community = item.community.sublist(0, 5);
      }

      List hiWinners = summary['hiWinners'] as List;
      item.winners = new List<Winner>();
      for (final winnnerData in hiWinners) {
        item.winners.add(
            Winner.fromJson(item.noCards, winnnerData, showCards: showCards));
        item.winners.add(
            Winner.fromJson(item.noCards, winnnerData, showCards: showCards));
        item.winners.add(
            Winner.fromJson(item.noCards, winnnerData, showCards: showCards));
      }
      history.add(item);
    }
  }
}
