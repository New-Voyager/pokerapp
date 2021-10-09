import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/nameplate_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_reload_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/milliseconds_counter.dart';
import 'package:pokerapp/widgets/nameplate.dart';
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
    return Consumer3<SeatChangeNotifier, GameContextObject, AppTheme>(
      key: globalKey,
      builder: (
        context,
        hostSeatChange,
        gameContextObject,
        theme,
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
              theme,
              isFeedBack: true,
            ),
            child: buildSeat(context, hostSeatChange, theme),
            childWhenDragging: buildSeat(
              context,
              hostSeatChange,
              theme,
              childWhenDragging: true,
            ),
          );
        } else {
          displayWidget = buildSeat(context, hostSeatChange, theme);
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
    AppTheme theme,
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
        color: highlightColor.withAlpha(80),
        blurRadius: 10.0,
        spreadRadius: 10.0,
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
    SeatChangeNotifier hostSeatChange,
    AppTheme theme, {
    bool isFeedBack = false,
    bool childWhenDragging = false,
  }) {
    // log('rebuild seat ${seat.serverSeatPos}');
    final shadow = getShadow(hostSeatChange, isFeedBack, theme);

    Widget plateWidget;

    String namePlateStr = """
<svg width="400" height="240" viewBox="0 0 400 240" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M381.2 17.4H17.2V225.4H381.2V17.4Z" fill="#ED2024"/>
<path d="M199.6 10H387.7V231.9H9.9V10H199.6Z" stroke="#4C74B9" stroke-width="5"/>
</svg>
    """;

    String progressPathStr = "M199.6 10H387.7V231.9H9.9V10H199.6Z";

    if (seat.player.isMe) {
      final gameState = GameState.getState(context);
      NamePlateDesign nameplate = gameState.assets.getNameplate();
      namePlateStr = nameplate.svg;
      progressPathStr = nameplate.path;
    }

/*
[log] Timer remaining: 6698 total: 30 current: 23
[log] Rebuilding highlight remaining: 7 total: 30 current: 23
[log] Timer remaining: 22977 total: 30 current: 7
*/
    Size containerSize = Size(200, 120);
    // Size svgSize = Size(400, 240);
    Size progressRatio = Size(1.0, 1.0);
    if (seat.player?.highlight ?? false) {
      int total = seat.actionTimer.getTotalTime();
      // log('Nameplate: total: $total progress: ${seat.actionTimer.getProgressTime()}');
      int progressTime = 0;
      plateWidget = CountdownMs(
          totalSeconds: seat.actionTimer.getTotalTime(),
          currentSeconds: seat.actionTimer.getProgressTime(),
          build: (_, time) {
            seat.actionTimer.setProgressTime(time ~/ 1000);
            int currentProgress = time ~/ 1000;
            if (progressTime != currentProgress) {
              // log('Nameplate: total: $total progress: ${currentProgress}');
              progressTime = currentProgress;
            }
            return Nameplate.fromSvgString(
                remainingTime: time.toInt(),
                totalTime: total * 1000, // in milliseconds
                svg: namePlateStr,
                size: containerSize,
                progressPath: progressPathStr,
                progressRatio: progressRatio);
          });
    } else {
      plateWidget = Nameplate.fromSvgString(
          remainingTime: 0,
          totalTime: 0,
          svg: namePlateStr,
          size: containerSize,
          progressPath: progressPathStr,
          progressRatio: progressRatio);
    }

    Stack namePlate = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      children: [
        // SvgPicture.string(namePlateStr, width: 100, height: 60),
        plateWidget,
        Positioned.fill(
            child: Align(
                alignment: Alignment.topCenter,
                child: AnimatedOpacity(
                  duration: AppConstants.animationDuration,
                  opacity: seat.isOpen ? 0.0 : 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 2),
                      // player name
                      FittedBox(
                        child: Text(
                          seat.player?.name ?? '',
                          style: AppDecorators.getSubtitle1Style(theme: theme),
                        ),
                      ),
                      SizedBox(height: 2),
                      // divider
                      PlayerViewDivider(),
                      SizedBox(height: 2),

                      // bottom widget - to show stack, sit back time, etc.
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: FittedBox(
                            child: bottomWidget(context, theme),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      ],
    );

    //Widget plateWidget;
    if (seat.player?.highlight ?? false) {
      int current = seat.actionTimer.getProgressTime();
      int total = seat.actionTimer.getTotalTime();
      plateWidget = CountdownMs(
          totalSeconds: total,
          currentSeconds: current,
          build: (_, time) {
            double value = (time / (total * 1000));
            double percent = 1 - value;
            seat.actionTimer.setProgressTime(time ~/ 1000);
            Animation<Color> color =
                AlwaysStoppedAnimation<Color>(Colors.green);
            if (percent >= 0.75) {
              color = AlwaysStoppedAnimation<Color>(Colors.red);
            } else if (percent >= 0.50) {
              color = AlwaysStoppedAnimation<Color>(Colors.yellow);
            }
            Widget ret = Column(children: [
              Transform.rotate(
                  angle: -math.pi,
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    value: value,
                    backgroundColor: Colors.transparent,
                    valueColor: color,
                  )),
              namePlate,
            ]);
            return ret;
          });
    } else {
      plateWidget = Column(children: [
        SizedBox(height: 5),
        namePlate,
      ]);
    }

    plateWidget = namePlate;
    Widget ret = Opacity(
        opacity: childWhenDragging ? 0.50 : 1.0,
        child: Container(
            width: 100,
            height: 75,
            //width: boardAttributes.namePlateSize.width,
            //height: boardAttributes.namePlateSize.height,
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              boxShadow: shadow,
            ),
            child: plateWidget));
    return ret;
  }

  Widget bottomWidget(BuildContext context, AppTheme theme) {
    if (seat.player.inBreak &&
        seat.player.breakTimeExpAt != null &&
        !seat.player.isMe) {
      return GamePlayScreenUtilMethods.breakBuyIntimer(
        context,
        seat,
      );
    }

    if (seat.player.action.action != HandActions.ALLIN &&
        seat.player.stack == 0 &&
        seat.player.buyInTimeExpAt != null &&
        !seat.player.isMe) {
      return GamePlayScreenUtilMethods.breakBuyIntimer(context, seat);
    } else {
      if (seat.player != null) {
        return stack(context, theme);
      } else {
        return Container();
      }
    }
  }

  Widget stack(BuildContext context, AppTheme theme) {
    Widget _buildStackTextWidget(int stack) => Text(
          stack?.toString() ?? 'XX',
          style: AppDecorators.getSubtitle1Style(theme: theme),
        );

    if (seat.player.reloadAnimation == true)
      return StackReloadAnimatingWidget(
        stackReloadState: seat.player.stackReloadState,
        stackTextBuilder: _buildStackTextWidget,
      );

    return _buildStackTextWidget(seat.player.stack);
  }
}

class PlayerViewDivider extends StatelessWidget {
  const PlayerViewDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.fillInColor,
        borderRadius: BorderRadius.circular(5),
      ),
      height: 1,
      width: double.infinity,
    );
  }
}
