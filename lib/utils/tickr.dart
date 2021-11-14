import 'dart:async';

import 'dart:developer';

class Ticker {
  Timer timer;
  Function onTick;

  Ticker();

  void close() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  void start(Function onTick) {
    if (onTick == null) {
      log('onTick is null in Ticker.start');
      return;
    }
    // start a timer
    onTick();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      onTick();
    });
  }

  void stop() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }
}
