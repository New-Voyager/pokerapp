import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/firebase/analytics_service.dart';
import 'package:pokerapp/services/graphQL/configurations/graph_ql_configuration.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/locator.dart';
import 'package:provider/provider.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register all the models and services before the app starts
  setupLocator();
  InAppPurchaseConnection.enablePendingPurchases();

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
                child: MaterialApp(
                  title: 'Poker App',
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  // navigatorObservers: [
                  //   locator<AnalyticsService>().getAnalyticsObserver()
                  // ],
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  onGenerateRoute: Routes.generateRoute,
                  initialRoute: Routes.initial,
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
