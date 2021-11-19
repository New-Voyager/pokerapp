import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget child;
  final List<Widget> children;
  final AppTheme theme;

  DecoratedContainer({this.child, this.children, this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 15.0,
      ),
      decoration: BoxDecoration(
        color: theme.fillInColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: children != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
          : child,
    );
  }
}

class AppLabel extends StatelessWidget {
  final String label;
  final AppTheme theme;

  AppLabel(this.label, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        label,
        style: AppDecorators.getHeadLine4Style(theme: theme),
      ),
    );
  }
}
