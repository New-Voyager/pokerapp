import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/ui/nameplate_object.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/user_settings.dart';
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
  Map<String, Uint8List> colorCards = Map<String, Uint8List>();

  NamePlateDesign nameplate;

  Uint8List getBackDrop() {
    return backdropBytes;
  }

  Uint8List getBoard() {
    return boardBytes;
  }

  NamePlateDesign getNameplate() {
    if (nameplate == null) {
      return AssetService.getNameplateForId('0');
    }
    return nameplate;
  }

  NamePlateDesign getNameplateById(String id) {
    final namePlate = AssetService.getNameplateForId(id);
    if (namePlate == null) {
      return AssetService.getNameplateForId('0');
    }
    return namePlate;
  }

  Uint8List getHoleCardBack() {
    return holeCardBackBytes;
  }

  Uint8List getHoleCard(int card, {bool color = false}) {
    if (color) {
      String cardStr = CardConvUtils.getString(card);
      if (colorCards[cardStr] != null) {
        return colorCards[cardStr];
      }
    }

    Uint8List bytes = cardNumberImage[card];

    // log('Customize: $card: bytes length ${bytes.length}');
    return bytes;
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
    Asset backdrop = AssetService.getAssetForId(
      appService.userSettings.getSelectedBackdropId(),
    );
    if (backdrop == null) {
      backdrop = AssetService.getAssetForId(
        UserSettingsStore.VALUE_DEFAULT_BACKDROP,
      );
    }
    backdropBytes = await backdrop.getBytes();

    Asset table = AssetService.getAssetForId(
      appService.userSettings.getSelectedTableId(),
    );
    if (table == null) {
      table = AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_TABLE);
    }
    boardBytes = await table.getBytes();

    nameplate = AssetService.getNameplateForId(
      appService.userSettings.getSelectedNameplateId(),
    );

    Asset betImage = AssetService.getAssetForId(
      appService.userSettings.getSelectedBetDial(),
    );
    if (betImage == null) {
      betImage = AssetService.getAssetForId(
        UserSettingsStore.VALUE_DEFAULT_BETDIAL,
      );
    }
    betImageBytes = await betImage.getBytes();

    Asset cardBack = AssetService.getAssetForId(
      appService.userSettings.getSelectedCardBackId(),
    );
    if (cardBack == null) {
      cardBack = AssetService.getAssetForId(
        UserSettingsStore.VALUE_DEFAULT_CARDBACK,
      );
    }
    holeCardBackBytes = await cardBack.getBytes();

    Asset cardFace = AssetService.getAssetForId(
      appService.userSettings.getSelectedCardFaceId(),
    );
    if (cardFace == null) {
      cardFace = AssetService.getAssetForId(
        UserSettingsStore.VALUE_DEFAULT_CARDFACE,
      );
    }
    try {
      // log('Customize: Loading cards');
      await loadCards(cardFace);
      // log('Customize: Loading cards successful');
    } catch (err) {
      // log('Customize: Loading default cards');
      // fall back to default card
      cardFace = AssetService.getAssetForId(
        UserSettingsStore.VALUE_DEFAULT_CARDFACE,
      );
      await loadCards(cardFace);
      // log('Customize: Loading default cards successful');
    }
  }

  void loadCards(Asset cardFace) async {
    cardStrImage.clear();
    cardNumberImage.clear();
    colorCards.clear();

    // load color cards
    for (int card in CardConvUtils.cardNumbers.keys) {
      final cardStr = CardConvUtils.getString(card);
      Uint8List cardBytes;
      final cardData = await rootBundle.load('assets/images/color-card_face/$cardStr.svg');
      cardBytes = cardData.buffer.asUint8List();
      colorCards[cardStr] = cardBytes;
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
        if (!File(filename).existsSync()) {
          // switch to default design
        }
        cardBytes = File(filename).readAsBytesSync();
      }
      cardStrImage[cardStr] = cardBytes;
      cardNumberImage[card] = cardBytes;
    }
  }
}
