import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/enums/rank_type.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/select_from_list_IOS_look.dart';
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
