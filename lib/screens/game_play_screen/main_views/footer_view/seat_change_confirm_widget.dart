import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

class SeatChangeConfirmWidget extends StatelessWidget {
  const SeatChangeConfirmWidget({Key key}) : super(key: key);

  onCancel(context) {
    Provider.of<HostSeatChange>(
      context,
      listen: false,
    )
      ..updateSeatChangeHost(0)
      ..updateSeatChangeInProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      color: Colors.brown[300],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 130,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.brown[700],
            child: Text(
              "Confirm\nRearrangement",
              style: AppStyles.footerResultTextStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () => onCancel(context),
            child: Container(
              width: 130,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.brown[700],
              child: Text(
                "Cancel\nChanges",
                style: AppStyles.footerResultTextStyle2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
