import 'dart:developer';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

String clickSound = 'assets/sound_effects/button_press.wav';

class AudioService {
  static AudioPlayer audioPlayer;
  static Map<String, Uint8List> _audioCache = Map<String, Uint8List>();

  AudioService._();
  static Future<void> init() async {
    if (audioPlayer == null) {
      audioPlayer = new AudioPlayer();
    }

    // load sounds to memory
    await getAudioBytes(clickSound);
  }

  static Future<Uint8List> getAudioBytes(String assetFile) async {
    if (_audioCache[assetFile] == null) {
      log('Loading file $assetFile');
      try {
        final data = (await rootBundle.load(assetFile)).buffer.asUint8List();
        _audioCache[assetFile] = data;
      } catch (err) {
        log('File loading failed. ${err.toString()}');
        _audioCache[assetFile] = Uint8List(0);
      }
    }
    return _audioCache[assetFile];
  }

  static playClickSound() {
    log('Playing click sound');
    if (_audioCache[clickSound] != null) {
      try {
        audioPlayer.playBytes(_audioCache[clickSound]);
      } catch (err) {
        log('Could not play sound. Error: ${err.toString()}');
      }
    }
  }
}
