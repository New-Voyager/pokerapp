import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/approval_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
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
      // toast("Message arrived", duration: Duration(seconds: 2));

      // Display overlay notification irrespective of user in any screen.
      showOverlayNotification(
        (context) => OverlayNotificationWidget(
          amount: message.data['amount'],
          playerName: message.data['playerName'],
          pendingCount: approvalCount,
        ),
        duration: Duration(seconds: 5),
      );

      /*    showSimpleNotification(
          Text(
            "Buyin request of '${message.data['amount']}' from '${message.data['playerName']}'",
            style: TextStyle(
              color: AppColors.appAccentColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            "Total pending buyin requests : $approvalCount",
            style: TextStyle(
              color: AppColors.appAccentColor,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.cancel_rounded,
                color: AppColors.appAccentColor,
              ),
              onPressed: () {}),
          background: Colors.grey.shade100,
          slideDismissDirection: DismissDirection.horizontal,
          autoDismiss: true,
          elevation: 3,
          duration: Duration(seconds: 4),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          leading: Image.asset(
            AppAssets.cardsImage,
          ));
    */
    }
  });
  log('Registered for push notifications');
}
