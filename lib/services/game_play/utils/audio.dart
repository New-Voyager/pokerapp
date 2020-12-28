import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Audio {
  Audio._();
  static Map<String, Uint8List> audioData = new Map<String, Uint8List>();

  static Future<int> play({
    BuildContext context,
    String assetFile,
  }) async {
    Uint8List audioBytes;
    if (Audio.audioData.containsKey(assetFile)) {
      audioBytes = Audio.audioData[assetFile];
    } else {
      audioBytes = (await rootBundle.load(assetFile)).buffer.asUint8List();
      Audio.audioData[assetFile] = audioBytes;
    }

    stop(context: context);

    Provider.of<AudioPlayer>(
      context,
      listen: false,
    ).playBytes(audioBytes);
  }

  static Future<int> stop({BuildContext context}) => Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).stop();
}
