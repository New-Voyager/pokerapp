import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/graphQL/configurations/graph_ql_configuration.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:sizer/sizer.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register all the models and services before the app starts
  InAppPurchaseConnection.enablePendingPurchases();

  await HiveDatasource.getInstance.init();

  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Firebase initialization failed! ${snapshot.error.toString()}');
          return Text('Something went wrong!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //this.nats = Nats(context);
          print('Firebase initialized successfully');
          return MultiProvider(
            /* PUT INDEPENDENT PROVIDERS HERE */
            providers: [
              ListenableProvider<PendingApprovalsState>(
                create: (_) => PendingApprovalsState(),
              ),
              ListenableProvider<ClubsUpdateState>(
                create: (_) => ClubsUpdateState(),
              ),
            ],
            builder: (context, _) => MultiProvider(
              /* PUT DEPENDENT PROVIDERS HERE */
              providers: [
                Provider<Nats>(
                  create: (_) => Nats(context),
                ),
              ],
              child: OverlaySupport.global(
                child: LayoutBuilder(
                  builder: (context, constraints) => OrientationBuilder(
                    builder: (context, orientation) {
                      SizerUtil().init(constraints, orientation);
                      return MaterialApp(
                        title: 'Poker App',
                        debugShowCheckedModeBanner: false,
                        navigatorKey: navigatorKey,
                        // navigatorObservers: [
                        //   locator<AnalyticsService>().getAnalyticsObserver()
                        // ],
                        theme: ThemeData(
                          colorScheme: ColorScheme.dark(),
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          fontFamily: AppAssetsNew.fontFamilyPoppins,
                        ),
                        onGenerateRoute: Routes.generateRoute,
                        initialRoute: Routes.initial,
                        navigatorObservers: [
                          routeObserver,
                          /*  FirebaseAnalyticsObserver(
                              analytics: FirebaseAnalytics()),*/
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

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
    print('Setting current screen to $routeName');
    await FirebaseAnalytics()
        .logEvent(name: routeName, parameters: {"screen_name": routeName});
  }
}
