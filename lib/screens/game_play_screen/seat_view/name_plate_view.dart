import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_reload_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/milliseconds_counter.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/plate_border.dart';
import 'package:provider/provider.dart';

class NamePlateWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final Seat seat;
  final BoardAttributesObject boardAttributes;

  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

  NamePlateWidget(
    this.seat, {
    @required this.globalKey,
    @required this.boardAttributes,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<SeatChangeNotifier, GameContextObject>(
      key: globalKey,
      builder: (
        context,
        hostSeatChange,
        gameContextObject,
        _,
      ) {
        Widget displayWidget;

        if (gameContextObject.isHost() && hostSeatChange.seatChangeInProgress) {
          log('SeatChange: Seat change in progress: building seat [${seat.serverSeatPos}]');
          displayWidget = Draggable(
            data: seat.serverSeatPos,
            onDragEnd: (_) {
              hostSeatChange.onSeatDragEnd();
            },
            onDragStarted: () {
              hostSeatChange.onSeatDragStart(seat.serverSeatPos);
            },
            onDraggableCanceled: (_, __) {
              hostSeatChange.onSeatDragEnd();
            },
            feedback: buildSeat(
              context,
              hostSeatChange,
              isFeedBack: true,
            ),
            child: buildSeat(context, hostSeatChange),
            childWhenDragging: buildSeat(
              context,
              hostSeatChange,
              childWhenDragging: true,
            ),
          );
        } else {
          displayWidget = buildSeat(context, hostSeatChange);
        }
        return displayWidget;
      },
    );
  }

  /*
   * This function returns shadow around the nameplate based on the state.
   *
   * winner: shows green shadow
   * player to act: shows white shadow
   * green: when holding a seat during seat change process
   * blue: shows when a moving seat can be dropped
   */
  List<BoxShadow> getShadow(
    SeatChangeNotifier hostSeatChange,
    bool isFeedback,
  ) {
    BoxShadow shadow;
    bool winner = seat.player?.winner ?? false;
    bool highlight = seat.player?.highlight ?? false;
    if (winner) {
      shadow = BoxShadow(
        color: Colors.lightGreen,
        blurRadius: 50.0,
        spreadRadius: 20.0,
      );
    } else if (highlight) {
      shadow = BoxShadow(
        color: highlightColor.withAlpha(120),
        blurRadius: 20.0,
        spreadRadius: 20.0,
      );
    } else {
      if (hostSeatChange?.seatChangeInProgress ?? false) {
        //log('SeatChange: [${seat.serverSeatPos}] Seat change in progress');
        SeatChangeStatus seatChangeStatus;
        // are we dragging?
        if (seat.serverSeatPos != null) {
          seatChangeStatus =
              hostSeatChange.allSeatChangeStatus[seat.serverSeatPos];
        }
        if (seatChangeStatus != null) {
          if (seatChangeStatus.isDragging || isFeedback) {
            log('SeatChange: [${seat.serverSeatPos}] seatChangeStatus.isDragging: ${seatChangeStatus.isDragging} isFeedback: $isFeedback');
            shadow = BoxShadow(
              color: Colors.green,
              blurRadius: 20.0,
              spreadRadius: 8.0,
            );
          } else if (seatChangeStatus.isDropAble) {
            log('SeatChange: [${seat.serverSeatPos}] seatChangeStatus.isDropAble: ${seatChangeStatus.isDropAble} isFeedback: $isFeedback');
            shadow = BoxShadow(
              color: Colors.blue,
              blurRadius: 20.0,
              spreadRadius: 8.0,
            );
          }
        }
      }
    }
    if (shadow == null) {
      return [];
    } else {
      return [shadow];
    }
  }

  Widget buildSeat(
    BuildContext context,
    SeatChangeNotifier hostSeatChange, {
    bool isFeedBack = false,
    bool childWhenDragging = false,
  }) {
    // log('rebuild seat ${seat.serverSeatPos}');
    final shadow = getShadow(hostSeatChange, isFeedBack);

    Widget plateWidget;

/*
[log] Timer remaining: 6698 total: 30 current: 23
[log] Rebuilding highlight remaining: 7 total: 30 current: 23
[log] Timer remaining: 22977 total: 30 current: 7
*/
    if (seat.player?.highlight ?? false) {
      int current = seat.actionTimer.getProgressTime();
      int total = seat.actionTimer.getTotalTime();
      final int totalMs = seat.actionTimer.getTotalTime() * 1000;

      //log('Rebuilding highlight remaining: ${remaining} total: ${total} current: ${current}');

      plateWidget = CountdownMs(
        totalSeconds: total,
        currentSeconds: current,
        build: (_, time) {
          int total = seat.actionTimer.getTotalTime();
          int remainingSeconds = time.toInt() ~/ 1000;
          seat.setProgressTime(total - remainingSeconds);

          //int progress = seat.actionTimer.getProgressTime();
          int currentProgress = total * 1000 - time.toInt();
          //log('Rebuilding highlight remaining: ${time.toInt() ~/ 1000} total: ${total} current: ${total - remainingSeconds}');

          return PlateWidget(
            currentProgress,
            totalMs,
            showProgress: true,
          );
        },
      );
    } else {
      //log('Rebuilding no highlight');
      plateWidget = PlateWidget(
        0,
        0,
        showProgress: false,
      );
    }

    return Opacity(
      opacity: childWhenDragging ? 0.50 : 1.0,
      child: Container(
        width: boardAttributes.namePlateSize.width,
        height: boardAttributes.namePlateSize.height,
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          boxShadow: shadow,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // name plate
            Container(
              width: double.infinity,
              height: double.infinity,
              child: plateWidget,
            ),

            /* main body contents */
            AnimatedOpacity(
              duration: AppConstants.animationDuration,
              opacity: seat.isOpen ? 0.0 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // player name
                  FittedBox(
                    child: Text(
                      seat.player?.name ?? '',
                      style: AppStyles.gamePlayScreenPlayerName.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // divider
                  PlayerViewDivider(),

                  // bottom widget - to show stack, sit back time, etc.
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FittedBox(
                        child: bottomWidget(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomWidget(BuildContext context) {
    if (seat.player.inBreak && seat.player.breakTimeExpAt != null) {
      return GamePlayScreenUtilMethods.breakBuyIntimer(
        context,
        seat,
      );
    }

    if (seat.player.action.action != HandActions.ALLIN &&
        seat.player.stack == 0 &&
        seat.player.buyInTimeExpAt != null) {
      return GamePlayScreenUtilMethods.breakBuyIntimer(context, seat);
    } else {
      if (seat.player != null) {
        return stack(context);
      } else {
        return Container();
      }
    }
  }

  Widget stack(BuildContext context) {
    Widget _buildStackTextWidget(int stack) => Text(
          stack?.toString() ?? 'XX',
          style: AppStyles.gamePlayScreenPlayerChips.copyWith(
            color: Colors.white,
          ),
        );

    if (seat.player.reloadAnimation == true)
      return StackReloadAnimatingWidget(
        stackReloadState: seat.player.stackReloadState,
        stackTextBuilder: _buildStackTextWidget,
      );

    return _buildStackTextWidget(seat.player.stack);
  }

  // Widget buyInTimer(BuildContext context, int time) {
  //   return Countdown(
  //       seconds: time,
  //       onFinished: () {
  //         if (seat.isMe) {
  //           // hide buyin button
  //           final gameState = GameState.getState(context);
  //           final players = gameState.getPlayers(context);
  //           seat.player.showBuyIn = false;
  //           players.notifyAll();
  //           seat.notify();
  //         }
  //       },
  //       build: (_, time) {
  //         if (time <= 10) {
  //           return BlinkText(_printDuration(Duration(seconds: time.toInt())),
  //               style: AppStyles.itemInfoTextStyle.copyWith(
  //                 color: Colors.white,
  //               ),
  //               beginColor: Colors.white,
  //               endColor: Colors.orange,
  //               times: time.toInt(),
  //               duration: Duration(seconds: 1));
  //         } else {
  //           return Text(
  //             _printDuration(Duration(seconds: time.toInt())),
  //             style: AppStyles.itemInfoTextStyle.copyWith(
  //               color: Colors.white,
  //             ),
  //           );
  //         }
  //       });
  // }

  // String _printDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   if (duration.inSeconds <= 0) {
  //     return '0:00';
  //   }
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$twoDigitMinutes:$twoDigitSeconds";
  // }
}

class PlayerViewDivider extends StatelessWidget {
  const PlayerViewDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 129, 129, 129),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 1,
        width: double.infinity,
      ),
    );
  }
}
