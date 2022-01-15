import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/texts.dart';

class Actions3Widget extends StatelessWidget {
  final AppTextScreen text;
  final GameState gameState;

  const Actions3Widget({Key key, @required this.text, @required this.gameState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    int defaultValue = 1;
    if (gameState.gameSettings.resultPauseTime == 10) {
      defaultValue = 0;
    } else if (gameState.gameSettings.resultPauseTime == 5) {
      defaultValue = 1;
    } else if (gameState.gameSettings.resultPauseTime == 3) {
      defaultValue = 2;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SubTitleText(text: "Showdown Speed", theme: theme),
        ),
        Center(
            child: RadioToggleButtonsWidget<String>(
                defaultValue: defaultValue,
                values: ['Slow\n10s', 'Normal\n5s', 'Fast\n3s'],
                onSelect: (int value) async {
                  if (value == 0) {
                    gameState.gameSettings.resultPauseTime = 10;
                  } else if (value == 1) {
                    gameState.gameSettings.resultPauseTime = 5;
                  } else if (value == 2) {
                    gameState.gameSettings.resultPauseTime = 3;
                  }
                  await updateGameSettings();
                })),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Future<void> updateGameSettings() async {
    final res = await GameSettingsService.updateResultPauseTime(
        gameState.gameCode, gameState.gameSettings.resultPauseTime);
    if (res) {
      Alerts.showNotification(titleText: "Settings updated!");
    }
  }
}

class ButtonWithTextColumn extends StatelessWidget {
  const ButtonWithTextColumn({
    Key key,
    @required this.theme,
    @required this.text1,
    @required this.text2,
    @required this.onTapFunction,
  }) : super(key: key);

  final AppTheme theme;
  final String text1;
  final String text2;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.accentColor,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text1,
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
            Text(
              text2,
              style: AppDecorators.getSubtitle1Style(
                theme: theme,
              ).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
