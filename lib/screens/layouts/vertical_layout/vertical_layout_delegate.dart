import 'package:flutter/material.dart';
import 'package:pokerapp/screens/layouts/delegates/poker_game_delegate.dart';

class VerticalLayoutDelegate extends PokerLayoutDelegate {
  @override
  Widget actionViewBuilder() {
    return const Text('Not implemented');
  }

  @override
  Widget tableBuilder() {
    return const Text('Not implemented');
  }

  @override
  Widget centerViewBuilder() {
    return const Text('Not implemented');
  }

  @override
  Widget holeCardsBuilder() {
    return const Text('Not implemented');
  }

  @override
  Widget playersOnTableBuilder(Size tableSize) {
    return const Text('Not implemented');
  }

  @override
  Widget tableImage() {
    return const Text('Not implemented');
  }

  @override
  Widget namePlateBuilder() {
    return const Text('Not implemented');
  }
}
