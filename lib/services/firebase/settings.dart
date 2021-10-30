import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<FirebaseOptions> getFirebaseSettings(GraphQLClient noAuthClient) async {
  String _query = """
    query firebaseSettings {
      firebaseSettings {
        androidApiKey
        iosApiKey
        androidAppId
        iosAppId
        projectId
        authDomain
        databaseURL
        storageBucket
        messagingSenderId
        measurementId
      }
    }
  """;

  try {
    QueryResult result =
        await noAuthClient.query(QueryOptions(document: gql(_query)));

    if (result.hasException) {
      return null;
    }

    Map settings = result.data['firebaseSettings'];
    if (Platform.isAndroid) {
      settings['apiKey'] = settings['androidApiKey'];
      settings['appId'] = settings['androidAppId'];
    } else if (Platform.isIOS) {
      settings['apiKey'] = settings['iosApiKey'];
      settings['appId'] = settings['iosAppId'];
    }
    final fbOptions = FirebaseOptions.fromMap(settings);
    return fbOptions;
  } catch (err) {
    log('Error: ${err.toString()}');
    return null;
  }
}
