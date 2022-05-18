import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

const String clickSound = 'assets/sound_effects/button_press.mp3';
const String betRaiseSound = 'assets/sound_effects/bet_call1.mp3';
const String allInSound = 'assets/sound_effects/allin.mp3';
const String foldSound = 'assets/sound_effects/fold.mp3';
const String checkSound = 'assets/sound_effects/check.mp3';
const String dealSound = 'assets/sound_effects/deal.mp3';
const String pitch1Sound = 'assets/sound_effects/pitch1.mp3';
const String pitch2Sound = 'assets/sound_effects/pitch2.mp3';
const String pitch3Sound = 'assets/sound_effects/pitch3.mp3';
const String pitch4Sound = 'assets/sound_effects/pitch4.mp3';
const String newHandSound = 'assets/sound_effects/new_hand.mp3';
const String playerTurnSound = 'assets/sound_effects/player_turn.mp3';
const String flopSound = 'assets/sound_effects/flop.mp3';
const String turnRiverSound = 'assets/sound_effects/flop.mp3';
const String applauseSound = 'assets/sound_effects/applause.mp3';
const String fireworksSound = 'assets/animations/fireworks.mp3';
const String clockTickingSound = 'assets/sound_effects/clock_ticking.mp3';

class AudioService {
  static just_audio.AudioPlayer justAudioPlayer;
  //static just_audio.AudioPlayer dealAudioPlayer;
  static just_audio.ConcatenatingAudioSource _concatenatingAudioSource;

  // add it to your class as a static member
  // static AudioCache player = AudioCache(prefix: 'assets/sound_effects/');

  static final Map<String, Uri> _audioFileCache = Map<String, Uri>();
  // static final Map<String, Uint8List> _audioCache = Map<String, Uint8List>();
  static bool play = true;
  AudioService._();

  static stop() {
    play = false;
  }

  static resume() {
    play = true;
  }

  static stopSound() {
    // DO NOTHING
  }

  static Future<void> init() async {
    if (justAudioPlayer == null) {
      justAudioPlayer = just_audio.AudioPlayer(handleInterruptions: true);
    }
    // if (dealAudioPlayer == null) {
    //   dealAudioPlayer = just_audio.AudioPlayer(handleInterruptions: true);
    // }

    // load sounds to memory
    await getAudioUri(clickSound);
    await getAudioUri(checkSound);
    await getAudioUri(playerTurnSound);
    await getAudioUri(foldSound);
    await getAudioUri(dealSound);
    await getAudioUri(applauseSound);
    await getAudioUri(fireworksSound);
    await getAudioUri(betRaiseSound);
    await getAudioUri(flopSound);
    await getAudioUri(clockTickingSound);
  }

  static Future<void> getAudioUri(String soundFile) async {
    log('Loading file $soundFile');
    try {
      final data = (await rootBundle.load(soundFile)).buffer.asUint8List();
      final file = File('${(await getTemporaryDirectory()).path}/$soundFile');
      await file.create(recursive: true);
      await file.writeAsBytes(data.buffer.asUint8List());
      _audioFileCache[soundFile] = file.uri;
    } catch (err) {
      log('File loading failed. ${err.toString()}');
    }
  }

  static playClickSound() {
    log('Playing click sound');
    playSound(clickSound);
  }

  static Future<void> playSound(String soundFile, {bool mute = false}) async {
    if (!play) return;
    if (mute ?? false) return;
    //if (!_audioFileCache.containsKey(soundFile)) return;

    try {
      await justAudioPlayer.setAsset(soundFile);
      await justAudioPlayer.play();
    } catch (err) {
      log('Could not play sound. Error: ${err.toString()}');
    }
  }

  static Future<void> playDealSound2(int n, {bool mute = false}) async {
    for (int i = 0; i < n; i++) {
      log('Dealing Playing deal sound 2');
      await playDealSound(mute: mute);
    }
    return;
  }

  static Future<void> playDealSound({bool mute = false}) async {
    if (!play) return;
    if (mute ?? false) return;
    //if (!_audioFileCache.containsKey(soundFile)) return;

    try {
      return playSound(dealSound, mute: mute);
    } catch (err) {
      log('Could not play sound. Error: ${err.toString()}');
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

  static playDeal({bool mute}) async {
    playSound(dealSound, mute: mute);
  }

  static playPitch1({bool mute}) async {
    playSound(pitch1Sound, mute: mute);
  }

  static playPitch2({bool mute}) async {
    playSound(pitch2Sound, mute: mute);
  }

  static playPitch3({bool mute}) async {
    playSound(pitch3Sound, mute: mute);
  }

  static playPitch4({bool mute}) {
    playSound(pitch4Sound, mute: mute);
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
    // tick sound is disabled for now
    return;
    //playSound(clockTickingSound, mute: mute);
  }

  static playAnimationSound(String animationId, {bool mute}) async {
    final animationSound = 'assets/animations/$animationId.mp3';
    await getAudioUri(animationSound);
    playSound(animationSound, mute: mute);
  }

  static Future<int> playVoice(Uint8List bytes) async {
    return 0;
  }
}
