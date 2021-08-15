import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandLogHeaderView extends StatelessWidget {
  final HandResultData _handResult;

  HandLogHeaderView(this._handResult);

  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("handLogHeaderView");

    final board1Cards = _handResult.getBoard1ShownCards();
    final board2Cards = _handResult.getBoard2ShownCards();
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: AppDecorators.tileDecoration(theme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // game, game type, hand number row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_appScreenText['GAME']}: " + _handResult.gameId,
                  style: AppDecorators.getSubtitle2Style(theme: theme),
                ),
                Text(
                  _handResult.gameType,
                  style: AppDecorators.getHeadLine4Style(theme: theme),
                ),
                Text(
                  "${_appScreenText['HAND']}: #" + _handResult.handNum.toString(),
                  style: AppDecorators.getSubtitle2Style(theme: theme),
                ),
              ],
            ),

            // community cards, and your cards row
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "${_appScreenText['COMMUNITYCARDS']}",
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
                          ),
                        ),
                        StackCardView02(
                          cards: board1Cards,
                          show: _handResult.wonAt() == GameStages.SHOWDOWN,
                        ),
                        board2Cards == null
                            ? Container()
                            : SizedBox(
                                height: 10.dp,
                              ),
                        board2Cards == null
                            ? Container()
                            : StackCardView02(
                                cards: board2Cards,
                                show:
                                    _handResult.wonAt() == GameStages.SHOWDOWN,
                              ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Visibility(
                      visible: _handResult.getMyCards().length > 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "${_appScreenText['YOURCARDS']}",
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                            ),
                          ),
                          StackCardView00(
                            cards: _handResult.getMyCards(),
                            show: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
