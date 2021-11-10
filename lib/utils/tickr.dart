import 'dart:async';

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
    // start a timer
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
