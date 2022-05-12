import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'main_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String apiUrl = 'http://192.168.0.108:9501';
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
    return Container(
      width: 500,
      height: 500,
      color: Colors.red,
    );
  }
}
