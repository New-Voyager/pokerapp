import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/audio/audio_service.dart';

class OpenSeat extends StatelessWidget {
  //final int seatPos;
  final Seat seat;
  final Function(Seat) onUserTap;
  final bool seatChangeInProgress;
  final bool seatChangeSeat;
  final SeatChangeNotifier seatChangeNotifier;

  const OpenSeat({
    this.seat,
    this.onUserTap,
    this.seatChangeInProgress,
    this.seatChangeSeat,
    this.seatChangeNotifier,
    Key key,
  }) : super(key: key);

  Widget _openSeat(AppTheme theme) {
    if (seatChangeInProgress && seatChangeSeat) {
      log('RedrawFooter: open seat $seatChangeInProgress');
      return Padding(
        padding: const EdgeInsets.all(5),
        child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 10,
              color: Colors.yellowAccent,
              shadows: [
                Shadow(
                  blurRadius: 7.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(repeatForever: true, animatedTexts: [
              FlickerAnimatedText('Open', speed: Duration(milliseconds: 500))
            ])),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: FittedBox(
        child:
            // AnimatedTextKit(repeatForever: true, animatedTexts: [
            //       FlickerAnimatedText('Open', speed: Duration(milliseconds: 2000))
            //     ]),
            Text(
          'Open',
          style: AppDecorators.getSubtitle1Style(theme: theme),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    log('RedrawFooter: open seat ${seat.serverSeatPos} $seatChangeInProgress hostSeatChange: ${gameState.hostSeatChangeInProgress}');

    final theme = AppTheme.getTheme(context);
    List<BoxShadow> shadow = [
      BoxShadow(
        color: theme.accentColor,
        blurRadius: 1,
        spreadRadius: 1,
        offset: Offset(1, 0),
      )
    ];
    List<BoxShadow> seatChangeShadow =
        getShadow(seatChangeNotifier, true, theme);
    if (seatChangeShadow.length > 0) {
      shadow = seatChangeShadow;
    }
    return InkWell(
        splashColor: theme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          log('Pressed ${seat.seatPos.toString()}');
          AudioService.playClickSound();
          this.onUserTap(seat);
        },
        child: Container(
          width: 45.0,
          height: 45.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _openSeat(theme),
            ],
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.primaryColorWithDark(),
            boxShadow: shadow,
            //color: Colors.blue[900],
          ),
        ));
  }

  List<BoxShadow> getShadow(
    SeatChangeNotifier hostSeatChange,
    bool isFeedback,
    AppTheme theme,
  ) {
    BoxShadow shadow;
    if (seatChangeInProgress) {
      return [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 20.0,
          spreadRadius: 8.0,
        )
      ];
    } else {
      return [];
    }

    if (hostSeatChange?.seatChangeInProgress ?? false) {
      //log('SeatChange: [${seat.serverSeatPos}] Seat change in progress');
      SeatChangeStatus seatChangeStatus;
      // are we dragging?
      if (seat != null) {
        seatChangeStatus =
            hostSeatChange.allSeatChangeStatus[seat.localSeatPos];
      }
      if (seatChangeStatus != null) {
        if (seatChangeStatus.isDragging || isFeedback) {
          log('SeatChange: [${seat.localSeatPos}] seatChangeStatus.isDragging: ${seatChangeStatus.isDragging} isFeedback: $isFeedback');
          shadow = BoxShadow(
            color: Colors.green,
            blurRadius: 20.0,
            spreadRadius: 8.0,
          );
        } else if (seatChangeStatus.isDropAble) {
          log('SeatChange: [${seat.localSeatPos}] seatChangeStatus.isDropAble: ${seatChangeStatus.isDropAble} isFeedback: $isFeedback');
          shadow = BoxShadow(
            color: Colors.blue,
            blurRadius: 20.0,
            spreadRadius: 8.0,
          );
        }
      }
    }
    if (shadow == null) {
      return [];
    } else {
      return [shadow];
    }
  }
}
