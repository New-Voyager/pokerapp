import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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
            fontSize: 20.0.dp,
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
