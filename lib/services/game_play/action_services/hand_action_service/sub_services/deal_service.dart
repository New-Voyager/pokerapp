import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class DealService {
  DealService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    int seatNo = data['dealCards']['seatNo'];
    String cards = data['dealCards']['cards'];

    Provider.of<Players>(
      context,
      listen: false,
    ).updateCard(
      seatNo,
      CardHelper.getRawCardNumbers(cards),
    );
  }
}
