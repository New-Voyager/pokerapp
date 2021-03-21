import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

class NamePlateWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final Seat seat;
  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

  NamePlateWidget(this.seat, {this.globalKey});

  @override
  Widget build(BuildContext context) {
    /* changing background color as per last action
    * check/call -> green
    * raise/bet -> shade of yellow / blue might b? */

    Color statusColor = const Color(0xff474747); // default color
    Color boxColor = const Color(0xff474747); // default color
    final openSeat = seat.isOpen;


    if (openSeat) {
      return Container(
        width: 70.0,
        padding: EdgeInsets.all(10.0),
        child: _openSeat(),
        decoration: BoxDecoration(shape: BoxShape.circle),
      );
    }


    String status = !openSeat ? seat.player.status : "";
    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }
    return Transform.translate(
      key: globalKey,
      offset: Offset(0.0, -10.0),
      child: Consumer2<HostSeatChange, GameContextObject>(
        builder: (context, hostSeatChange, gameContextObject, _) =>
            gameContextObject.isAdmin() && hostSeatChange.seatChangeInProgress
                ? Draggable(
                    data: seat.serverSeatPos,
                    onDragEnd: (_) {
                      hostSeatChange.onSeatDragEnd();
                    },
                    onDragStarted: () {
                      hostSeatChange.onSeatDragStart(seat.serverSeatPos);
                    },
                    feedback: buildPlayer(hostSeatChange, isFeedBack: true),
                    child: buildPlayer(hostSeatChange),
                  )
                : buildPlayer(hostSeatChange),
      ),
    );
  }

  Container buildPlayer(HostSeatChange hostSeatChange,
      {bool isFeedBack = false}) {
    bool winner = seat.player.winner ?? false;
    bool highlight = seat.player.highlight ?? false;
    print('winner: ${winner} highlight: ${highlight}');
    return Container(
      width: 70.0,
      padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        color: Color(0XFF494444),
        border: Border.all(
                color: Color.fromARGB(255, 206, 134, 57),
                width: 2.0,
              ),
        boxShadow: winner 
            ? [
                BoxShadow(
                  color: Colors.lightGreen,
                  blurRadius: 50.0,
                  spreadRadius: 20.0,
                ),
              ]
            : highlight
                ? [
                    BoxShadow(
                      color: highlightColor.withAlpha(120),
                      blurRadius: 20.0,
                      spreadRadius: 20.0,
                    ),
                  ]
                : seat.serverSeatPos != null
                    ? hostSeatChange
                                .allSeatChangeStatus[seat.serverSeatPos]
                                .isDragging ||
                            isFeedBack
                        ? [
                            BoxShadow(
                              color: Colors.green,
                              blurRadius: 20.0,
                              spreadRadius: 20.0,
                            ),
                          ]
                        : hostSeatChange
                                .allSeatChangeStatus[seat.serverSeatPos]
                                .isDropAble
                            ? [
                                BoxShadow(
                                  color: Colors.blue,
                                  blurRadius: 20.0,
                                  spreadRadius: 20.0,
                                ),
                              ]
                            : []
                    : [],
      ),
      child: AnimatedSwitcher(
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
                          child: Text(
                            seat.player.stack?.toString() ?? 'XX',
                            style: AppStyles.gamePlayScreenPlayerChips.copyWith(
                              // FIXME: may be this is permanant?
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _openSeat() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        child: Text(
          'Open ${seat.serverSeatPos}',
          style: AppStyles.openSeatTextStyle,
        ),
      ),
    );
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
