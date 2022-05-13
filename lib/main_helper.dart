import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/services/graphQL/configurations/graph_ql_configuration.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
mixin RouteAwareAnalytics<T extends StatefulWidget> on State<T>
    implements RouteAware {
  String get routeName => null;

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    // Called when the top route has been popped off,
    // and the current route shows up.
    _setCurrentScreen(routeName);
  }

  @override
  void didPush() {
    // Called when the current route has been pushed.
    _setCurrentScreen(routeName);
  }

  @override
  void didPushNext() {}

  Future<void> _setCurrentScreen(String routeName) async {
    routeName = routeName.substring(1);
    log('Setting current screen to $routeName');
    // await FirebaseAnalytics.instance
    //     .logEvent(name: routeName, parameters: {"screen_name": routeName});
  }
}
