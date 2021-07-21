import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:provider/provider.dart';

// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   Future initialize() async{

//   }
// }

enum NotificationType {
  UNKNOWN,
  NEW_GAME,
  NEW_CLUB,
  FREE_CHIPS,
  BUYIN_REQUEST,
  MEMBER_APPROVED,
  PLAYER_RENAMED
}
FlutterLocalNotificationsPlugin _plugin;

extension NotifyTypeParsing on NotificationType {
  String value() => this.toString().split('.').last;
}

Future<void> saveFirebaseToken(String token) async {
  // call graphql to save the token
  String playerId = await AuthService.fetchUUID();
  bool ret = await PlayerService.updateFirebaseToken(token);
  if (ret ?? false) {
    log('Successfully updated firebase token for the player');
  } else {
    log('Failed to update firebase token');
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print('background message = ${message.data}');
  print('message type = ${message.data['type']}');
  print('message text = ${message.data['text']}');
  print('message title = ${message.data['title']}');
  _showNotification(message);
}

FlutterLocalNotificationsPlugin _initLocalNotifications() {
  if (_plugin != null) {
    return _plugin;
  }

  var androidSettings = AndroidInitializationSettings('logo');
  var iosSettings = IOSInitializationSettings();
  var initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: _onTapNotification);
  _plugin = flutterLocalNotificationsPlugin;
  return _plugin;
}

Future _onTapNotification(String payload) async {
  print('_onTapNotification = $payload');
}

Future _showNotification(RemoteMessage message) async {
  if (message.data['type'].toString() == null) {
    return;
  }

  AndroidNotificationDetails androidDetails;
  IOSNotificationDetails iosDetails;
  var notificationTypeStr = message.data['type'];
  NotificationType notificationType = NotificationType.UNKNOWN;

  if (notificationTypeStr == 'BUYIN_REQUEST') {
    notificationType = NotificationType.BUYIN_REQUEST;
  } else if (notificationTypeStr == 'NEW_GAME') {
    notificationType = NotificationType.NEW_GAME;
  } else if (notificationTypeStr == 'MEMBER_APPROVED') {
    notificationType = NotificationType.MEMBER_APPROVED;
  } else if (notificationTypeStr == 'PLAYER_RENAMED') {
    notificationType = NotificationType.PLAYER_RENAMED;
  }

  print('notificationType = $notificationType');
  print(
      'NotificationType.NEW_GAME.value() = ${NotificationType.NEW_GAME.value()}');

  androidDetails = AndroidNotificationDetails(
      "com.voyagerent.pokerapp.channel", "pokerapp", "Poker App Channel",
      sound: RawResourceAndroidNotificationSound('check'), playSound: true);
  iosDetails = IOSNotificationDetails();

  if (notificationType == NotificationType.NEW_GAME) {
    // change sound and other attributes
  }
  final notificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
  final flutterLocalNotificationsPlugin = _initLocalNotifications();

  String title;
  String body;
  bool showNotification = false;
  if (notificationType == NotificationType.BUYIN_REQUEST) {
    title = 'Buyin Request';
    /*
    data: {
          amount: amount.toString(),
          gameCode: game.gameCode,
          playerName: requestingPlayer.name,
          playerUuid: requestingPlayer.uuid,
          type: 'BUYIN_REQUEST',
        }
    */
    final data = message.data;
    body =
        '${data["playerName"]} is requesting to buyin ${data["amount"]}. Gamecode: ${data["gameCode"]}';
    showNotification = true;
  }

  if (showNotification) {
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}

void registerPushNotifications() {
  // registering for background messages
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    _showNotification(message);

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
    if (message.data['type'].toString() == 'BUYIN_REQUEST') {
      final approvals = await PlayerService.getPendingApprovals();
    //  final approvalCount = await PlayerService.getPendingApprovalsCount();
      final state = Provider.of<PendingApprovalsState>(
          navigatorKey.currentContext,
          listen: false);
      state.setPendingList(approvals);
      //(approvalCount);
      // state.incrementTotalPending();
      print('approval count: ${approvals.length} length: ${approvals.length}');
      // toast("Message arrived", duration: Duration(seconds: 2));

      // Display overlay notification irrespective of user in any screen.
      showOverlayNotification(
        (context) => OverlayNotificationWidget(
          amount: message.data['amount'],
          playerName: message.data['playerName'],
          pendingCount: approvals.length,
        ),
        duration: Duration(seconds: 5),
      );
    }
  });
  log('Registered for push notifications');
}
