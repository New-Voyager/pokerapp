import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';

const String _heart = '♥';
const String _spade = '♠';
const String _diamond = '♦';
const String _club = '♣';

const Map<int, String> _cardValues = {
  1: '2$_spade',
  2: '2$_heart',
  4: '2$_diamond',
  8: '2$_club',
  17: '3$_spade',
  18: '3$_heart️',
  20: '3$_diamond',
  24: '3$_club',
  40: '4$_club',
  33: '4$_spade',
  34: '4$_heart️',
  36: '4$_diamond',
  50: '5$_heart️',
  52: '5$_diamond',
  56: '5$_club',
  49: '5$_spade',
  65: '6$_spade',
  66: '6$_heart️',
  68: '6$_diamond',
  72: '6$_club',
  81: '7$_spade',
  82: '7$_heart️',
  84: '7$_diamond',
  88: '7$_club',
  97: '8$_spade',
  98: '8$_heart️',
  100: '8$_diamond',
  104: '8$_club',
  113: '9$_spade',
  114: '9$_heart️',
  116: '9$_diamond',
  120: '9$_club',
  130: 'T$_heart️',
  132: 'T$_diamond',
  136: 'T$_club',
  129: 'T$_spade',
  152: 'J$_club',
  145: 'J$_spade',
  146: 'J$_heart️',
  148: 'J$_diamond',
  161: 'Q$_spade',
  162: 'Q$_heart️',
  164: 'Q$_diamond',
  168: 'Q$_club',
  177: 'K$_spade',
  178: 'K$_heart️',
  180: 'K$_diamond',
  184: 'K$_club',
  200: 'A$_club',
  193: 'A$_spade',
  194: 'A$_heart️',
  196: 'A$_diamond',
};

class CardHelper {
  CardHelper._();

  static int getCardNumber(CardObject card) {
    String cardValue = '${card.label}${card.suit}';
    int _key = -1;

    _cardValues.forEach((key, value) {
      if (cardValue == value) _key = key;
    });

    assert(_key != -1);
    return _key;
  }

  /* following util methods deals with the raw card values and data */
  static String _getCardFromNumber(int number) => _cardValues[number];

  static Uint8List _int64LittleEndianBytes(int v) =>
      Uint8List(8)..buffer.asByteData().setInt64(0, v, Endian.little);

  static List<int> getRawCardNumbers(String number) {
    int n = int.parse(number);
    List<int> tmp = _int64LittleEndianBytes(n);

    List<int> cards = [];
    for (int t in tmp) if (t != 0) cards.add(t);

    return cards;
  }

  /* card color util */
  static Color _getColor(String suit) {
    switch (suit) {
      case AppConstants.blackSpade:
        return Colors.black;
      case AppConstants.redHeart:
      case AppConstants.redHeart2:
        return Colors.red;
      case AppConstants.blackClub:
        return Colors.black;
      case AppConstants.redDiamond:
        return Colors.red;
    }

    return Colors.black;
  }

  static String getSuitImage(String suit) {
    switch (suit) {
      case AppConstants.blackSpade:
        return 'assets/images/cards/spade.png';
      case AppConstants.redHeart:
      case AppConstants.redHeart2:
        return 'assets/images/cards/heart.png';
      case AppConstants.blackClub:
        return 'assets/images/cards/club.png';
      case AppConstants.redDiamond:
        return 'assets/images/cards/diamond.png';
    }

    return 'assets/images/cards/spade.png';
  }

  /* methods that returns Card Objects */

  static CardObject _getCardFromCardValues(String card) {
    String label = card[0];
    String suit = card[1];
    if (suit == AppConstants.redHeart || suit == AppConstants.redHeart2) {
      suit = AppConstants.redHeart;
    }

    return CardObject(
      suit: suit,
      label: label,
      color: _getColor(suit),
    );
  }

  /* the following three methods are made public */

  static CardObject getCard(int n) {
    if (n == 0) {
      return CardObject.emptyCard();
    }
    return _getCardFromCardValues(_getCardFromNumber(n));
  }

  static List<CardObject> getCards(String s) => getRawCardNumbers(s)
      .map<CardObject>((int c) => _getCardFromCardValues(_getCardFromNumber(c)))
      .toList();

  /* get raw card number from "label:suit" string */
  static int getRawCardNumber(String s) {
    int rawCardNumber;

    _cardValues.forEach((rawNo, value) {
      if (value == s) rawCardNumber = rawNo;
    });

    assert(rawCardNumber != null);
    return rawCardNumber;
  }
}
