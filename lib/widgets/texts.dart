import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class WrapText extends StatelessWidget {
  final AppTheme theme;
  final String text;
  final bool wrap;
  final TextStyle style;

  WrapText(
    this.text,
    this.theme, {
    this.wrap = true,
    this.style,
  });
  @override
  Widget build(BuildContext context) {
    TextStyle style = this.style;
    if (style == null) {
      style = AppDecorators.getHeadLine3Style(theme: this.theme);
    }
    String text = this.text.replaceAll(' ', '\n');
    return Text(
      text,
      style: style,
    );
  }
}

class TileText extends StatelessWidget {
  final String text;
  final AppTheme theme;
  const TileText({Key key, @required this.text, @required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppDecorators.getHeadLine5Style(theme: theme),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String text;
  final AppTheme theme;
  const SubTitleText({Key key, @required this.text, @required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppDecorators.getHeadLine5Style(theme: theme),
    );
  }
}

class HeadingWidget extends StatelessWidget {
  final String heading;

  HeadingWidget({
    @required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.pw,
        vertical: 20.0.ph,
      ),
      child: Text(
        heading.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16.0.dp,
            color: theme.supportingColor,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: theme.secondaryColor,
                blurRadius: 40.0.pw,
              ),
              Shadow(
                color: theme.secondaryColorWithDark(),
                blurRadius: 30.0.pw,
                offset: Offset(0.0, 5.0.pw),
              ),
            ]),
      ),
    );
  }
}
