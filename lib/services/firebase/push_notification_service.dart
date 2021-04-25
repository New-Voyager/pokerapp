import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/enums/approval_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:provider/provider.dart';

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

void registerPushNotifications() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
    if (message.data['type'].toString() == 'BUYIN_REQUEST') {
      final approvals = await PlayerService.getPendingApprovals();
      final approvalCount = await PlayerService.getPendingApprovalsCount();
      final state = Provider.of<PendingApprovalsState>(
          navigatorKey.currentContext,
          listen: false);
      state.setTotalPending(approvalCount);
      // state.incrementTotalPending();
      print('approval count: $approvalCount length: ${approvals.length}');
    }
  });
  log('Registered for push notifications');
}


