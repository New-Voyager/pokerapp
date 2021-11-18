import 'package:flutter/material.dart';
import 'package:pokerapp/utils/card_helper.dart';

class RankCardsUtils {
  RankCardsUtils._();

  static List<int> getAllCardsFromSpade() {
    // As, 2s, 3s, 4s, 5s, 6s, 7s, 8s, 9s, 10s, Js, Ks, Qs
    return const [193, 1, 17, 33, 49, 65, 81, 97, 113, 129, 145, 177, 161];
  }

  static List<int> getCardsForStraightFlush() {
    // 5s, 6s, 7s, 8s, 9s, 10s, Js, Ks, Qs, As
    return const [49, 65, 81, 97, 113, 129, 145, 177, 161, 193];
  }

  static List<int> _straightFlushAllCards() {
    return [129, 145, 177, 161, ...getAllCardsFromSpade()];
  }

  static void onFullHouseSecondCardSelection(
    int c,
    final ValueNotifier<List<int>> cards,
  ) {
    final cardLabel = CardHelper.getCard(c).label;

    final List<int> tmp = [];

    CardHelper.cardValues.entries.forEach((element) {
      final String value = element.value;
      final int cardNum = element.key;

      if (value.startsWith(cardLabel)) {
        tmp.add(cardNum);
      }
    });

    cards.value = [...cards.value.sublist(0, 3), ...tmp.sublist(0, 2)];
  }

  static void onFullHouseFirstCardSelection(
    int c,
    final ValueNotifier<List<int>> cards,
  ) {
    final cardLabel = CardHelper.getCard(c).label;

    final List<int> tmp = [];

    CardHelper.cardValues.entries.forEach((element) {
      final String value = element.value;
      final int cardNum = element.key;

      if (value.startsWith(cardLabel)) {
        tmp.add(cardNum);
      }
    });

    cards.value = tmp.sublist(0, 3);
  }

  static void onFourOfKindSelection(
    final int c,
    final ValueNotifier<List<int>> cards,
  ) {
    final cardLabel = CardHelper.getCard(c).label;

    final List<int> tmp = [];

    CardHelper.cardValues.entries.forEach((element) {
      final String value = element.value;
      final int cardNum = element.key;

      if (value.startsWith(cardLabel)) {
        tmp.add(cardNum);
      }
    });

    cards.value = tmp;
  }

  static void onStraightFlushCardsSelection(
    final int c,
    final ValueNotifier<List<int>> cards,
  ) {
    final cs = _straightFlushAllCards();

    int idx = cs.lastIndexOf(c);
    cards.value = cs.sublist(idx - 4, idx + 1);
  }
}
