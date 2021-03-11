import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';

class NamePlateWidget extends StatelessWidget {
  final GlobalKey globalKey;

  final UserObject userObject;
  final bool emptySeat;
  final int seatPos;
  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

  NamePlateWidget(this.userObject, this.seatPos, this.emptySeat,
      {this.globalKey});

  @override
  Widget build(BuildContext context) {
    /* changing background color as per last action
    * check/call -> green
    * raise/bet -> shade of yellow / blue might b? */

    Color statusColor = const Color(0xff474747); // default color
    Color boxColor = const Color(0xff474747); // default color

    String status = userObject.status;
    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }
    dynamic borderColor = Colors.black12;
    if (userObject != null &&
        userObject.highlight != null &&
        userObject.highlight) {
      borderColor = highlightColor;
    } else if (status != null) {
      borderColor = statusColor;
    }
    return Transform.translate(
      key: globalKey,
      offset: Offset(0.0, -10.0),
      child: Container(
        width: 70.0,
        padding: (emptySeat)
            ? const EdgeInsets.all(10.0)
            : const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 5.0,
              ),
        decoration: BoxDecoration(
          //borderRadius: emptySeat ? null : BorderRadius.circular(5.0),
          shape: emptySeat ? BoxShape.circle : BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage(AppAssets.goldNamePlate),
            fit: BoxFit.fill,
          ),
          // color: boxColor,
          border: Border.all(
            // color: userObject.highlight ?? false
            //     ? highlightColor
            //     : Colors.transparent,
            color: borderColor,
            width: 2.0,
          ),
          boxShadow: (userObject.winner ?? false)
              ? [
                  BoxShadow(
                    color: Colors.lightGreen,
                    blurRadius: 50.0,
                    spreadRadius: 20.0,
                  ),
                ]
              : userObject.highlight ?? false
                  ? [
                      BoxShadow(
                        color: highlightColor.withAlpha(120),
                        blurRadius: 20.0,
                        spreadRadius: 20.0,
                      ),
                    ]
                  : [],
        ),
        child: AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          reverseDuration: AppConstants.animationDuration,
          child: (emptySeat)
              ? _openSeat()
              : AnimatedOpacity(
                  duration: AppConstants.animationDuration,
                  opacity: emptySeat ? 0.0 : 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        child: Text(
                          userObject.name,
                          style: AppStyles.gamePlayScreenPlayerName.copyWith(
                            // FIXME: may be this is permanant?
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      FittedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 5.0),
                            Text(
                              userObject.stack?.toString() ?? 'XX',
                              style:
                                  AppStyles.gamePlayScreenPlayerChips.copyWith(
                                // FIXME: may be this is permanant?
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _openSeat() {
    return Container(
      child: InkWell(
        child: Text(
          'Open $seatPos',
          style: AppStyles.openSeatTextStyle,
        ),
      ),
    );
  }
}
