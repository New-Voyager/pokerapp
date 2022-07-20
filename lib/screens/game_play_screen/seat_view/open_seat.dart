import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/widgets/text_widgets/name_plate/open_seat_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class OpenSeat extends StatefulWidget {
  final Seat seat;
  final Function(Seat) onUserTap;
  final bool seatChangeInProgress;
  final bool seatChangeSeat;

  const OpenSeat({
    this.seat,
    this.onUserTap,
    this.seatChangeInProgress,
    this.seatChangeSeat,
//    this.seatChangeNotifier,
    Key key,
  }) : super(key: key);

  @override
  State<OpenSeat> createState() => _OpenSeatState();
}

class _OpenSeatState extends State<OpenSeat> {
  bool dragEnter = false;

  // Widget _openSeat(AppTheme theme) {
  //   if (widget.seatChangeInProgress && widget.seatChangeSeat) {
  //     log('RedrawFooter: open seat ${widget.seatChangeInProgress}');
  //     return Padding(
  //       padding: const EdgeInsets.all(5),
  //       child: DefaultTextStyle(
  //           style: TextStyle(
  //             fontSize: 10.dp,
  //             color: Colors.yellowAccent,
  //             shadows: [
  //               Shadow(
  //                 blurRadius: 7.0,
  //                 color: Colors.white,
  //                 offset: Offset(0, 0),
  //               ),
  //             ],
  //           ),
  //           child: AnimatedTextKit(repeatForever: true, animatedTexts: [
  //             FlickerAnimatedText('Open', speed: Duration(milliseconds: 500))
  //           ])),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(5),
  //     child: FittedBox(
  //       child:
  //           // AnimatedTextKit(repeatForever: true, animatedTexts: [
  //           //       FlickerAnimatedText('Open', speed: Duration(milliseconds: 2000))
  //           //     ]),
  //           Text(
  //         'Open',
  //         style: AppDecorators.getSubtitle1Style(theme: theme),
  //       ),
  //     ),
  //   );
  // }

  Widget openSeatWidget(
      AppTheme theme, List<BoxShadow> shadow, bool seatChangeInProgress) {
    // String text = 'Open';

    // we show an icon if seat is reserved
    // if (widget.seat.reserved) {
    //   text = 'Reserved';
    // }

    Widget openSeat = Container(
      key: UniqueKey(),
      width: 45.0,
      height: 45.0,
      alignment: Alignment.center,
      child: widget.seat.reserved
          ? SvgPicture.asset(
              'assets/images/game/lock.svg',
              color: theme.accentColor,
            )
          : OpenSeatText(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primaryColorWithDark(),
        boxShadow: shadow,
      ),
    );

    if (!seatChangeInProgress) {
      // openSeat = Shimmer.fromColors(
      //       baseColor: Colors.white.withOpacity(0.80),
      //       highlightColor: Colors.transparent,
      //       period: Duration(seconds: 5),
      //       child: openSeat, //_openSeat(theme),
      //     );
    }

    return InkWell(
      splashColor: theme.secondaryColor,
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (widget.seat.reserved) {
          return;
        }
        log('Pressed ${widget.seat.seatPos.toString()}');
        AudioService.playClickSound();
        this.widget.onUserTap(widget.seat);
      },
      child: openSeat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    // log('SeatChange: OpenSeat build  ${widget.seat.serverSeatPos} ${widget.seatChangeInProgress} hostSeatChange: ${gameState.hostSeatChangeInProgress}');
    if (gameState.isTournament) {
      return SizedBox.shrink();
    }
    final theme = AppTheme.getTheme(context);

    return Consumer<SeatChangeNotifier>(builder: (_, scn, __) {
      List<BoxShadow> shadow = [
        BoxShadow(
          color: theme.accentColor,
          blurRadius: 1,
          spreadRadius: 1,
          offset: Offset(1, 0),
        )
      ];
      List<BoxShadow> seatChangeShadow = getShadow(scn, dragEnter, theme);
      if (seatChangeShadow.length > 0) {
        shadow = seatChangeShadow;
      }
      return DragTarget(onLeave: (data) {
        // log('SeatChange: OpenSeat onLeave ${data}');
        dragEnter = false;
        setState(() {});
        return true;
      }, onWillAccept: (data) {
        // log('SeatChange: OpenSeat onWillAccept ${data}');
        dragEnter = true;
        setState(() {});
        return true;
      }, onAccept: (data) {
        // log('SeatChange: OpenSeat onDropped ${data}');
        // call the API to make the seat change
        SeatChangeService.hostSeatChangeMove(
          gameState.gameCode,
          data,
          widget.seat.serverSeatPos,
        );
      }, builder: (context, List<int> candidateData, rejectedData) {
        return openSeatWidget(theme, shadow, scn.seatChangeInProgress);
      });
    });
  }

  List<BoxShadow> getShadow(
    SeatChangeNotifier hostSeatChange,
    //bool isFeedback,
    bool dragEnter,
    AppTheme theme,
  ) {
    if (widget.seatChangeInProgress && dragEnter) {
      return [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 10.0,
          spreadRadius: 30,
        )
      ];
    } else {
      return [];
    }
  }
}
