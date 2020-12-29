import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class DealService {
  DealService._();

  static Uint8List dealSoundBytes;

  static void handle({
    BuildContext context,
    var data,
  }) {
    // play the deal sound effect
    Audio.play(
      context: context,
      assetFile: AppAssets.dealSound,
    );

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
