import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function() onTap;

  ButtonWidget({
    @required this.text,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
        child: IntrinsicWidth(
          child: Container(
            width: 200.0,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(
                color: theme.accentColor,
                width: 2.0,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 10.0,
              //     spreadRadius: 5.0,
              //     color: const Color(0xff00FAAD),
              //   )
              // ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                 theme.accentColor.withAlpha(200),
                 theme.accentColor.withAlpha(150),
                 theme.accentColor.withAlpha(75), 
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                color: theme.supportingColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
