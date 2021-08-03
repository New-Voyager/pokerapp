import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:provider/provider.dart';

class WhichWinnerWidget extends StatelessWidget {
  final double seperator;

  WhichWinnerWidget({
    @required this.seperator,
  });

  Color _getColor(String whichWinner) {
    if (whichWinner == AppConstants.HIGH_WINNERS)
      return AppColorsNew.newBlueShadeColor;
    return AppColorsNew.newActiveBoxColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: seperator,
      alignment: Alignment.center,
      child: Consumer<TableState>(
        builder: (_, tableState, __) => tableState.whichWinner == null
            ? const SizedBox.shrink()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: _getColor(tableState.whichWinner),
                ),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    tableState.whichWinner,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
