import 'dart:async';
import 'dart:developer';

import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:location/location.dart';

class LocationUpdates {
  final GameState gameState;
  Timer timer;
  LocationUpdates(this.gameState);
  Location location;
  void start() {
    if (timer != null) {
      timer.cancel();
    }
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
      final playerLocation = await Location.instance.getLocation();
      gameState.currentLocation = playerLocation;

      // update the server
    } catch (err) {
      log('Could not get location');
    }
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
