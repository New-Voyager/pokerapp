import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/rank_card_selection_dialog.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class HighHandAnalysisScreen extends StatelessWidget {
  final ValueNotifier<List<int>> _selectedCards = ValueNotifier<List<int>>([]);

  // method opens a dialog to choose rank cards
  void _selectRankCards(BuildContext context) async {
    final rankCards = await RankCardSelectionDialog.show(
      context: context,
    );

    // fill the selected cards in the value notifier
    _selectedCards.value = rankCards;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<AppTheme>();

    return Container(
      decoration: AppDecorators.bgRadialGradient(appTheme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: IntrinsicHeight(
            child: ButtonWidget(
              text: 'Select',
              onTap: () {
                _selectRankCards(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
