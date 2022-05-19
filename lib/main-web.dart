import 'dart:developer';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/flavor_config.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/screen_attributes.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/models/ui/app_theme_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/screens/layouts/layout_holder.dart';
import 'package:pokerapp/screens/web/web_home_screen.dart';
import 'package:pokerapp/services/connectivity_check/network_change_listener.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/web-routes.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'main_helper.dart';

String kWebPlayerUuid = 'd7102747-a8de-4c49-ba91-322ee7a4f827';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformUtils.isWeb = true;
  await DeviceInfo.init();
  await initAppText('en');

  ScreenAttributes.buildList();

  String apiUrl = 'https://api.pokerclub.app';
  apiUrl = 'http://192.168.1.100:9501';

  log('$apiUrl');
  await graphQLConfiguration.init(apiUrl: apiUrl);
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client(),
      child: CacheProvider(
        child: MyWebApp(),
      ),
    ),
  );

  //runApp(MyWebApp());
}

class MyWebApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _MyWebAppState createState() => _MyWebAppState();
}

class _MyWebAppState extends State<MyWebApp> {
  bool _error = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check for errors
    if (_error) {
      return Container(color: Colors.red);
    }

    //this.nats = Nats(context);
    final style = getAppStyle('default');
    //String gameCode = Uri.base.queryParameters["gameCode"];
    //log('gameCode: $gameCode');
    return MultiProvider(
      /* PUT INDEPENDENT PROVIDERS HERE */
      providers: [
        // theme related provider
        ListenableProvider<AppTheme>(
          create: (_) => AppTheme(AppThemeData(style: style)),
        ),

        ListenableProvider<PendingApprovalsState>(
          create: (_) => appState.buyinApprovals,
        ),
        ListenableProvider<ClubsUpdateState>(
          create: (_) => appState.clubUpdateState,
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => appState,
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
          // Layout related provider
          ChangeNotifierProvider(
            create: (_) => LayoutHolder(),
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
                  final appTheme = context.read<AppTheme>();
                  return MaterialApp(
                    title: "PokerWebApp",
                    debugShowCheckedModeBanner: false,
                    navigatorKey: navigatorKey,
                    theme: ThemeData(
                      colorScheme: ColorScheme.dark(),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      fontFamily: AppAssetsNew.fontFamilyPoppins,
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: appTheme.accentColor,
                      ),
                    ),
                    onGenerateRoute: WebRoutes.generateRoute,
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
