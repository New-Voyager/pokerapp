import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/buttons.dart';

class PokerDialogBox extends StatelessWidget {
  const PokerDialogBox({
    Key key,
    this.title,
    this.icon,
    this.content,
    this.message,
    this.buttonOneText,
    this.buttonTwoText,
    this.buttonThreeText,
    this.buttonOneAction,
    this.buttonTwoAction,
    this.buttonThreeAction,
    this.padding,
    this.margin,
  }) : super(key: key);

  final String title;
  final String message;
  final Widget content;
  final String buttonOneText;
  final String buttonTwoText;
  final String buttonThreeText;
  final Function buttonOneAction;
  final Function buttonTwoAction;
  final Function buttonThreeAction;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  static show(BuildContext context,
      {String title,
      IconData icon,
      Widget content,
      String message,
      String buttonOneText,
      String buttonTwoText,
      String buttonThreeText,
      Function buttonOneAction,
      Function buttonTwoAction,
      Function buttonThreeAction,
      bool barrierDismissible = true,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry margin}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PokerDialogBox(
          title: title,
          icon: icon,
          content: content,
          message: message,
          buttonOneText: buttonOneText,
          buttonTwoText: buttonTwoText,
          buttonThreeText: buttonThreeText,
          buttonOneAction: buttonOneAction,
          buttonTwoAction: buttonTwoAction,
          buttonThreeAction: buttonThreeAction,
          padding: padding,
          margin: margin,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.getTheme(context);

    Widget optionsButtonDialogWidget = Column(
      children: [
        SizedBox(height: 8),
        (message != null) ? Text(message) : SizedBox.shrink(),
        SizedBox(height: 32),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            (buttonOneText != null)
                ? RoundRectButton(
                    text: buttonOneText,
                    onTap: buttonOneAction,
                    theme: theme,
                  )
                : SizedBox.shrink(),
            (buttonThreeText == null)
                ? SizedBox(width: 32)
                : SizedBox(width: 24),
            (buttonTwoText != null)
                ? RoundRectButton(
                    text: buttonTwoText,
                    onTap: buttonTwoAction,
                    theme: theme,
                  )
                : SizedBox.shrink(),
            (buttonThreeText != null)
                ? Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: RoundRectButton(
                      text: buttonThreeText,
                      onTap: buttonThreeAction,
                      theme: theme,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ],
    );

    return Center(
      child: Container(
        margin: margin ?? EdgeInsets.all(16),
        padding: padding ??
            EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
        decoration: AppDecorators.bgRadialGradient(theme).copyWith(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.accentColor, width: 3),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (icon != null)
                  ? Icon(icon, color: theme.accentColor, size: 48)
                  : SizedBox.shrink(),
              SizedBox(height: 8),
              (title != null)
                  ? Text(
                      title,
                      style: AppDecorators.getHeadLine2Style(theme: theme),
                    )
                  : SizedBox.shrink(),
              content ?? optionsButtonDialogWidget,
            ],
          ),
        ),
      ),
    );
  }
}
