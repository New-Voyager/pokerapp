import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/dialogs.dart';

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
  TEST_PUSH,
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
  FGBGType _currentAppState = FGBGType.foreground;
  bool initialized = false;
  ClubsUpdateState clubUpdateState;
  AppTextScreen notificationTexts;

  NotificationHandler() {
    FGBGEvents.stream.listen((event) {
      _currentAppState = event;
      log('notifications:: app state: $event');
    });
  }

  void register(ClubsUpdateState clubUpdateState) async {
    _currentAppState = FGBGType.foreground;
    this.notificationTexts = getAppTextScreen("notifications");
    this.clubUpdateState = clubUpdateState;
    // Get the token each time the application loads
    String token = await FirebaseMessaging.instance.getToken();
    await saveFirebaseToken(token);
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveFirebaseToken);

    if (PlatformUtils.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
      } else {}
    }

    // register Nats push notifications
    _registerPushNotifications();
    _androidDetails = AndroidNotificationDetails(
        "com.voyagerent.pokerapp.channel", "pokerapp", "Poker App Channel",
        sound: RawResourceAndroidNotificationSound('check'), playSound: true);
    _iosDetails = IOSNotificationDetails();
    _notificationDetails =
        NotificationDetails(android: _androidDetails, iOS: _iosDetails);
  }

  void playerNotifications(String message) {
    log('playerNotifications: $message');
    // if app is in background, return
    if (_currentAppState != null) {
      if (_currentAppState == FGBGType.background) return;
    }

    dynamic json = jsonDecode(message);
    handlePlayerMessage(json, background: false, firebase: false);
  }

  void clubNotifications(String message) {
    log('clubNotifications: $message');
    if (this.clubUpdateState != null) {
      try {
        Map<String, dynamic> json = jsonDecode(message);
        if (json['type'] == 'CLUB_UPDATED') {
          String clubCode = json['clubCode'];
          String changed = json['changed'];
          this.clubUpdateState.updatedClubCode = clubCode;
          this.clubUpdateState.whatChanged = changed;
          this.clubUpdateState.notify();

          if (changed == 'NEW_MEMBER_REQUEST') {
            // am I the owner of this club?
            if (appState.isClubOwner(clubCode)) {
              String text = this.notificationTexts.getText('newClubMember',
                  values: {
                    'playerName': json['playerName'],
                    'clubCode': clubCode
                  });
              Alerts.showNotification(
                titleText: 'New Member',
                subTitleText: text,
                duration: Duration(seconds: 5),
              );
              Future.delayed(Duration(seconds: 1), () {
                appState.cacheService.getMembers(clubCode, update: true);
              });
            }
          } else if (changed == 'PROMOTED') {
            String playerUuid = json['playerUuid'];
            if (playerUuid == playerState.playerUuid) {
              Alerts.showNotification(
                titleText: 'Promoted',
                subTitleText: 'You are promoted as manager at club ${clubCode}',
                duration: Duration(seconds: 5),
              );
              Future.delayed(Duration(seconds: 1), () async {
                await appState.cacheService.getMembers(clubCode, update: true);
                await appState.cacheService.getClubHomePageData(clubCode);
                await appState.cacheService.getMyClubs(update: true);
                appState.clubUpdated();
              });
            }
          } else if (changed == 'NEW_MEMBER') {
            String playerUuid = json['playerUuid'];
            if (playerUuid == playerState.playerUuid) {
              Alerts.showNotification(
                titleText: 'Membership',
                subTitleText: 'You are approved to join ${clubCode}',
                duration: Duration(seconds: 5),
              );
              Future.delayed(Duration(seconds: 1), () async {
                await appState.cacheService.getClubHomePageData(clubCode);
                await appState.cacheService.getMyClubs(update: true);
                appState.clubUpdated();
              });
            }
            Future.delayed(Duration(seconds: 1), () async {
              await appState.cacheService.getMembers(clubCode, update: true);
              appState.clubUpdated();
            });
          } else if (changed == 'BUYIN_REQUEST') {
            // buyin request
            String clubCode = json['clubCode'];
            String gameCode = json['gameCode'];
            String hostUuid = json['hostUuid'];

            // if I am the host or club owner or club manager, then refresh pending updates
            if (playerState.playerUuid == hostUuid ||
                appState.isClubOwner(clubCode) ||
                appState.isClubManager(clubCode)) {
              appState.refreshPendingApprovals();
            }
          } else if (changed == 'MEMBER_UPDATED') {
            String playerUuid = json['playerUuid'];
            Future.delayed(Duration(seconds: 1), () async {
              await appState.cacheService.getClubHomePageData(clubCode);
              await appState.cacheService.getMyClubs(update: true);
              await appState.cacheService
                  .getMembers(clubCode, updatePlayerUuid: playerUuid);
              appState.clubUpdated();
            });
          }
        }
      } catch (err) {
        // ignore the exception
      }
    }
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    handlePlayerMessage(message.data, background: true, firebase: true);
  }

  Future<FlutterLocalNotificationsPlugin> _initLocalNotifications() async {
    if (_plugin != null) {
      return _plugin;
    }

    var androidSettings = AndroidInitializationSettings('bell');
    var iosSettings = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onTapNotification,
    );

    _plugin = flutterLocalNotificationsPlugin;
    return _plugin;
  }

  Future _onTapNotification(String payload) async {}

  Future _showNotification(
    RemoteMessage message, {
    bool background = false,
  }) async {
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
    final flutterLocalNotificationsPlugin = await _initLocalNotifications();

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

  void _registerPushNotifications() async {
    await _initLocalNotifications();

    // registering for background messages
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Message data: ${jsonEncode(message.data)}');
      handlePlayerMessage(message.data, background: false, firebase: true);
      //_showNotification(message, background: false);
    });
    log('Registered for push notifications');
  }

  void handlePlayerMessage(
    Map<String, dynamic> json, {
    bool background = false,
    bool firebase = false,
  }) {
    String messageId = json['requestId'];
    if (messageId == null) {
      return;
    }
    String now = DateTime.now().toIso8601String();
    log('[$now] Notification: backGround: $background firebase: $firebase Message: $messageId. _handledIds: ${_handledIds}');
    if (_handledIds.indexOf(messageId) != -1) {
      // we handled the message
      return;
    } else {
      _handledIds.add(messageId);
    }
    if (_handledIds.length > 5) {
      _handledIds.removeRange(0, 2);
    }
    log('[$now]***** Notification: backGround: $background firebase: $firebase Message: $messageId. _handledIds: ${_handledIds}');

    String type = json['type'];
    if (background) {
      // we are running in background
      // show the notifications in the notifications bin
      showMessageInBin(json);
    } else {
      // running in foreground
      if (type == 'WAITLIST_SEATING') {
        handleWaitlistNotifications(json);
      } else if (type == 'TEST_PUSH') {
        handleTestMessage(json);
      } else if (type == 'APPCOIN_NEEDED') {
        handleAppCoinNeeded(json);
      } else if (type == 'BUYIN_REQUEST') {
        handleBuyinRequest(json);
      } else if (type == 'NEW_GAME') {
        handleNewGame(json);
      } else if (type == 'GAME_ENDED') {
        handleGameEnded(json);
      } else if (type == 'CLUB_ANNOUNCEMENT') {
        handleClubAnnouncement(json);
      } else if (type == 'SYSTEM_ANNOUNCEMENT') {
        handleSystemAnnouncement(json);
      } else if (type == 'BUYIN_REQUEST') {
        handleBuyinRequest(json);
      } else if (type == 'CREDIT_UPDATE') {
        handleCreditUpdate(json);
      } else if (type == 'GAME_STATUS_CHANGE') {
        handleGameStatusChange(json);
      }
    }
  }

  void showMessageInBin(Map<String, dynamic> json) async {
    // we handle only few messages here
    // NEW_GAME
    // HOST_MESSAGE
    // WAITLIST_SEATING
    String type = json['type'];
    if (!(type == 'NEW_GAME' ||
        type == 'CLUB_CHAT' ||
        type == 'WAITLIST_SEATING' ||
        type == 'HOST_MESSAGE' ||
        type == 'TEST_PUSH' ||
        type == 'SYSTEM_ANNOUNCEMENT' ||
        type == 'CLUB_ANNOUNCEMENT' ||
        type == 'HOST_TO_MEMBER' ||
        type == 'MEMBER_TO_HOST' ||
        type == 'CREDIT_UPDATE')) {
      return;
    }
    String body = '';
    if (type == 'NEW_GAME') {
      try {
        GameType gameType = gameTypeFromStr(json['gameType']);
        String game = gameTypeStr2(gameType);
        int sb = int.parse(json['sb'].toString());
        int bb = int.parse(json['bb'].toString());
        body = 'Club: ${json['clubName']} hosts a new game. $game $sb/$bb';
      } catch (err) {}
    } else if (type == 'CLUB_CHAT') {
      try {
        if (json['chat-type'] == 'TEXT') {
          if (json['text'] != null) {
            body =
                'Club: ${json['clubName']} ${json['playerName']}: ${json['text']}';
          } else {
            return;
          }
        } else if (json['chat-type'] == 'GIPHY') {
          body =
              'Club: ${json['clubName']} ${json['playerName']}: sent an image';
        }
      } catch (err) {}
    } else if (type == 'CREDIT_UPDATE') {
      try {
        /*
        const message: any = {
      type: 'CREDIT_UPDATE',
      clubName: clubName,
      clubCode: clubCode,
      text: text,
      requestId: messageId,
      changeCredit: changeCredit,
      availableCredits: updatedCredits,
      updateType: CreditUpdateType[updateType],
    };
        */
        body = '';
        if (json['updateType'] == 'ADD') {
          body =
              'Club: ${json['clubName']} added ${json['changeCredit']} credits. Credits: ${json['availableCredits']}';
        } else if (json['updateType'] == 'DEDUCT') {
          body =
              'Club: ${json['clubName']} deducted ${json['changeCredit']} credits. Credits: ${json['availableCredits']}';
        } else if (json['updateType'] == 'FEE_CREDIT') {
          body =
              'Club: ${json['clubName']} added ${json['changeCredit']} fee credits. Credits: ${json['availableCredits']}';
        } else if (json['updateType'] == 'CHANGE') {
          body =
              'Club: ${json['clubName']} set credits to ${json['changeCredit']}. Credits: ${json['availableCredits']}';
        }
      } catch (err) {}
    } else if (type == 'WAITLIST_SEATING') {
      try {
        GameType gameType = gameTypeFromStr(json['gameType']);
        String game = gameTypeStr2(gameType);
        int sb = int.parse(json['smallBlind'].toString());
        int bb = int.parse(json['bigBlind'].toString());
        body =
            'A open seat is available at game: ${json['gameCode']}. $game $sb/$bb';
      } catch (err) {}
    } else if (type == 'TEST_PUSH') {
      body = 'This is a test notification!';
    } else if (type == 'SYSTEM_ANNOUNCEMENT') {
      body = json['shortText'];
    } else if (type == 'CLUB_ANNOUNCEMENT') {
      body = json['clubName'] + ': ' + json['shortText'];
    } else if (type == 'HOST_TO_MEMBER') {
      body = json['clubName'] + ' host: ' + json['text'];
    } else if (type == 'MEMBER_TO_HOST') {
      body = json['clubName'] + ' ${json['sender']}: ' + json['text'];
    }
    if (body.length == 0) {
      return;
    }

    final androidSettings = AndroidInitializationSettings('launcher_icon_gray');
    final iosSettings = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final _androidDetails = AndroidNotificationDetails(
        "com.voyagerent.pokerapp.channel", "pokerapp", "Poker App Channel",
        sound: RawResourceAndroidNotificationSound('check'),
        playSound: true,
        color: Color.fromARGB(255, 0, 255, 0));
    final _iosDetails = IOSNotificationDetails();
    final _notificationDetails =
        NotificationDetails(android: _androidDetails, iOS: _iosDetails);
    // log('5 in showMessageInBin');

    await flutterLocalNotificationsPlugin
        .show(
      45678,
      'PokerClubApp',
      body,
      _notificationDetails,
      payload: jsonEncode(json),
    )
        .onError((error, stackTrace) {
      log('Error when showing message. Error: ${error.toString()}');
    }); //, payload: jsonEncode(json));
    // log('6 in showMessageInBin');
  }

  Future<void> handleTestMessage(Map<String, dynamic> json) async {
    await showErrorDialog(
        navigatorKey.currentContext, 'Test', 'This is test message');
  }

  Future<void> handleWaitlistSeatingPush(Map<String, dynamic> json) async {
    String game = '';
    if (json["gameType"] != null) {
      String gameType = json["gameType"].toString();
      String sb = DataFormatter.chipsFormat(
          double.parse(json['smallBlind'].toString()));
      String bb =
          DataFormatter.chipsFormat(double.parse(json['bigBlind'].toString()));
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
          double.parse(json['smallBlind'].toString()),
        );
        String bb = DataFormatter.chipsFormat(
          double.parse(json['bigBlind'].toString()),
        );
        game = ' at $gameType $sb/$bb';
      }
      String title = 'Do you want to take a open seat $game?';
      String subTitle = 'Code: ${json["gameCode"]}';
      if (json['clubName'] != null) {
        subTitle = subTitle + '\n' + 'Club: ${json["clubName"]}';
      }
      final message =
          'A seat is reserved for you in game $game.\n\nDo you want to take the seat?';

      final res = await showWaitlistInvitation(
        navigatorKey.currentContext,
        message,
        10,
      );

      if (res) {
        if (appState.currentScreenGameCode == gameCode) {
          // show notification
          // Alerts.showNotification(
          //   titleText: "Tap on an open seat to join the game!",
          //   duration: Duration(seconds: 10),
          // );

          // we are already in REQ game play screen, no need to navigate
          return;
        }

        if (appState.currentScreenGameCode.isNotEmpty) {
          // then we are in a different game play screen, pop off the old game play screen
          navigatorKey.currentState.pop();
        }

        navigatorKey.currentState.pushNamed(
          Routes.game_play,
          arguments: {
            'gameCode': gameCode,
            'isFromWaitListNotification': true,
          },
        );
      } else {
        // decline the seat
        try {
          await GameService.declineWaitlist(gameCode: gameCode);
        } catch (e) {}
      }
    }
  }

  // handle messages when app is running foreground
  Future<void> handleAppCoinNeeded(Map<String, dynamic> json) async {
    String gameCode = json['gameCode'].toString();
    int endMins = 15;
    if (json['endMins'] != null) {
      endMins = int.parse(json['endMins'].toString());
    }
    final message =
        'Not enough coins to continue game: $gameCode. Game will end in $endMins mins. Please buy more coins to keep the game running.';
    showErrorDialog(navigatorKey.currentContext, 'Coins', message, info: true);
  }

  // handle messages when app is running foreground
  Future<void> handleBuyinRequest(Map<String, dynamic> json) async {
    String gameCode = json['gameCode'].toString();
    String playerName = json['playerName'];
    double amount = double.parse(json['amount'].toString());
    // toggle pending approvals
    Alerts.showNotification(
        titleText: 'Buyin Request',
        subTitleText:
            'Game: $gameCode Player $playerName is requesting ${DataFormatter.chipsFormat(amount)}.',
        duration: Duration(seconds: 5));
    appState.buyinApprovals.shake = true;
    appState.buyinApprovals.notify();
    await Future.delayed(Duration(milliseconds: 500));
    appState.buyinApprovals.shake = false;
    appState.buyinApprovals.notify();
  }

  // handle messages when app is running foreground
  Future<void> handleCreditUpdate(Map<String, dynamic> json) async {
    String text = json['text'].toString();
    String clubName = json['clubName'].toString();
    String clubCode = json['clubCode'].toString();

    // invalidate cache
    appState.cacheService
        .removePlayerActivitiesCache(clubCode, playerState.playerUuid);
    // toggle pending approvals
    Alerts.showNotification(
        titleText: 'Credits: ${clubName}',
        subTitleText: text,
        duration: Duration(seconds: 5));
  }

  Future<void> handleNewGame(Map<String, dynamic> json) async {
    String gameCode = json['gameCode'].toString();
    String gameType = json['gameType'].toString();
    String sb = json['sb'].toString();
    String bb = json['bb'].toString();
    String clubName = json['clubName'].toString();
    if (appState != null) {
      appState.setNewGame(true);
    }
    Alerts.showNotification(
        titleText: 'New Game',
        subTitleText: 'Club $clubName started a new game $gameType $sb/$bb',
        duration: Duration(seconds: 3));
  }

  Future<void> handleGameEnded(Map<String, dynamic> json) async {
    if (appState != null) {
      appState.setGameEnded(true);
    }
  }

  Future<void> handleGameStatusChange(Map<String, dynamic> json) async {
    if (json['status'] == 'ENDED') {
      if (appState != null) {
        appState.setGameEnded(true);
      }
    }
  }

  Future<void> handleClubAnnouncement(Map<String, dynamic> json) async {
    String clubName = json['clubName'].toString();
    Alerts.showNotification(
        titleText: clubName,
        subTitleText: json['shortText'],
        duration: Duration(seconds: 5));
  }

  Future<void> handleSystemAnnouncement(Map<String, dynamic> json) async {
    Alerts.showNotification(
        titleText: 'Announcement',
        subTitleText: json['shortText'],
        duration: Duration(seconds: 5));
  }
}

NotificationHandler notificationHandler = NotificationHandler();

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await notificationHandler._initLocalNotifications();
  notificationHandler.handlePlayerMessage(message.data,
      background: true, firebase: true);
}
