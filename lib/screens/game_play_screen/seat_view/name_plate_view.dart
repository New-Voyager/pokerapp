import 'dart:developer';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/milliseconds_counter.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/plate_border.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

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
    /* changing background color as per last action
    * check/call -> green
    * raise/bet -> shade of yellow / blue might b? */

    Color statusColor = const Color(0xff474747); // default color
    Color boxColor = const Color(0xff474747); // default color
    final openSeat = seat.isOpen;
    String action = !openSeat ? seat.player.action : '';
    if (action != null) {
      if (action.toUpperCase().contains('CHECK') ||
          action.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (action.toUpperCase().contains('RAISE') ||
          action.toUpperCase().contains('BET')) statusColor = Colors.red;
    }
    return Consumer2<HostSeatChange, GameContextObject>(
        key: globalKey,
        builder: (
          context,
          hostSeatChange,
          gameContextObject,
          _,
        ) {
          Widget widget;
          if (gameContextObject.isAdmin() &&
              hostSeatChange.seatChangeInProgress) {
            widget = Draggable(
              data: seat.serverSeatPos,
              onDragEnd: (_) {
                hostSeatChange.onSeatDragEnd();
              },
              onDragStarted: () {
                hostSeatChange.onSeatDragStart(seat.serverSeatPos);
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
            widget = buildSeat(context, hostSeatChange);
          }
          return widget;
        });
  }

  /*
   * This function returns shadow around the nameplate based on the state.
   *
   * winner: shows green shadow
   * player to act: shows white shadow
   * green: when holding a seat during seat change process
   * blue: shows when a moving seat can be dropped
   */
  List<BoxShadow> getShadow(HostSeatChange hostSeatChange, bool isFeedback) {
    BoxShadow shadow;
    bool winner = seat.player.winner ?? false;
    bool highlight = seat.player.highlight ?? false;
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
      SeatChangeStatus seatChangeStatus;
      // are we dragging?
      if (seat.serverSeatPos != null) {
        seatChangeStatus =
            hostSeatChange.allSeatChangeStatus[seat.serverSeatPos];
      }
      if (seatChangeStatus != null) {
        if (seatChangeStatus.isDragging || isFeedback) {
          shadow = BoxShadow(
            color: Colors.green,
            blurRadius: 20.0,
            spreadRadius: 20.0,
          );
        } else if (seatChangeStatus.isDropAble) {
          shadow = BoxShadow(
            color: Colors.blue,
            blurRadius: 20.0,
            spreadRadius: 20.0,
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

  Widget buildSeat(
    BuildContext context,
    HostSeatChange hostSeatChange, {
    bool isFeedBack = false,
    bool childWhenDragging = false,
  }) {
    // log('rebuild seat ${seat.serverSeatPos}');
    final shadow = getShadow(hostSeatChange, isFeedBack);

    Widget plateWidget;
    if (seat.player.highlight) {
      int remaining = seat.actionTimer.getRemainingTime();
      int total = seat.actionTimer.getTotalTime();
      int current = total - remaining;
      final int totalMs = seat.actionTimer.getTotalTime() * 1000;
      plateWidget = CountdownMs(
          totalSeconds: total,
          currentSeconds: current,
          build: (_, time) {
            int remainingMs = totalMs - time.toInt();
            // log('rebuild plate: current: $remainingMs, total: $totalMs');
            return PlateWidget(
              remainingMs,
              totalMs,
              showProgress: true,
            );
          });
    } else {
      plateWidget = PlateWidget(
        0,
        0,
        showProgress: false,
      );
    }

    return Opacity(
      opacity: childWhenDragging ? 0.50 : 1.0,
      child: Transform.scale(
        scale:
            boardAttributes.getNameplateScale(), // NOTE: 10inch 2.0, 7 inch 1.5
        child: Container(
          width: boardAttributes.namePlateSize.width,
          height: boardAttributes.namePlateSize.height,
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // borderRadius: BorderRadius.circular(5),
            // color: Color(0XFF494444),
            // border: Border.all(
            //   color: AppColors.plateBorderColor,
            //   width: 2.0,
            // ),
            boxShadow: shadow,
          ),
          child: Stack(
            children: [
              // name plate border
              Container(
                width: 75,
                height: 50,

                // width: boardAttributes.namePlateSize.width,
                // height: boardAttributes.namePlateSize.height,
                child: plateWidget,
              ),
              AnimatedSwitcher(
                duration: AppConstants.animationDuration,
                reverseDuration: AppConstants.animationDuration,
                child: AnimatedOpacity(
                  duration: AppConstants.animationDuration,
                  opacity: seat.isOpen ? 0.0 : 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        child: Text(
                          seat.player.name,
                          style: AppStyles.gamePlayScreenPlayerName.copyWith(
                            // FIXME: may be this is permanant?
                            color: Colors.white,
                          ),
                        ),
                      ),
                      PlayerViewDivider(),
                      Align(
                        alignment: Alignment.centerRight,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(BuildContext context) {
    if (!seat.player.allIn &&
        seat.player.stack == 0 &&
        seat.player.buyInTimeExpAt != null) {
      final now = DateTime.now().toUtc();
      final diff = seat.player.buyInTimeExpAt.difference(now);

      final nowTime = now.toIso8601String();
      final buyInTime = seat.player.buyInTimeExpAt.toIso8601String();
      // log('nowTime: $nowTime buyInTime: $buyInTime');

      return buyInTimer(context, diff.inSeconds);
    } else if (seat.player.inBreak && seat.player.breakTimeExpAt != null) {
      final now = DateTime.now().toUtc();
      final diff = seat.player.buyInTimeExpAt.difference(now);
      return buyInTimer(context, diff.inSeconds);
    } else {
      return stack(context);
    }
  }

  Widget stack(BuildContext context) {
    return Text(
      seat.player.stack?.toString() ?? 'XX',
      style: AppStyles.gamePlayScreenPlayerChips.copyWith(
        // FIXME: may be this is permanant?
        color: Colors.white,
      ),
    );
  }

  Widget buyInTimer(BuildContext context, int time) {
    return Countdown(
        seconds: time,
        onFinished: () {
          if (seat.isMe) {
            // hide buyin button
            final gameState = GameState.getState(context);
            final players = gameState.getPlayers(context);
            seat.player.showBuyIn = false;
            players.notifyAll();
            seat.notify();
          }
        },
        build: (_, time) {
          if (time <= 10) {
            return BlinkText(_printDuration(Duration(seconds: time.toInt())),
                style: AppStyles.itemInfoTextStyle.copyWith(
                  color: Colors.white,
                ),
                beginColor: Colors.white,
                endColor: Colors.orange,
                times: time.toInt(),
                duration: Duration(seconds: 1));
          } else {
            return Text(
              _printDuration(Duration(seconds: time.toInt())),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            );
          }
        });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    if (duration.inSeconds <= 0) {
      return '0:00';
    }
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
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
            borderRadius: BorderRadius.circular(5)),
        height: 1,
        width: double.infinity,
      ),
    );
  }
}
