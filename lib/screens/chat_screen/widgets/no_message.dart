import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class NoMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.message_rounded,
          size: 70,
          color: Colors.white.withOpacity(0.5),
        ),
        Text(
          'No message',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        )
      ],
    );
  }
}

class CircularProgressWidget extends StatelessWidget {
  CircularProgressWidget({this.text, this.showText, this.height});
  final String text;
  final bool showText;
  final double height;
  @override
  Widget build(BuildContext context) {
    return showText ?? true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text ?? "Loading",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  height: height ?? 32,
                  width: height ?? 32,
                  child: CircularProgressIndicator(
                    backgroundColor: AppColorsNew.newGreenButtonColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        AppColorsNew.actionRowBgColor),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Container(
              height: height ?? 32,
              width: height ?? 32,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                backgroundColor: AppColorsNew.newGreenButtonColor,
                valueColor: new AlwaysStoppedAnimation<Color>(
                    AppColorsNew.actionRowBgColor),
              ),
            ),
          );
  }
}
