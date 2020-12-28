import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Audio {
  Audio._();

  static Future<int> play({
    BuildContext context,
    String assetFile,
  }) async =>
      Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).playBytes(
        (await rootBundle.load(assetFile)).buffer.asUint8List(),
      );

  static Future<int> stop({BuildContext context}) => Provider.of<AudioPlayer>(
        context,
        listen: false,
      ).stop();
}
