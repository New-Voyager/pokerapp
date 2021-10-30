import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/pulsating_button.dart';
import 'package:pokerapp/widgets/buttons.dart';

import 'game_circle_button.dart';

class VoiceTextWidget extends StatefulWidget {
  final Function recordStart, recordStop, recordCancel;
  const VoiceTextWidget(
      {Key key, this.recordStart, this.recordStop, this.recordCancel})
      : super(key: key);

  @override
  _VoiceTextWidgetState createState() => _VoiceTextWidgetState();
}

class _VoiceTextWidgetState extends State<VoiceTextWidget> {
  bool _longPressed = false;
  Timer _timerPeriodic;
  int _recSeconds = 10;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("voiceTextWidget");

    super.initState();
  }

  @override
  void dispose() {
    if (_timerPeriodic?.isActive ?? false) _timerPeriodic.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    return Container(
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      child: GestureDetector(
          onLongPressStart: (details) {
            _recSeconds = 10;
            _timerPeriodic = Timer.periodic(Duration(seconds: 1), (timer) {
              _recSeconds--;
              if (_recSeconds < 0) {
                _timerPeriodic.cancel();
                _longPressed = false;
                widget.recordStop.call(10);
              }
              setState(() {});
            });
            setState(() {
              _longPressed = true;
            });
            widget.recordStart.call();
          },
          onLongPressMoveUpdate: (details) {
            if (details.localOffsetFromOrigin.dx < -70) {
              if (_timerPeriodic.isActive) {
                _timerPeriodic.cancel();
                setState(() {
                  _longPressed = false;
                });
                widget.recordCancel.call();
              }
            }
          },
          onLongPressEnd: (details) {
            if (_timerPeriodic.isActive) {
              _timerPeriodic.cancel();
            }
            setState(() {
              _longPressed = false;
            });

            widget.recordStop.call(11 - _recSeconds);
          },
          child: _longPressed
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.black45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            " $_recSeconds ${_appScreenText['sec']} ",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            _appScreenText['slideToCancel'],
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    AppDimensionsNew.getHorizontalSpace(8),
                    PulsatingCircleIconButton(
                      child: Icon(
                        Icons.keyboard_voice,
                        color: Colors.white,
                        size: 24,
                      ),
                      onTap: () {},
                      color: Colors.red,
                    ),
                  ],
                )
              : CircleImageButton(
                  icon: Icons.keyboard_voice,
                  onTap: () {},
                  theme: theme,
                )),
    );
  }
}
