import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:provider/provider.dart';

class NetworkChangeListener {
  StreamSubscription<ConnectivityResult> _sub;
  NetworkConnectionDialog _dialog;

  StreamController<ConnectivityResult> _streamController =
      StreamController.broadcast();

  Stream<ConnectivityResult> get onConnectivityChange =>
      _streamController.stream;

  Future<void> _rerestablishNats() async {
    final BuildContext context = navigatorKey.currentState.overlay.context;
    await context.read<Nats>().reconnect();
  }

  Future<bool> _checkForInternetConnection() async {
    final bool hasInternet = await DataConnectionChecker().hasConnection;

    // use navigator's context
    final BuildContext context = navigatorKey.currentState.overlay.context;

    if (hasInternet) {
      // we have internet
      // dismiss any dialog if open
      _dialog?.dismiss(context: context);
      return true;
    }

    // if there is no internet show a dialog
    _dialog?.show(
      context: context,
      loadingText: 'No Internet',
    );
    return false;
  }

  void _onConnectivityChanged(ConnectivityResult result) async {
    log('network_change onConnectivityChanged: $result');
    final bool hasInternet = await _checkForInternetConnection();
    if (!hasInternet) return;

    // if here - means we have internet
    // re establish connection to NATS
    await _rerestablishNats();

    // after nats connection reestablishes
    // as state changed (some states in a screen may need to refresh), add event to stream so that listeners can respond
    _streamController.add(result);
  }

  NetworkChangeListener() {
    log('NetworkChangeListener :: constructor');
    // listen for connectivity changes - and then check for internet connection
    _sub = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);

    _dialog = NetworkConnectionDialog();

    // check for internet connection for the first time too
    _checkForInternetConnection();
  }

  void dispose() {
    _streamController.close();
    _sub?.cancel();
  }
}
