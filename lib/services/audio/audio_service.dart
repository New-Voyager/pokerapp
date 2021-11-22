import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

const String clickSound = 'assets/sound_effects/button_press.mp3';
const String betRaiseSound = 'assets/sound_effects/bet_call1.mp3';
const String allInSound = 'assets/sound_effects/allin.mp3';
const String foldSound = 'assets/sound_effects/fold.mp3';
const String checkSound = 'assets/sound_effects/check.mp3';
const String dealSound = 'assets/sound_effects/deal.mp3';
const String newHandSound = 'assets/sound_effects/new_hand.mp3';
const String playerTurnSound = 'assets/sound_effects/player_turn.mp3';
const String flopSound = 'assets/sound_effects/flop.mp3';
const String turnRiverSound = 'assets/sound_effects/river.mp3';
const String applauseSound = 'assets/sound_effects/applause.mp3';
const String fireworksSound = 'assets/animations/fireworks.mp3';

const String clockTickingSound = 'assets/sound_effects/clock_ticking.mp3';

class AudioService {
  static AudioPlayer audioPlayer;
  static final Map<String, Uint8List> _audioCache = Map<String, Uint8List>();
  static bool play = true;
  AudioService._();

  static stop() {
    play = false;
  }

  static resume() {
    play = true;
  }

  static stopSound() {
    if (audioPlayer != null) {
      try {
        if (audioPlayer.state == PlayerState.PLAYING) {
          audioPlayer.stop();
        }
      } catch (err) {
        // ignore the error
      }
    }
  }

  static Future<void> init() async {
    if (audioPlayer == null) {
      audioPlayer = new AudioPlayer();
    }

    // load sounds to memory
    await getAudioBytes(clickSound);
    await getAudioBytes(checkSound);
    await getAudioBytes(playerTurnSound);
    await getAudioBytes(foldSound);
    await getAudioBytes(dealSound);
    await getAudioBytes(applauseSound);
    await getAudioBytes(fireworksSound);
    await getAudioBytes(betRaiseSound);
    await getAudioBytes(flopSound);
    await getAudioBytes(flopSound);
    await getAudioBytes(clockTickingSound);
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

  static playSound(String soundFile, {bool mute}) {
    // the library we use only supports Android
    // if (!Platform.isAndroid) return;

    if (!play) {
      return;
    }
    log('Playing click sound');
    if (mute ?? false) {
      return;
    }
    if (_audioCache[soundFile] != null) {
      try {
        audioPlayer.playBytes(_audioCache[soundFile]);
      } catch (err) {
        log('Could not play sound. Error: ${err.toString()}');
      }
    }
  }

  static playCheck({bool mute}) {
    playSound(checkSound, mute: mute);
  }

  static playFold({bool mute}) {
    playSound(foldSound, mute: mute);
  }

  static playBet({bool mute}) {
    playSound(betRaiseSound, mute: mute);
  }

  static playDeal({bool mute}) {
    playSound(dealSound, mute: mute);
  }

  static playNewHand({bool mute}) {
    playSound(newHandSound, mute: mute);
  }

  static playYourAction({bool mute}) {
    playSound(playerTurnSound, mute: mute);
  }

  static playFlop({bool mute}) {
    playSound(flopSound, mute: mute);
  }

  static playApplause({bool mute}) {
    playSound(applauseSound, mute: mute);
  }

  static playFireworks({bool mute}) {
    playSound(fireworksSound, mute: mute);
  }

  static playClockTicking({bool mute}) {
    playSound(clockTickingSound, mute: mute);
  }

  static playAnimationSound(String animationId, {bool mute}) async {
    final animationSound = 'assets/animations/$animationId.mp3';
    final audioBytes = await getAudioBytes(animationSound);
    if (audioBytes != null) {
      playSound(animationSound, mute: mute);
    }
  }
}
