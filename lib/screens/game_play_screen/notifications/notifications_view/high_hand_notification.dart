import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';

class HighHandNotification extends StatelessWidget {
  final HHNotificationModel model;

  HighHandNotification({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('high hand notification'),
      decoration: BoxDecoration(
        color: const Color(0xff6a5f65),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
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
              mainAxisSize: MainAxisSize.min,
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
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /* player Name */
                  Text(
                    model?.playerName ?? 'Paul',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Transform.scale(
                    scale: 0.90,
                    child: FittedBox(
                      child: StackCardView(
                        cards: model?.hhCards ??
                            [4, 1, 200, 196, 8]
                                .map((c) => CardHelper.getCard(c))
                                .toList(),
                        isCommunity: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
