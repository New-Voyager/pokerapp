import 'package:flutter/material.dart';

abstract class PokerLayoutDelegate {
  Widget tableBuilder();

  Widget centerViewBuilder();

  Widget actionViewBuilder();

  Widget holeCardsBuilder();

  Widget playersOnTableBuilder(Size tableSize);

  Widget tableImage();

  Widget namePlateBuilder();
}
