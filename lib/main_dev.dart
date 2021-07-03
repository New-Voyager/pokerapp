import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/flavor_config.dart';
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
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register all the models and services before the app starts
  InAppPurchaseConnection.enablePendingPurchases();

  await HiveDatasource.getInstance.init();

  var devFlavorApp = FlavorConfig(
    appName: 'PokerDev',
    flavorName: Flavor.DEV.toString(),
    apiBaseUrl: 'https://dev.pokerapp.club',
    child: MyApp(),
  );

  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(
        child: devFlavorApp,
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
                        title: FlavorConfig.of(context).appName,
                        debugShowCheckedModeBanner: false,
                        navigatorKey: navigatorKey,
                        theme: ThemeData(
                          colorScheme: ColorScheme.dark(),
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          fontFamily: AppAssetsNew.fontFamilyPoppins,
                        ),
                        onGenerateRoute: Routes.generateRoute,
                        initialRoute: Routes.initial,
                        navigatorObservers: [routeObserver],
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
