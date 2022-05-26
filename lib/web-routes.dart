import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/screens/web/web_game_play_screen.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:provider/provider.dart';

import 'screens/game_play_screen/game_play_screen.dart';

class WebRoutes {
  WebRoutes._();

  static const String initialRoute = '/';
  static const String gameRoute = 'join-game';
  static const String testRoute = 'test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      // test service
      // return _getPageRoute(
      //   routeName: settings.name,
      //   viewToShow: WebGamePlayScreen(
      //     gameCode: "CG-8QI4TZBWJRQAXN",
      //     isBotGame: false,
      //     // gameInfoModel: gameInfo,
      //     isFromWaitListNotification: false,
      //   ),
      // );

      String gameCode = 'pgxzpfep';
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: GamePlayScreen(
          gameCode: gameCode,
          botGame: false,
          gameInfoModel: null,
          isFromWaitListNotification: false,
        ),
      );
    }
    var uri = Uri.parse(settings.name);
    var routeName = uri.pathSegments.first;

    switch (routeName) {
      case gameRoute:
        final String gameCode =
            uri.queryParameters['gameCode'] ?? TestService.gameInfo.gameCode;
        final bool isBotGame = uri.queryParameters['botGame'] ?? false;
        final bool isFromWaitListNotification = false;

        return _getPageRoute(
          routeName: settings.name,
          viewToShow: Provider(
              create: (_) => GameState(),
              builder: (_, __) {
                return WebGamePlayScreen(
                  gameCode: gameCode,
                  isBotGame: isBotGame,
                  // gameInfoModel: gameInfo,
                  isFromWaitListNotification: isFromWaitListNotification,
                );
              }),
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
