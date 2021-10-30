import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/count_down_timer.dart';

class GeneralNotification extends StatelessWidget {
  final GeneralNotificationModel model;

  GeneralNotification({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsNew.cardBackgroundColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: ListTile(
        title: Text(
          model?.titleText ?? 'Seat change in progress',
          style: AppStylesNew.notificationTitleTextStyle,
        ),
        subtitle: Text(
          model?.subTitleText ?? '',
          style: AppStylesNew.notificationSubTitleTextStyle,
        ),
        trailing: model?.trailingWidget ??
            CountDownTimer(
              remainingTime: 30,
            ),
        leading: model?.leadingWidget,
      ),
    );
  }
}
