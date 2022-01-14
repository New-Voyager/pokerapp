import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/drawer/iconwidget.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            text['showDown'],
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
        ),
        Row(
          children: [
            // 3 buttons.
            ButtonWithTextColumn(
              theme: theme,
              text1: text['fast'],
              text2: "3s",
            ),
            ButtonWithTextColumn(
              theme: theme,
              text1: text['normal'],
              text2: "5s",
            ),
            ButtonWithTextColumn(
              theme: theme,
              text1: text['slow'],
              text2: "10s",
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
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
  }) : super(key: key);

  final AppTheme theme;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      //style attribute
      style: ElevatedButton.styleFrom(
        primary: theme.accentColorWithDark(),
        onPrimary: theme.supportingColor,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text1,
            style: AppDecorators.getHeadLine5Style(theme: theme),
          ),
          Text(
            text2,
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
        ],
      ),
    );
  }
}
