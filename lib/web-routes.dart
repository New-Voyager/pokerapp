import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/screens/web/web_home_screen.dart';

import 'package:pokerapp/screens/screens.dart';

class WebRoutes {
  WebRoutes._();

  static const String initialRoute = '/';
  static const String gameRoute = 'join-game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WebHomeScreen(),
      );
    }
    var uri = Uri.parse(settings.name);
    var routeName = uri.pathSegments.first;

    switch (routeName) {
      case gameRoute:
        String gameCode;
        bool botGame = false;
        bool isFromWaitListNotification = false;
        GameInfoModel gameInfo;
        gameCode = uri.queryParameters['gameCode'];
        if (gameCode == null) {
          // show an error
        }
        return _getPageRoute(
          routeName: '/game_play',
          viewToShow: GamePlayScreen(
            gameCode: gameCode,
            botGame: false,
            gameInfoModel: gameInfo,
            isFromWaitListNotification: isFromWaitListNotification,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow,
    );
  }
}
