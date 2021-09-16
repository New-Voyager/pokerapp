import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/user_settings_store.dart';
import 'package:pokerapp/utils/utils.dart';

class GameScreenAssets {
  String backdropImage;
  String boardImage;
  String holeCardBackImage;
  String holeCardFaceDir;

  Uint8List backdropBytes;
  Uint8List boardBytes;
  Uint8List holeCardBackBytes;
  Uint8List betImageBytes;
  Map<String, Uint8List> cardStrImage;
  Map<int, Uint8List> cardNumberImage;

  Uint8List getBackDrop() {
    return backdropBytes;
  }

  Uint8List getBoard() {
    return boardBytes;
  }

  Uint8List getHoleCardBack() {
    return holeCardBackBytes;
  }

  Uint8List getHoleCard(int card) {
    return cardNumberImage[card];
  }

  Uint8List getHoleCardStr(String card) {
    return cardStrImage[card];
  }

  Uint8List getBetImage() {
    return betImageBytes;
  }

  Future<void> initialize() async {
    cardStrImage = Map<String, Uint8List>();
    cardNumberImage = Map<int, Uint8List>();
    Asset backdrop =
        AssetService.getAssetForId(UserSettingsStore.getSelectedBackdropId());
    if (backdrop == null) {
      backdrop =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_BACKDROP);
    }
    backdropBytes = await backdrop.getBytes();

    Asset table =
        AssetService.getAssetForId(UserSettingsStore.getSelectedTableId());
    if (table == null) {
      table = AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_TABLE);
    }
    boardBytes = await table.getBytes();

    Asset betImage =
        AssetService.getAssetForId(UserSettingsStore.getSelectedBetDial());
    if (betImage == null) {
      betImage =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_BETDIAL);
    }
    betImageBytes = await betImage.getBytes();

    Asset cardBack =
        AssetService.getAssetForId(UserSettingsStore.getSelectedCardBackId());
    if (cardBack == null) {
      cardBack =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_CARDBACK);
    }
    holeCardBackBytes = await cardBack.getBytes();

    Asset cardFace =
        AssetService.getAssetForId(UserSettingsStore.getSelectedCardFaceId());
    if (cardFace == null) {
      cardFace =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_CARDFACE);
    }

    for (int card in CardConvUtils.cardNumbers.keys) {
      final cardStr = CardConvUtils.getString(card);
      Uint8List cardBytes;
      if (cardFace.bundled ?? false) {
        cardBytes =
            (await rootBundle.load('${cardFace.downloadDir}/$cardStr.svg'))
                .buffer
                .asUint8List();
      } else {
        String filename = '${cardFace.downloadDir}/$card.svg';
        if (!File(filename).existsSync()) {
          filename = '${cardFace.downloadDir}/$card.png';
          if (!File(filename).existsSync()) {
            filename = '${cardFace.downloadDir}/$cardStr.svg';
            if (!File(filename).existsSync()) {
              filename = '${cardFace.downloadDir}/$cardStr.png';
            }
          }
        }
        cardBytes = File(filename).readAsBytesSync();
      }
      cardStrImage[cardStr] = cardBytes;
      cardNumberImage[card] = cardBytes;
    }
  }
}