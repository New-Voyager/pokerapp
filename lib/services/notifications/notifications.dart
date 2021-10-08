import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/utils/formatter.dart';

enum NotificationType {
  UNKNOWN,
  NEW_GAME,
  NEW_CLUB,
  FREE_CHIPS,
  BUYIN_REQUEST,
  MEMBER_APPROVED,
  PLAYER_RENAMED,
  MEMBER_JOIN,
  MEMBER_DENIED,
}

extension NotifyTypeParsing on NotificationType {
  String value() => this.toString().split('.').last;
}

Future<void> saveFirebaseToken(String token) async {
  // call graphql to save the token
  bool ret = await PlayerService.updateFirebaseToken(token);
  if (ret ?? false) {
    log('Successfully updated firebase token for the player');
  } else {
    log('Failed to update firebase token');
  }
}

/**
 * This class handles both push notifications and NATS notifications send to the player.
 */
class NotificationHandler {
  List<String> _handledIds = [];
  FlutterLocalNotificationsPlugin _plugin;
  AndroidNotificationDetails _androidDetails;
  IOSNotificationDetails _iosDetails;
  NotificationDetails _notificationDetails;

  void register() async {
    // Get the token each time the application loads
    String token = await FirebaseMessaging.instance.getToken();
    await saveFirebaseToken(token);
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveFirebaseToken);
    // register Nats push notifications
    _registerPushNotifications();
    _androidDetails = AndroidNotificationDetails(
        "com.voyagerent.pokerapp.channel", "pokerapp", "Poker App Channel",
        sound: RawResourceAndroidNotificationSound('check'), 
        playSound: true);
    _iosDetails = IOSNotificationDetails();
    _notificationDetails = NotificationDetails(android: _androidDetails, iOS: _iosDetails);
  }

  void playerNotifications(String message) {

  }

  void clubNotifications(String message) {

  }

  Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('background message = ${message.data}');
    print('message type = ${message.data['type']}');
    print('message text = ${message.data['text']}');
    print('message title = ${message.data['title']}');
    handlePlayerMessage(message.data, background: true, firebase: true);
    //_showNotification(message, background: true);
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

  Future _showNotification(RemoteMessage message,
      {bool background = false}) async {
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
    } else if (notificationTypeStr == 'MEMBER_JOIN') {
      notificationType = NotificationType.MEMBER_JOIN;
    } else if (notificationTypeStr == 'MEMBER_DENIED') {
      notificationType = NotificationType.MEMBER_DENIED;
    }

    debugPrint('notificationType = $notificationType');

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
    } else if (notificationType == NotificationType.MEMBER_JOIN) {
      final data = message.data;
      body = '${data["playerName"]} is requesting to join ${data["clubName"]}.';
      showNotification = true;
    } else if (notificationType == NotificationType.MEMBER_DENIED) {
      final data = message.data;
      body = 'Club host of ${data["clubName"]} denied your membership.';

      if (!background) {
        // app is running in foreground
        showOverlayNotification(
          (context) => OverlayNotificationWidget(
            title: data['clubName'],
            subTitle: body,
          ),
          duration: Duration(seconds: 10),
        );
      } else {
        showNotification = true;
      }
    }

    if (showNotification) {
      flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
    }
  }

  void _registerPushNotifications() {
    _initLocalNotifications();

    // registering for background messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      handlePlayerMessage(message.data, background: false, firebase: true);
      //_showNotification(message, background: false);
    });
    log('Registered for push notifications');
  }

  void handlePlayerMessage(Map<String, dynamic> json, {bool background = false, bool firebase = false}) {
    String messageId = json['requestId'];
    if (messageId == null) {
      return;
    }
    if (_handledIds.indexOf(messageId) != -1) {
      // we handled the message
      return;
    }
    if (_handledIds.length > 50) {
      _handledIds.removeRange(0, 10);
    }
    _handledIds.add(messageId);

    String type = json['type'];
    if (background) {
      // we are running in background
      // show the notifications in the notifications bin
    } else {
      // running in foreground
      if (type == 'WAITLIST_SEATING') {
        handleWaitlistNotifications(json);
      }
    }
  }

  Future<void> handleWaitlistSeatingPush(Map<String, dynamic> json) async {
    String game = '';
    if (json["gameType"] != null) {
      String gameType = json["gameType"].toString();
      String sb = DataFormatter.chipsFormat(
          double.parse(json['smallBlind'].toString()));
      String bb = DataFormatter.chipsFormat(
          double.parse(json['bigBlind'].toString()));
      game = ' at $gameType $sb/$bb';
    }
    final title = 'Waitlist Seating';
    final message = 'A seat is open in game $game.';
    _plugin.show(0, title, message, _notificationDetails);
  }

  // handle messages when app is running foreground
  Future<void> handleWaitlistNotifications(Map<String, dynamic> json) async {
    String type = json['type'].toString();
    String gameCode = json['gameCode'].toString();
    if (type == 'WAITLIST_SEATING') {
      String game = '';
      if (json["gameType"] != null) {
        String gameType = json["gameType"].toString();
        String sb = DataFormatter.chipsFormat(
            double.parse(json['smallBlind'].toString()));
        String bb = DataFormatter.chipsFormat(
            double.parse(json['bigBlind'].toString()));
        game = ' at $gameType $sb/$bb';
      }
      String title = 'Do you want to take a open seat $game?';
      String subTitle = 'Code: ${json["gameCode"]}';
      if (json['clubName'] != null) {
        subTitle = subTitle + '\n' + 'Club: ${json["clubName"]}';
      }
      final message =
          'A seat open in game $game.\n\nDo you want to take the open seat?';

      final res = await showWaitlistInvitation(
          navigatorKey.currentContext, message, 10);
      if (res) {
        navigatorKey.currentState.pushNamed(
          Routes.game_play,
          arguments: gameCode,
        );
      }
    }
  }
}

NotificationHandler notificationHandler;