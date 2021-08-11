import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class HighhandWidget extends StatelessWidget {
  final separator = SizedBox(
    height: 5.0,
  );
  final colSeparator = SizedBox(
    width: 20.0,
  );

  final HighHandWinner winner;
  final String clubCode;
  HighhandWidget(this.winner, {this.clubCode});

  Widget cardsView(List<int> cards) {
    List<Widget> cardViews = [];

    for (int cardValue in cards) {
      CardObject card = CardHelper.getCard(cardValue);
      /* we use a small card type for high hand widgets */
      card.cardType = CardType.PlayerCard;
      cardViews.add(card.widget);
    }

    return Row(children: cardViews);
  }

  @override
  Widget build(BuildContext context) {
    var newFormat = new DateFormat.yMd().add_jm();
    final date = newFormat.format(winner.handTime);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.hand_log_view, arguments: {
          "gameCode": winner.gameCode,
          "handNum": winner.handNum,
          "clubCode": clubCode,
        });
      },
      child: Consumer<AppTheme>(
        builder: (_, theme, __) {
          return Container(
            decoration: AppDecorators.tileDecoration(theme),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // player, community
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          winner.player,
                          style: AppStylesNew.accentTextStyle,
                        ),
                        separator,
                        cardsView(winner.playerCards),
                      ],
                    ),
                    colSeparator,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community',
                          style: TextStyle(color: Colors.teal),
                        ),
                        separator,
                        cardsView(winner.boardCards),
                      ],
                    )
                  ],
                ),
                AppDimensionsNew.getVerticalSizedBox(16),
                Row(
                  // highhand
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'High hand',
                          style: TextStyle(color: Colors.green),
                        ),
                        separator,
                        cardsView(winner.hhCards),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  color: AppColorsNew.labelColor,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Hand #${winner.handNum.toString()}',
                      style: AppStylesNew.labelTextStyle,
                    ),
                    Text(
                      date,
                      style: AppStylesNew.labelTextStyle,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
