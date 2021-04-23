import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

///
/// Simple countdown timer.
///
class CountdownMs extends StatefulWidget {
  // Length of the timer

  // current progress
  final int currentSeconds;

  // total length of the timer
  final int totalSeconds;

  // Build method for the timer
  final Widget Function(BuildContext, double) build;

  // Called when finished
  final Function onFinished;

  // Build interval
  final Duration interval;

  // Controller
  final CountdownController controller;

  CountdownMs({
    Key key,
    @required this.totalSeconds,
    @required this.build,
    this.currentSeconds = 0,
    this.interval = const Duration(milliseconds: 100),
    this.onFinished,
    this.controller,
  }) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

///
/// State of timer
///
class _CountdownState extends State<CountdownMs> {
  // Multiplier of secconds
  final int _secondsFactor = 1000000;
  final int _millisecondsFactor = 1000;

  // Timer
  Timer _timer;

  // Current seconds
  int _currentMicroSeconds;

  @override
  void initState() {
    var remainingSeconds = widget.totalSeconds - widget.currentSeconds;
    _currentMicroSeconds = remainingSeconds * _secondsFactor;

    widget.controller?.setOnPause(_onTimerPaused);
    widget.controller?.setOnResume(_onTimerResumed);
    widget.controller?.setOnRestart(_onTimerRestart);
    widget.controller?.isCompleted = false;

    _startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(
      context,
      (widget.currentSeconds * _millisecondsFactor + _currentMicroSeconds) /
          _millisecondsFactor,
    );
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    super.dispose();
  }

  ///
  /// Then timer paused
  ///
  void _onTimerPaused() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
  }

  ///
  /// Then timer resumed
  ///
  void _onTimerResumed() {
    _startTimer();
  }

  ///
  /// Then timer restarted
  ///
  void _onTimerRestart() {
    widget.controller?.isCompleted = false;

    setState(() {
      var remainingSeconds = widget.totalSeconds - widget.currentSeconds;
      _currentMicroSeconds = remainingSeconds * _secondsFactor;
    });

    _startTimer();
  }

  ///
  /// Start timer
  ///
  void _startTimer() {
    if (_timer?.isActive == true) {
      _timer.cancel();

      widget.controller?.isCompleted = true;
    }

    if (_currentMicroSeconds != 0) {
      _timer = Timer.periodic(
        widget.interval,
        (Timer timer) {
          if (_currentMicroSeconds == 0) {
            timer.cancel();

            if (widget.onFinished != null) {
              widget.onFinished();
            }

            widget.controller?.isCompleted = true;
          } else {
            setState(() {
              _currentMicroSeconds =
                  _currentMicroSeconds - widget.interval.inMicroseconds;
            });
          }
        },
      );
    }
  }
}
