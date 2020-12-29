import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Audio {
  Audio._();

  static Future<int> play({
    BuildContext context,
    String assetFile,
  }) async {
    String tempAssetFile = Provider.of<ValueNotifier<Map<String, String>>>(
      context,
      listen: false,
    ).value[assetFile];

    return Provider.of<AudioPlayer>(
      context,
      listen: false,
    ).play(
      tempAssetFile,
      isLocal: true,
    );
  }

  static Future<int> stop({BuildContext context}) => Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).stop();
}
