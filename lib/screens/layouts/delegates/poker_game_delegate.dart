import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';

abstract class PokerLayoutDelegate {
  Widget tableBuilder(GameState gameState);

  Widget centerViewBuilder(GameState gameState);

  Widget actionViewBuilder();

  Widget holeCardsBuilder();

  Widget playersOnTableBuilder(Size tableSize);

  Widget tableImage();

  Widget namePlateBuilder();
}
