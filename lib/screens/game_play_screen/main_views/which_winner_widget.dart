import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class WhichWinnerWidget extends StatelessWidget {
  final double seperator;

  WhichWinnerWidget({
    @required this.seperator,
  });

  Color _getColor(String whichWinner) {
    if (whichWinner == AppConstants.HIGH_WINNERS) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: seperator,
        alignment: Alignment.center,
        child: Consumer2<TableState, AppTheme>(
            builder: (_, tableState, theme, __) {
          return SizedBox.shrink();
          return tableState.whichWinner == null
              ? const SizedBox.shrink()
              : Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.pw, horizontal: 10.pw),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.pw),
                    color: _getColor(tableState.whichWinner),
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      tableState.whichWinner,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                );
        }));
  }
}
