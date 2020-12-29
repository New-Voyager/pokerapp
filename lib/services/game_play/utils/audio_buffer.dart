import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_assets.dart';

class AudioBufferService {
  AudioBufferService._();

  static String _getName() => DateTime.now().microsecondsSinceEpoch.toString();

  /* AUDIO_ASSET_NAME, AUDIO_TEMP_FILE_NAME mapping */
  static Future<Map<String, String>> create() async {
    Map<String, String> tempAudioFileMaps = Map<String, String>();

    for (int i = 0; i < AppAssets.soundEffects.length; i++) {
      File file = File(
          (await getTemporaryDirectory()).path + '/' + _getName() + '.wav');
      await file.writeAsBytes((await rootBundle.load(AppAssets.soundEffects[i]))
          .buffer
          .asUint8List());
      tempAudioFileMaps[AppAssets.soundEffects[i]] = file.path;
    }

    return tempAudioFileMaps;
  }
}
