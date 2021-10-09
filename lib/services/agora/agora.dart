// import 'dart:developer';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter/foundation.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
// import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
// import 'package:pokerapp/services/data/game_log_store.dart';

// // enableAudioVolumeIndication
// //  RtcEngineEventHandler.audioVolumeIndication audioVolumeIndication
// class Agora extends ChangeNotifier {
//   RtcEngine engine;
//   bool isJoined = false, openMicrophone = true, enableSpeakerphone = true;
//   bool initializing = false;
//   bool initialized = false;
//   String gameCode;
//   String uuid;
//   int playerId;
//   String agoraToken;
//   String appId;
//   GameState gameState;
//   CommunicationState state;
//   Seat mySeat;
//   Agora(
//       {this.appId,
//       this.gameCode,
//       this.uuid,
//       this.playerId,
//       this.state,
//       this.gameState});
//   Future initEngine() async {
//     mySeat = this.gameState.mySeat;
//     engine = await RtcEngine.create(appId);
//     this._addListeners();
//     await engine.enableAudio();
//     await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await engine.setClientRole(ClientRole.Broadcaster);
//     await engine.enableAudioVolumeIndication(200, 3, true);
//   }

//   void disposeObject() {
//     if (engine == null) {
//       return;
//     }

//     leaveChannel();
//     engine.destroy();
//     engine = null;
//   }

//   _addListeners() {
//     engine?.setEventHandler(RtcEngineEventHandler(
//         joinChannelSuccess: (channel, uid, elapsed) {
//       log('agora: joinChannelSuccess $channel $uid $elapsed');
//       isJoined = true;
//     }, leaveChannel: (stats) {
//       log('agora: leaveChannel ${stats.toJson()}');
//       isJoined = false;
//     }, audioVolumeIndication:
//             (List<AudioVolumeInfo> speakers, int totalVolume) {
//       // speakers[0].vad == 1 (speaking)
//       // speakers[0].vad == 0 (not speaking)

//       for (final speaker in speakers) {
//         //log('agora: uid: ${speaker.uid} channel: ${speaker.channelId} vad: ${speaker.vad} volume: ${speaker.volume}');
//         if (speaker.uid == 0 || speaker.uid == this.playerId) {
//           // current player
//           if (this.state.talking && speaker.vad == 0) {
//             mySeat.player.talking = false;
//             mySeat.notify();
//             log('agora: Current player started talking');
//             // player stopped talking
//             this.state.talking = false;
//             this.state.notify();
//           } else if (!this.state.talking && speaker.vad == 1) {
//             // player started talking
//             this.state.talking = true;
//             log('agora: Current player stopped talking');
//             this.state.notify();
//             mySeat.player.talking = true;
//             mySeat.notify();
//           }
//         } else {
//           // other players
//           log('agora: Other player ${speaker.uid} talking/not talking ${speaker.uid}');
//           final seat = this.gameState.getSeatByPlayer(speaker.uid);
//           if (seat != null) {
//             final player = seat.player;
//             if (player.talking && speaker.vad == 0) {
//               player.talking = true;
//               seat.notify();
//             } else if (!player.talking && speaker.vad == 1) {
//               player.talking = false;
//               seat.notify();
//             }
//           }
//         }
//       }
//     }));
//   }

//   joinChannel(String agoraToken) async {
//     this.agoraToken = agoraToken;
//     if (this.agoraToken.isEmpty) {
//       return;
//     }
//     if (initializing || isJoined) {
//       return;
//     }
//     initializing = true;
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await Permission.microphone.request();
//     }

//     if (engine == null) {
//       await initEngine();
//     }

//     debugLog(gameCode,
//         'Joining agora channel ${this.playerId} agora token: ${this.agoraToken}');
//     log('Joining agora channel ${this.playerId}');
//     await engine.joinChannel(
//         this.agoraToken, this.gameCode, null, this.playerId);
//     log('Joined agora channel ${this.playerId}');
//     debugLog(gameCode, 'Joined agora channel ${this.playerId}');
//     state.audioConferenceStatus = AudioConferenceStatus.CONNECTED;
//     initializing = false;
//     initialized = true;
//   }

//   leaveChannel() async {
//     if (this.agoraToken.isEmpty || !isJoined) {
//       return;
//     }
//     debugLog(gameCode, 'player $uuid leaving audio channel');
//     log('agora: player $uuid leaving audio channel');
//     await engine.leaveChannel();
//     log('agora: player $uuid left audio channel');
//     debugLog(gameCode, 'player $uuid left audio channel');
//     isJoined = false;
//     state.audioConferenceStatus = AudioConferenceStatus.LEFT;
//   }

//   bool get micMuted {
//     return !openMicrophone;
//   }

//   switchMicrophone() {
//     openMicrophone = !openMicrophone;
//     engine
//         ?.enableLocalAudio(openMicrophone)
//         ?.then((value) {})
//         ?.catchError((err) {
//       log('agora: enableLocalAudio $err');
//     });

//     if (!openMicrophone) {
//       state.muted = true;
//     } else {
//       state.muted = false;
//     }
//   }

//   switchSpeakerphone() {
//     engine
//         ?.setEnableSpeakerphone(!enableSpeakerphone)
//         ?.then((value) {})
//         ?.catchError((err) {
//       log('agora: setEnableSpeakerphone $err');
//     });
//   }
// }
