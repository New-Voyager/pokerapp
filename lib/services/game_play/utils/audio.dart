import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Audio {
  Audio._();

  static Future<int> play({
    BuildContext context,
    String assetFile,
  }) async {
    return -1;

    String tempAssetFile = Provider.of<ValueNotifier<Map<String, String>>>(
      context,
      listen: false,
    ).value[assetFile];
    try {
      if (tempAssetFile == null) {
        return -1;
      }
      return Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).play(
        tempAssetFile,
        isLocal: true,
      );
    } catch (Exception) {
      // ignore this exception
      return -1;
    }
  }

  static Future<int> stop({BuildContext context}) => Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).stop();

  static Future<void> dispose({BuildContext context}) =>
      Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).dispose();
}
