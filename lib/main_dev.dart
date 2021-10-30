import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/flavor_config.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/insta_refresh_service.dart';
import 'package:pokerapp/services/connectivity_check/network_change_listener.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/firebase/settings.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'models/ui/app_text.dart';
import 'package:sizer/sizer.dart';

import 'models/ui/app_theme_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register all the models and services before the app starts
  if (Platform.isAndroid) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  await HiveDatasource.getInstance.init();

  var devFlavorApp = FlavorConfig(
    appName: 'PokerDev',
    flavorName: Flavor.DEV.toString(),
    apiBaseUrl: 'https://demo.pokerclub.app',
    child: MyApp(),
  );
  await AppConfig.init(devFlavorApp.apiBaseUrl);
  String apiUrl = AppConfig.apiUrl;
  log('$apiUrl');
  await graphQLConfiguration.init();
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client(),
      child: CacheProvider(
        child: devFlavorApp,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseApp _firebaseApp;
  bool _error = false;

  Future<FirebaseApp> _initialization(BuildContext context) async {
    final apiUrl = FlavorConfig.of(context).apiBaseUrl;
    await AppConfig.init(apiUrl);
    log('Api server url: ${AppConfig.apiUrl}');
    final client = graphQLConfiguration.clientToQuery(noAuthLink: true);
    final opts = await getFirebaseSettings(client);
    final app = Firebase.initializeApp(options: opts);
    return app;
  }

  void _init(BuildContext context) async {
    try {
      await initAppText('en');
      _firebaseApp = await _initialization(context);
    } catch (e) {
      log('$e');
      _error = true;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_firebaseApp == null && _error == false) _init(context);

    // Check for errors
    if (_error) {
      return Container(color: Colors.red);
    }

    if (_firebaseApp == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    // Once complete, show your application

    //this.nats = Nats(context);
    log('Firebase initialized successfully');
    final style = getAppStyle('default');
    return MultiProvider(
      /* PUT INDEPENDENT PROVIDERS HERE */
      providers: [
        // theme related provider
        ListenableProvider<AppTheme>(
          create: (_) => AppTheme(AppThemeData(style: style)),
        ),

        ListenableProvider<PendingApprovalsState>(
          create: (_) => PendingApprovalsState(),
        ),
        ListenableProvider<ClubsUpdateState>(
          create: (_) => ClubsUpdateState(),
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
        ListenableProvider<InstaRefreshService>(
          create: (_) => InstaRefreshService(),
        ),
      ],
      builder: (context, _) => MultiProvider(
        /* PUT DEPENDENT PROVIDERS HERE */
        providers: [
          Provider<Nats>(
            create: (_) => Nats(context),
          ),
          Provider(
            create: (_) => NetworkChangeListener(),
            lazy: false,
          ),
        ],
        child: OverlaySupport.global(
          child: LayoutBuilder(
            builder: (context, constraints) =>
                OrientationBuilder(builder: (context, orientation) {
              return Sizer(
                builder: (context, orientation, deviceType) {
                  // SizerUtil().init(constraints, orientation);
                  //SizerUtil().setScreenSize(constraints, orientation);
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
              );
            }),
          ),
        ),
      ),
    );
  }
}
