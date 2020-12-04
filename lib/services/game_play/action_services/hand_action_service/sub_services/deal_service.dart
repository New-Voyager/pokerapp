import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class DealService {
  DealService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    String cards = data['dealCards']['cards'];

    Provider.of<ValueNotifier<List<CardObject>>>(
      context,
      listen: false,
    ).value = CardHelper.getCards(cards);
  }
}
