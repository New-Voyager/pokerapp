import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/drawer/wudgets.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';

class Actions3Widget extends StatelessWidget {
  final AppTextScreen text;
  const Actions3Widget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
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
                defaultValue: 1,
                values: ['Slow\n10s', 'Normal\n5s', 'Fast\n3s'],
                onSelect: (int value) {})),
        SizedBox(
          height: 16,
        ),
      ],
    );
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
