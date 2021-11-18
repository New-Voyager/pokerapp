import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/widgets/four_of_kind_body.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/widgets/full_house_body.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/widgets/straight_flush_body.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/enums/rank_type.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:provider/provider.dart';

class RankCardSelectionDialog extends StatelessWidget {
  final AppTheme appTheme;

  RankCardSelectionDialog({
    @required this.appTheme,
  });

  // returns the list of selected cards
  static Future<List<int>> show({
    @required BuildContext context,
  }) {
    final appTheme = context.read<AppTheme>();
    return showDialog<List<int>>(
      context: context,
      builder: (_) => RankCardSelectionDialog(
        appTheme: appTheme,
      ),
    );
  }

  final typeOfRankCards = ValueNotifier<RankType>(RankType.FULL_HOUSE);
  final selectedCards = ValueNotifier<List<int>>([]);

  Map<RankType, Widget> _getSegmentedControlChildren() {
    Widget _buildWidget(
      String text,
    ) {
      return Text(text, textAlign: TextAlign.center);
    }

    return {
      RankType.FULL_HOUSE: _buildWidget('Full House'),
      RankType.STRAIGHT_FLUSH: _buildWidget('Straight Flush'),
      RankType.FOUR_OF_KIND: _buildWidget('Four of Kind'),
    };
  }

  Widget _buildSelectionBody() {
    // reset the selected cards, as soon as a new body is selected
    // selectedCards.value = [];

    // build a body depending upon the type of rank cards
    switch (typeOfRankCards.value) {
      case RankType.FULL_HOUSE:
        return FullHouseBody(
          cards: selectedCards,
        );

      case RankType.STRAIGHT_FLUSH:
        return StraightFlushBody(
          cards: selectedCards,
        );

      case RankType.FOUR_OF_KIND:
        return FourOfKindBody(
          cards: selectedCards,
        );
    }

    return FullHouseBody();
  }

  Widget _buildCardsView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ValueListenableBuilder<List<int>>(
        valueListenable: selectedCards,
        builder: (_, cards, __) => StackCardView03(
          cards: cards,
          // cards: cards.map((e) => CardHelper.getCard(e)).toList(),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return ValueListenableBuilder<List<int>>(
      valueListenable: selectedCards,
      builder: (_, cards, __) => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            /* no button */
            Expanded(
              child: ElevatedButton(
                child: Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            /* divider */
            const SizedBox(width: 10.0),

            /* true button */
            Expanded(
              child: ElevatedButton(
                child: Text('Select'),
                onPressed: cards.isEmpty
                    ? null
                    : () {
                        Navigator.pop(context, cards);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: AppDecorators.bgRadialGradient(appTheme),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ValueListenableBuilder<RankType>(
          valueListenable: typeOfRankCards,
          builder: (_, typeOfRank, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // rank type selection
              CupertinoSegmentedControl(
                borderColor: appTheme.primaryColorWithDark(),
                selectedColor: appTheme.accentColor,
                unselectedColor: appTheme.primaryColorWithDark(0.04),
                pressedColor: appTheme.secondaryColor.withOpacity(0.10),
                groupValue: typeOfRank,
                children: _getSegmentedControlChildren(),
                onValueChanged: (typeOfRank) {
                  typeOfRankCards.value = typeOfRank;
                },
              ),

              // main body based on typeOfRank selection
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: _buildSelectionBody(),
              ),

              // cards view
              _buildCardsView(),

              // show close and ok buttons
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
