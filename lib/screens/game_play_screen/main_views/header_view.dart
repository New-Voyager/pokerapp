import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/game_play_models/provider_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

const shrinkedSizedBox = const SizedBox.shrink();

class HeaderView extends StatelessWidget {
  Widget _buildNotification(HhNotificationModel model) => Container(
        decoration: BoxDecoration(
          color: const Color(0xff6a5f65),
          borderRadius: BorderRadius.circular(5.0),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* New High Hand text */
                  Text(
                    'New High Hand',
                    style: TextStyle(
                      color: const Color(0xff69f0ae),
                      fontSize: 15.0,
                    ),
                  ),

                  /* game Code and handNum value */
                  Text(
                    '${model?.gameCode ?? 'CG-ABCDEF'} #${model?.handNum ?? 234}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* player Name */
                  Text(
                    model?.playerName ?? 'Paul',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.80,
                    child: FittedBox(
                      child: StackCardView(
                        cards: model?.hhCards ??
                            [4, 1, 200, 196, 8]
                                .map((c) => CardHelper.getCard(c as int))
                                .toList(),
                        isCommunity: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildNotificationWidget() =>
      Consumer<ValueNotifier<HhNotificationModel>>(
        builder: (_, notificationNotifier, ___) => AnimatedSwitcher(
          transitionBuilder: (child, animation) => ScaleTransition(
            alignment: Alignment.topCenter,
            scale: animation,
            child: child,
          ),
          switchInCurve: Curves.easeInOutExpo,
          switchOutCurve: Curves.easeInOutExpo,
          duration: AppConstants.fastAnimationDuration,
          reverseDuration: AppConstants.fastAnimationDuration,
          child: notificationNotifier.value == null
              ? shrinkedSizedBox
              : _buildNotification(notificationNotifier.value),
        ),
      );

  Widget _buildText(String text, {bool whiteColor = true}) => Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Text(
          text,
          style: whiteColor
              ? AppStyles.gamePlayScreenHeaderTextStyle1
              : AppStyles.gamePlayScreenHeaderTextStyle2,
        ),
      );

  void endGame(BuildContext context, HeaderObject obj) {
    GameService.endGame(obj.gameCode);
    obj.gameEnded = true;
    final snackBar = SnackBar(
      content: Text('Game will end after this hand'),
      duration: Duration(seconds: 15),
      backgroundColor: Colors.black38,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /* general header view */
            Consumer<HeaderObject>(
              builder: (_, HeaderObject obj, __) => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /* main content view */
                    Column(
                      children: [
                        /* game code */
                        _buildText(
                          'GAME CODE: ${obj.gameCode}',
                        ),

                        /* hand num */
                        _buildText(
                          obj.currentHandNum == null
                              ? ''
                              : 'Hand: #${obj.currentHandNum}',
                          whiteColor: false,
                        ),
                      ],
                    ),

                    /* back button */
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    /* temporary place for end game */
                    Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: !obj.gameEnded,
                        child: CustomTextButton(
                          text: 'End Game',
                          onTap: () => endGame(context, obj),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildNotificationWidget(),
          ],
        ),
      );
}
