import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
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
    <path d="M198.7 8.2C212.9 8.1 223.6 11.6 228.2 13.3C239.3 17.4 247.3 23.2 252.3 27.5C271.1 27.6 289.9 27.6 308.7 27.7C311.3 28.2 316.1 29.5 320.9 33.2C325.3 36.6 327.6 40.4 328.6 42.1C332.5 49.3 332.2 56.2 331.9 59.1C342.1 59.2 352.3 59.3 362.5 59.4C362.4 68.6 362.2 77.9 362.1 87.1C366.5 88.5 375.1 92 382.2 100.5C385.3 104.2 390.4 110.3 390.9 119.5C391.5 130.7 384.7 138.7 382.4 141.3C375.1 149.9 365.8 152.4 362.4 153.2C362.1 161.5 361.9 169.7 361.6 178C352.5 177.9 343.4 177.9 334.3 177.8C334.6 181.1 335.1 191.1 328.9 201.1C323.9 209.2 317.1 213.1 314 214.7C292.4 214.7 270.7 214.7 249.1 214.7C244.4 218.6 227.3 232 201.7 232.3C174.7 232.6 156.7 218.2 152.2 214.4C132.3 214.5 112.5 214.5 92.6 214.6C89.7 213.9 81.3 211.4 74.7 203.4C66.9 193.9 67 183.2 67.1 180.6C58 180.6 49 180.6 39.9 180.6C39.7 171.2 39.6 161.9 39.4 152.5C36 151.3 31 149.1 25.9 144.9C21.6 141.4 13.1 134.5 11.6 123C10.3 113.4 14.6 106 16.2 103.4C23.9 90.8 37.3 87.6 40.1 87C40.6 78.7 41.2 70.3 41.7 62C50.8 62 60 61.9 69.1 61.9C69 59.4 68.5 45.3 79.2 35C84.5 29.9 90.4 27.7 93.8 26.8C112.4 26.4 131 26 149.7 25.7C154.3 21.9 161.8 16.6 172.1 12.9C174.7 11.8 184.9 8.3 198.7 8.2Z" fill="#D6D3C6" stroke="000000" stroke-width="15" stroke-miterlimit="10"/>
    <path d="M34.8 81.7C35.1 77.6 35.3 73.5 35.6 69.3C35.9 64.7 36.2 60.1 36.5 55.5C45.6 55.5 54.7 55.4 63.8 55.4C64.1 52.1 64.9 46.7 67.8 40.8C71.6 33.1 76.7 28.8 78.1 27.7C83.9 23 89.7 21.2 93 20.4C111.2 20 129.5 19.7 147.7 19.3C152.5 15.5 160 10.4 170.2 6.7C173.2 5.6 184.7 1.6 200.2 1.8C216.7 2 229.1 6.7 234.5 9.1C243.2 12.9 249.8 17.5 254.2 21.1C263.2 21.2 272.3 21.2 281.3 21.3C290.7 21.3 300.1 21.4 309.4 21.4C312.2 21.9 322.9 24.3 330.6 34.4C336.3 41.9 337.3 49.7 337.5 53C347.7 53.1 357.9 53.1 368.1 53.2C368.1 58.5 368.1 63.9 368 69.4C367.9 73.9 367.8 78.3 367.6 82.6C371.2 84.1 376.7 86.8 382.1 91.7C383.9 93.3 387.4 96.5 390.5 101.6C392.4 104.7 396.5 111.4 396.4 120.6C396.4 131.1 391 138.4 388.6 141.6C381.4 151.3 371.9 155.2 367.8 156.6C367.5 165.3 367.2 174 367 182.7C358 182.6 349 182.5 339.9 182.3C339.8 186.1 338.9 195.4 332.6 204.7C326.6 213.6 318.8 217.8 315.3 219.4C293.9 219.4 272.4 219.3 251 219.3C245.9 223.3 226.4 237.9 197.9 236.9C172.7 236 155.7 223.4 150.2 219C130.8 219.1 111.3 219.2 91.9 219.3C88.6 218.5 78.2 215.7 70.2 205.8C63.5 197.5 62.2 188.8 61.8 185.2C52.7 185.2 43.6 185.2 34.5 185.2C34.3 179.9 34.2 174.6 34.1 169.2C34 164.5 34 159.9 34 155.4C30 153.5 26.7 151.5 24.3 149.7C19.6 146.3 16.6 143.1 15.8 142.2C14.2 140.5 12.4 138.5 10.6 135.5C9.7 134 7.8 130.5 6.7 125.9C4.5 116.4 7.4 108.4 8.4 105.8C11.6 97.3 17.1 92.4 19.4 90.4C25.5 85.1 31.3 82.8 34.8 81.7Z" fill="#D6D3C6"/>
    <path d="M45.3 90.5C45.8 82.5 46.3 74.4 46.7 66.4C51.3 66.4 56 66.4 60.7 66.4C65.4 66.4 70.1 66.4 74.8 66.4C74.6 64.5 74.4 61.8 74.5 58.7C74.6 57.1 74.6 54.5 75.2 51.8C76.6 44.8 80.8 40 81.7 39.1C86.5 33.8 92.1 31.9 94.6 31.3C113.6 30.9 132.7 30.5 151.7 30.2C158.4 24.4 164.8 20.9 169.4 18.9C172.9 17.3 184.6 12.4 200.4 12.7H200.5C207.4 12.8 221.7 14 236.6 22.3C240.2 24.3 245 27.4 250.2 32.1C269.5 32.2 288.8 32.2 308.1 32.3C310.2 32.8 313.4 33.7 316.6 36C317.8 36.8 319.7 38.3 321.6 40.8C323.4 43.1 324.5 45.4 325.1 47C325.7 48.8 326 50.4 326.2 51.6C326.4 53 326.4 54.1 326.4 54.7C326.4 56.3 326.3 57.5 326.3 58.2C326.2 58.8 326.2 59.1 326 60.7C325.9 62 325.8 63 325.7 63.7C336.1 63.8 346.4 63.9 356.8 64C356.7 72.8 356.5 81.5 356.4 90.3C359.6 91 364 92.4 368.6 95.2C375.9 99.6 380 105.4 382 108.7C383.1 110.6 385.6 115.2 385.3 121.4C385 127.4 382.3 131.6 381.1 133.5C379.8 135.5 378.5 136.9 377.8 137.6C377.2 138.2 374.8 140.8 371.1 143C365.6 146.4 360.1 147.5 356.9 148C356.9 151.9 356.9 156 356.7 160.2C356.6 164.2 356.4 168 356.2 171.8C346.9 171.7 337.6 171.6 328.2 171.6C328.4 174 328.7 176.5 328.9 178.9C329.1 181.8 329.1 189.1 324.6 196.8C320.6 203.7 315.1 207.3 312.5 208.7C290.6 208.6 268.8 208.6 246.9 208.5C242.9 212.1 226.5 226 201.3 226.3C175 226.5 157.8 211.6 154 208.2C133.7 208.3 113.4 208.3 93.1 208.4C89.1 207.3 86.2 205.6 84.5 204.4C78.1 200 75.4 194.2 74.8 192.9C73.3 189.6 72.9 186.7 72.6 184.7C72 180.5 72.3 176.9 72.6 174.4C63.4 174.4 54.2 174.4 45 174.5C44.9 165.7 44.7 156.8 44.6 148C40.6 146.8 34.6 144.4 28.5 139.5C24.7 136.4 21.9 133.2 20 130.5C19.2 129.2 18.2 127.2 17.4 124.7C17.2 123.8 16.7 122.1 16.6 119.9C16.3 114.6 18.1 110.5 18.9 108.6C19.3 107.6 21.4 103.1 26.2 98.8C33.6 92.2 41.7 90.9 45.3 90.5Z" fill="#171817"/>
    </svg>
    """;

    String progressPathStr =
        "M198.7 8.2C212.9 8.1 223.6 11.6 228.2 13.3C239.3 17.4 247.3 23.2 252.3 27.5C271.1 27.6 289.9 27.6 308.7 27.7C311.3 28.2 316.1 29.5 320.9 33.2C325.3 36.6 327.6 40.4 328.6 42.1C332.5 49.3 332.2 56.2 331.9 59.1C342.1 59.2 352.3 59.3 362.5 59.4C362.4 68.6 362.2 77.9 362.1 87.1C366.5 88.5 375.1 92 382.2 100.5C385.3 104.2 390.4 110.3 390.9 119.5C391.5 130.7 384.7 138.7 382.4 141.3C375.1 149.9 365.8 152.4 362.4 153.2C362.1 161.5 361.9 169.7 361.6 178C352.5 177.9 343.4 177.9 334.3 177.8C334.6 181.1 335.1 191.1 328.9 201.1C323.9 209.2 317.1 213.1 314 214.7C292.4 214.7 270.7 214.7 249.1 214.7C244.4 218.6 227.3 232 201.7 232.3C174.7 232.6 156.7 218.2 152.2 214.4C132.3 214.5 112.5 214.5 92.6 214.6C89.7 213.9 81.3 211.4 74.7 203.4C66.9 193.9 67 183.2 67.1 180.6C58 180.6 49 180.6 39.9 180.6C39.7 171.2 39.6 161.9 39.4 152.5C36 151.3 31 149.1 25.9 144.9C21.6 141.4 13.1 134.5 11.6 123C10.3 113.4 14.6 106 16.2 103.4C23.9 90.8 37.3 87.6 40.1 87C40.6 78.7 41.2 70.3 41.7 62C50.8 62 60 61.9 69.1 61.9C69 59.4 68.5 45.3 79.2 35C84.5 29.9 90.4 27.7 93.8 26.8C112.4 26.4 131 26 149.7 25.7C154.3 21.9 161.8 16.6 172.1 12.9C174.7 11.8 184.9 8.3 198.7 8.2Z";

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
