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
import 'package:pokerapp/utils/adaptive_sizer.dart';

class NamePlateWidget extends StatelessWidget {
  final Key globalKey;
  final Seat seat;
  NamePlateDesign nameplate;
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
    final gameState = GameState.getState(context);

    Provider.of<RedrawNamePlateSectionState>(context);

    log('SeatChange: Player build drag: ${seat.dragEntered}');
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

        if (gameContextObject.isHost() && gameState.hostSeatChangeInProgress) {
          log('SeatChange: Seat change in progress: building seat [${seat.seatPos.toString()}]');
          displayWidget = Draggable(
            data: seat.serverSeatPos,
            onDragEnd: (DraggableDetails details) {
              log('SeatChange: Drag ended [${seat.seatPos.toString()} player: ${seat.player?.name}}]');
              seat.dragEntered = false;
              hostSeatChange.onSeatDragEnd(details);
            },
            onDragStarted: () {
              log('SeatChange: Dragging [${seat.seatPos.toString()} player: ${seat.player?.name}}]');
              hostSeatChange.onSeatDragStart(seat);
            },
            onDraggableCanceled: (_, __) {
              hostSeatChange.onSeatDragEnd(null);
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
        if (seat != null) {
          seatChangeStatus =
              hostSeatChange.allSeatChangeStatus[seat.localSeatPos];
        }
        if (seatChangeStatus != null) {
          if (seatChangeStatus.isDragging || isFeedback) {
            log('SeatChange: Dragging [${seat.localSeatPos}] seatChangeStatus.isDragging: ${seatChangeStatus.isDragging} isFeedback: $isFeedback');
            shadow = BoxShadow(
              color: Colors.green,
              blurRadius: 20.0,
              spreadRadius: 8.0,
            );
          } else if (seat.dragEntered ?? false) {
            log('SeatChange: [${seat.localSeatPos}] seatChangeStatus.isDropAble: ${seatChangeStatus.isDropAble} isFeedback: $isFeedback');
            shadow = BoxShadow(
              color: Colors.blue,
              blurRadius: 20.0,
              spreadRadius: 30.0,
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
    log('SeatChange: Player ${seat.serverSeatPos} dragEnter: ${seat.dragEntered}');
    List<BoxShadow> shadow = getShadow(hostSeatChange, isFeedBack, theme);
    if (seat.dragEntered ?? false) {
      shadow = [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 20.0,
          spreadRadius: 30.0,
        )
      ];
    }

    Widget plateWidget;
    String playerNamePlate = namePlateStr;
    String playerProgress = progressPathStr;

    final gameState = GameState.getState(context);
    if (seat.player != null) {
      if (seat.player.isMe) {
        nameplate = gameState.assets.getNameplate();
      } else {
        nameplate = gameState.assets.getNameplateById(seat.player.namePlateId);
      }
    }

    nameplate = gameState.assets.getNameplateById("3");

    if (nameplate != null) {
      playerNamePlate = nameplate.svg;
      playerProgress = nameplate.path;
    }
    double scale = 1.3;
    // if (nameplate.id != "0") {
    //   scale = 1.2;
    // }
/*
[log] Timer remaining: 6698 total: 30 current: 23
[log] Rebuilding highlight remaining: 7 total: 30 current: 23
[log] Timer remaining: 22977 total: 30 current: 7
*/
    Size containerSize = Size(200, 120);
    // Size svgSize = Size(400, 240);
    Size progressRatio = Size(1.0, 1.0);
    if (seat.player?.highlight ?? false) {
      plateWidget = Consumer<ActionTimerState>(builder: (_, __, ___) {
        int total = seat.actionTimer.getTotalTime();
        // log('Nameplate: total: $total progress: ${seat.actionTimer.getProgressTime()}');
        int lastRemainingTime = seat.actionTimer.getRemainingTime();
        int progressTime = seat.actionTimer.getTotalTime() -
            seat.actionTimer.getRemainingTime();
        log('ActionTimer: progress seat no: ${seat.serverSeatPos} action timer: ${seat.actionTimer.getTotalTime()} remainingTime: ${seat.actionTimer.getRemainingTime()} progress time: ${progressTime}');
        // if (seat.serverSeatPos == 1) {
        // }
        bool first = true;

        return CountdownMs(
            key: UniqueKey(),
            totalSeconds: seat.actionTimer.getTotalTime(),
            currentSeconds: progressTime,
            build: (_, time) {
              int remainingTime = time.toInt();
              if (first) {
                if (seat.serverSeatPos == 1) {
                  log('ActionTimer: (first) progress seat no: ${seat.serverSeatPos} action timer: ${total} remainingTime: ${lastRemainingTime} progress time: ${progressTime}');
                }
              }
              first = false;
              int currentProgressInSecs = (total * 1000 - time) ~/ 1000;
              int remainingTimeInSecs = remainingTime ~/ 1000;
              //seat.actionTimer.setRemainingTime(time ~/ 1000);
              if (seat.serverSeatPos == 1) {
                if (lastRemainingTime != remainingTimeInSecs) {
                  log('ActionTimer: progress seat no: ${seat.serverSeatPos} action timer: ${total} remainingTime: ${remainingTimeInSecs} progress: ${currentProgressInSecs}');
                  lastRemainingTime = remainingTimeInSecs;
                }
              }
              seat.actionTimer.setRemainingTime(remainingTimeInSecs);

              return Nameplate.fromSvgString(
                remainingTime: time
                    .toInt(), // seat.actionTimer.getRemainingTime()*1000, //time.toInt(),
                totalTime: total * 1000, // in milliseconds
                svg: playerNamePlate,
                size: containerSize,
                progressPath: playerProgress,
                progressRatio: progressRatio,
                scale: scale,
              );
            });
      });
    } else {
      plateWidget = Nameplate.fromSvgString(
        remainingTime: 0,
        totalTime: 0,
        svg: playerNamePlate,
        size: containerSize,
        progressPath: playerProgress,
        progressRatio: progressRatio,
        scale: scale,
      );
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
                  child: Padding(
                    padding: nameplate != null
                        ? EdgeInsets.fromLTRB(
                            double.parse(
                                nameplate.meta.padding.split(",")[0].trim()),
                            double.parse(
                                nameplate.meta.padding.split(",")[1].trim()),
                            double.parse(
                                nameplate.meta.padding.split(",")[2].trim()),
                            double.parse(
                                nameplate.meta.padding.split(",")[3].trim()),
                          )
                        : null, //EdgeInsets.all(3),
                    //padding: EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 2),
                        // player name
                        FittedBox(
                          child: Text(seat.player?.name ?? '',
                              style:
                                  AppDecorators.getSubtitle4Style(theme: theme)
                                      .copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.dp)
                              //fontSize: nameplate.meta.nameTextSize),
                              ),
                        ),
                        //Spacer(),
                        // divider
                        Transform.scale(
                            scale: scale, child: PlayerViewDivider()),

                        //Spacer(),
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
                  ),
                ))),
      ],
    );

    log('SeatView: Nameplate build ${seat.serverSeatPos}:L${seat.localSeatPos} pos: ${seat.seatPos.toString()} player: ${seat.player?.name} highlight: ${seat.player?.highlight}');

    //Widget plateWidget;
    if (seat.player?.highlight ?? false) {
      int current = seat.actionTimer.getRemainingTime();
      int total = seat.actionTimer.getTotalTime();
      plateWidget = CountdownMs(
          totalSeconds: total,
          currentSeconds: total - seat.actionTimer.getRemainingTime(),
          build: (_, time) {
            double value = (time / (total * 1000));
            double percent = 1 - value;
            seat.actionTimer.setRemainingTime(time ~/ 1000);
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
    if (seat.player == null) {
      return Container();
    }

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
    Widget _buildStackTextWidget(int stack) => FittedBox(
            child: Text(
          stack?.toString() ?? 'XX',
          style: AppDecorators.getSubtitle4Style(theme: theme)
              .copyWith(fontSize: 12.dp), //nameplate.meta.nameTextSize),
        ));

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
        color: theme.accentColor,
        borderRadius: BorderRadius.circular(5),
      ),
      height: 1,
      width: double.infinity,
    );
  }
}
