import 'dart:io';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:provider/provider.dart';
import 'main.dart';

import 'flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register all the models and services before the app starts
  if (Platform.isAndroid) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }  
  await HiveDatasource.getInstance.init();

  var prodFlavorApp = FlavorConfig(
    appName: 'Poker Club',
    flavorName: Flavor.PROD.toString(),
    apiBaseUrl: 'https://api.pokerapp.club',
    child: MyApp(),
  );

  runApp(
    GraphQLProvider(
      //client: graphQLConfiguration.client,
      child: CacheProvider(
        child: prodFlavorApp,
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
              // theme related provider
              ListenableProvider<AppTheme>(
                create: (_) => AppTheme(AppThemeData()),
              ),
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
                      //SizerUtil().init(constraints, orientation);
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
