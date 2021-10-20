import 'dart:io';
import 'dart:async';
import 'dart:developer';

import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokerapp/services/app/player_service.dart';

class LocationUpdates {
  final GameState gameState;
  Timer timer;
  LocationUpdates(this.gameState);
  Location location;
  String ipAddress;
  final Connectivity connectivity = Connectivity();
  Future<void> start() async {
    if (timer != null) {
      timer.cancel();
    }

    try {
      if (gameState.gameInfo.ipCheck) {
        this.ipAddress = await getIp();
        log('LocationUpdate: IP: ${this.ipAddress}');
      }
    } catch (e) {}

    log('LocationUpdate: Started');
    timer = Timer.periodic(Duration(minutes: 1), (t) {
      onTimerExpired();
    });
  }

  Future<bool> requestPermission() async {
    location = new Location();

    PermissionStatus permissionGranted;
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    try {
      final playerLocation = await location.getLocation();
      gameState.currentLocation = playerLocation;
    } catch (err) {
      log('Could not get location');
      return false;
    }
    return true;
  }

  void onTimerExpired() async {
    // get location
    try {
      if (gameState.gameInfo.gpsCheck) {
        final playerLocation = await Location.instance.getLocation();
        gameState.currentLocation = playerLocation;
        log('LocationUpdate: Location $playerLocation');
        PlayerService.updateLocation(playerLocation);
      }
      if (gameState.gameInfo.ipCheck) {
        // update ip address
        String ip = await getIp();
        if (ip != this.ipAddress) {
          log('LocationUpdate: IP Changed Old ip: ${this.ipAddress} New Ip: ${ip}');
          this.ipAddress = ip;
        }
      }

      // update the server
    } catch (err) {
      log('Could not get location');
    }
  }

  Future<String> getIp() async {
    String ipAddress = '';
    try {
      final result = await connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        // get the ip address
        for (var interface in await NetworkInterface.list()) {
          if (interface.name == 'wlan0') {
            for (var addr in interface.addresses) {
              if (addr.type == InternetAddressType.IPv4) {
                ipAddress = addr.address;
              }
              log('${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
            }
          }
        }
      }
    } catch (err) {
      log('Getting ip failed');
    }
    return ipAddress;
  }

  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
  }

  void stop() {
    if (timer != null) {
      timer.cancel();
    }
  }
}
