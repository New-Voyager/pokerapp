import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications_view/general_notification.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications_view/high_hand_notification.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:provider/provider.dart';

class Notifications {
  Notifications._();

  static const shrinkedSizedBox = const SizedBox.shrink(
    key: ValueKey('shrinked sized box'),
  );

  static Widget _buildHighHandNotification(HHNotificationModel model) =>
      OverlayHighHandNotificationWidget(
        highHandCards: model.hhCards,
        boardCards: model.hhCards,
        handNo: model.handNum,
        playerCards: model.playerCards,
        name: model.playerName,
      );

  static Widget _buildGeneralNotification(GeneralNotificationModel model) =>
      GeneralNotification(
        key: ValueKey('general notification'),
        model: model,
      );

  static Widget buildNotificationWidget() => Align(
        alignment: Alignment.topCenter,
        child: Consumer2<ValueNotifier<HHNotificationModel>,
            ValueNotifier<GeneralNotificationModel>>(
          builder: (
            _,
            hhNotificationNotifier,
            generalNotificationNotifier,
            ___,
          ) {
            Widget child = shrinkedSizedBox;

            if (hhNotificationNotifier.value != null) {
              child = _buildHighHandNotification(
                hhNotificationNotifier.value,
              );
            }

            if (generalNotificationNotifier.value != null) {
              child = _buildGeneralNotification(
                generalNotificationNotifier.value,
              );
            }

            return AnimatedSwitcher(
              transitionBuilder: (child, animation) => ScaleTransition(
                alignment: Alignment.topCenter,
                scale: animation,
                child: child,
              ),
              switchInCurve: Curves.easeInOutExpo,
              switchOutCurve: Curves.easeInOutExpo,
              duration: AppConstants.fastAnimationDuration,
              reverseDuration: AppConstants.fastAnimationDuration,
              child: child,
            );
          },
        ),
      );
}
