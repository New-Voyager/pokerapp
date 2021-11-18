import 'package:flutter/material.dart';

class RankCardsUtils {
  RankCardsUtils._();

  static List<int> getAllCardsFromSpade() {
    // As, 2s, 3s, 4s, 5s, 6s, 7s, 8s, 9s, 10s, Js, Ks, Qs
    return [193, 1, 17, 33, 49, 65, 81, 97, 113, 129, 145, 177, 161];
  }

  static List<int> getCardsForStraightFlush() {
    // 5s, 6s, 7s, 8s, 9s, 10s, Js, Ks, Qs, As
    return [49, 65, 81, 97, 113, 129, 145, 177, 161, 193];
  }

  static void onStraightFlushCardsSelection(
    final int c,
    final ValueNotifier<List<int>> cards,
  ) {
    final cs = [129, 145, 177, 161, ...getAllCardsFromSpade()];

    int idx = cs.lastIndexOf(c);
    cards.value = cs.sublist(idx - 4, idx + 1);
  }
}
