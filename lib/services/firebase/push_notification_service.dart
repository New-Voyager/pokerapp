
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/player_service.dart';

// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   Future initialize() async{

//   }
// }

Future<void> saveFirebaseToken(String token) async {
  // call graphql to save the token
  String playerId = await AuthService.fetchUUID();
  bool ret = await PlayerService.updateFirebaseToken(token);
  if (ret) {
    log('Successfully updated firebase token for the player');
  } else {
    log('Failed to update firebase token');
  }
}