import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokerapp/utils/formatter.dart';

class Winner {
  String name;
  int id;
  List<int> cards;
  double amount;
  bool showCards;
  bool low;

  static Winner fromJson(
      HandHistoryListModel item, int noCards, dynamic jsonData,
      {bool low = false, bool showCards = false}) {
    Winner winner = new Winner();
    winner.name = 'Unknown';
    winner.id = int.parse(jsonData['playerId'].toString());
    if (jsonData['playerName'] != null) {
      winner.name = jsonData['playerName'] as String;
    } else {
      if (item != null) {
        winner.name = item.playerName(winner.id);
      }
    }
    winner.showCards = showCards;
    winner.low = low;
    if (showCards) {
      winner.showCards = true;
      winner.cards = List<int>.from(jsonData['cards']);
    } else {
      winner.cards = [];
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
  bool authorized;
  double totalPot;
  List<int> headsupPlayers;
  Map<int, double> playersReceived;
}

class HandHistoryListModel extends ChangeNotifier {
  String gameCode;
  bool isOwner;
  dynamic jsonData;
  List<HandHistoryItem> allHands;
  List<HandHistoryItem> winningHands;

  HandHistoryListModel(this.gameCode, this.isOwner);
  Map<int, String> players = new Map<int, String>();

  void getHands(List handsData, List<HandHistoryItem> hands) {
    for (final hand in handsData) {
      HandHistoryItem item = new HandHistoryItem();
      item.handNum = int.parse(hand['handNum'].toString());
      Map<String, dynamic> summary;
      if (hand['summary'] is String) {
        summary = json.decode(hand['summary']);
      } else if (hand['summary'] != null) {
        summary = hand['summary'];
      }
      item.noCards = int.parse(summary['noCards'].toString());
      item.handTime = DataFormatter.getTimeInHHMMFormat(
          int.parse(hand['handTime'].toString()));
      item.authorized = hand['authorized'];
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
      item.winners = [];
      for (final winnnerData in hiWinners) {
        item.winners.add(Winner.fromJson(this, item.noCards, winnnerData,
            showCards: showCards));
      }
      hands.add(item);
    }
  }

  void load() async {
    allHands = [];
    winningHands = [];

    final players = jsonData['players'] as List;
    if (players != null) {
      for (final playerData in players) {
        int id = int.parse(playerData['id'].toString());
        this.players[id] = playerData['name'].toString();
      }
    }

    this.getHands(jsonData['allHands'], this.allHands);
    this.getHands(jsonData['winningHands'], this.winningHands);
  }

  String playerName(int id) {
    if (this.players.containsKey(id)) {
      return this.players[id];
    } else {
      return '$id';
    }
  }

  List<HandHistoryItem> getAllHands() {
    return this.allHands;
  }

  List<HandHistoryItem> getWinningHands() {
    return this.winningHands;
  }

  List<HandHistoryItem> getMyHands() {
    // hands this player is authorized to see
    return this
        .allHands
        .where((element) => element.authorized ?? false)
        .toList();
  }

  void sort() {
    this.allHands.sort((a, b) => b.handNum.compareTo(a.handNum));
  }
}
