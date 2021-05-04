import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';

const Map<int, String> _cardValues = {
  1: '2♠',
  2: '2❤',
  4: '2♦',
  8: '2♣',
  17: '3♠',
  18: '3❤',
  20: '3♦',
  24: '3♣',
  40: '4♣',
  33: '4♠',
  34: '4❤',
  36: '4♦',
  50: '5❤',
  52: '5♦',
  56: '5♣',
  49: '5♠',
  65: '6♠',
  66: '6❤',
  68: '6♦',
  72: '6♣',
  81: '7♠',
  82: '7❤',
  84: '7♦',
  88: '7♣',
  97: '8♠',
  98: '8❤',
  100: '8♦',
  104: '8♣',
  113: '9♠',
  114: '9❤',
  116: '9♦',
  120: '9♣',
  130: 'T❤',
  132: 'T♦',
  136: 'T♣',
  129: 'T♠',
  152: 'J♣',
  145: 'J♠',
  146: 'J❤',
  148: 'J♦',
  161: 'Q♠',
  162: 'Q❤',
  164: 'Q♦',
  168: 'Q♣',
  177: 'K♠',
  178: 'K❤',
  180: 'K♦',
  184: 'K♣',
  200: 'A♣',
  193: 'A♠',
  194: 'A❤',
  196: 'A♦',
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
        return Colors.red;
      case AppConstants.blackClub:
        return Colors.black;
      case AppConstants.redDiamond:
        return Colors.red;
    }

    return Colors.black;
  }

  /* methods that returns Card Objects */

  static CardObject _getCardFromCardValues(String card) {
    String label = card[0];
    String suit = card[1];

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
