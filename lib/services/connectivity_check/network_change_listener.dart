import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:provider/provider.dart';

class NetworkChangeListener {
  StreamSubscription<ConnectivityResult> _sub;
  StreamSubscription<DataConnectionStatus> _internetSub;

  bool _startListening = false;
  bool _checkForInternetInProgress = false;

  NetworkConnectionDialog _dialog;

  final DataConnectionChecker _dataConnectionChecker = DataConnectionChecker();
  final Connectivity _connectivity = Connectivity();

  final StreamController<ConnectivityResult> _streamController =
      StreamController.broadcast();

  Future<void> checkInternet() => _checkForInternetConnection();

  Stream<ConnectivityResult> get onConnectivityChange =>
      _streamController.stream;

  Future<void> _rerestablishNats() async {
    final BuildContext context = navigatorKey.currentState.overlay.context;
    await context.read<Nats>().reconnect();
  }

  // if there is no internet connection, this function keeps waiting
  // and on internet availability, this function completes
  Future<void> _checkForInternetConnection() async {
    // use navigator's context
    final BuildContext context = navigatorKey.currentState.overlay.context;

    // else keep on checking for internet access
    while (!(await _dataConnectionChecker.hasConnection)) {
      // we dont have internet
      // show the dialog box
      _dialog?.show(
        context: context,
        loadingText: 'No Internet',
      );

      // wait for a bit
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // if we are outside the while loop, means we have internet connection
    // dismiss the dialog box
    _dialog?.dismiss(context: context);
  }

  set startListening(bool v) => _startListening = v;
  void _connectivityCheck(ConnectivityResult result) async {
    log('network_reconnect onConnectivityChanged: $result');

    // if we are already checking for internet, return
    if (_checkForInternetInProgress || !_startListening) return;
    _checkForInternetInProgress = true;

    // this call waits for indefinite amount of time - until we get internet access
    await _checkForInternetConnection();

    log('network_reconnect: We got back Internet Access');

    // if here - means we have internet
    // re establish connection to NATS
    await _rerestablishNats();

    // after nats connection reestablishes
    // as state changed (some states in a screen may need to refresh), add event to stream so that listeners can respond
    _streamController.add(result);

    // internet check is completed
    _checkForInternetInProgress = false;
  }

  // we need this method in EDGE cases, for example,
  // if my phone is connected to wifi, and for some reason
  // the router looses internet access - my app should be able
  // to detect the internet failure (without wifi - lte changes)
  void _dataConnectionCheckListener(DataConnectionStatus status) async {
    if (status == DataConnectionStatus.disconnected) {
      _connectivityCheck(await _connectivity.checkConnectivity());
    }
  }

  void _initDataConnectionChecker() {
    // set up addresses to check for
    _dataConnectionChecker.addresses = [
      AddressCheckOptions(
        InternetAddress('8.8.8.8'),
      ),
      AddressCheckOptions(
        InternetAddress('8.8.4.4'),
      ),
      AddressCheckOptions(
        InternetAddress('1.1.1.1'),
      ),
    ];

    // this checks for internet access every 5 seconds
    _dataConnectionChecker.checkInterval = const Duration(seconds: 5);
  }

  NetworkChangeListener() {
    log('NetworkChangeListener :: constructor');

    // setup data connection checker
    _initDataConnectionChecker();

    // listen for connectivity changes - and then check for internet connection
    _sub = _connectivity.onConnectivityChanged.listen(_connectivityCheck);
    _internetSub = _dataConnectionChecker.onStatusChange
        .listen(_dataConnectionCheckListener);

    // instantiate the dialog object
    _dialog = NetworkConnectionDialog();

    // check for internet connection for the first time
    _connectivity
        .checkConnectivity()
        .then((result) => _connectivityCheck(result));
  }

  void dispose() {
    _streamController.close();
    _sub?.cancel();
    _internetSub?.cancel();
  }
}
