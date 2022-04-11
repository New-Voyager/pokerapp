import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/formatter.dart';

import 'buttons.dart';

class CreditsWidget extends StatelessWidget {
  final double credits;
  final AppTheme theme;
  final Function onTap;
  final bool oldCredits;
  const CreditsWidget({
    Key key,
    @required this.credits,
    @required this.theme,
    this.onTap,
    this.oldCredits = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double credits = this.credits;
    // credits = -10.30;
    var color = Colors.white;
    if (credits < 0) {
      color = Colors.red;
    }
    String creditsText = DataFormatter.chipsFormat(credits);
    double width = 60;
    if (creditsText.length >= 5) {
      width = creditsText.length * 11.0;
      width += 10;
    }
    double height = 25;
    LinearGradient gradient = LinearGradient(
      colors: [
        theme.accentColorWithLight(0.2),
        theme.accentColorWithLight(0.1),
        theme.accentColor,
        theme.accentColor,
        //           theme.accentColorWithDark(0.1),
        theme.accentColorWithDark(0.1),
        theme.accentColorWithDark(0.2),
        //theme.accentColor,
      ],
      stops: [
        0,
        0.2,
        0.5,
        0.8,
        0.9,
        1.0,
        //0.3
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      // begin: Alignment(-1, -1),
      // end: Alignment(2, 2),
    );

    if (oldCredits) {
      gradient = LinearGradient(
        colors: [
          theme.greyColorWithDark(0.2),
          theme.greyColorWithDark(0.1),
          theme.greyColor,
          theme.greyColor,
          //           theme.accentColorWithDark(0.1),
          theme.greyColorWithDark(0.1),
          theme.greyColorWithDark(0.2),
          //theme.accentColor,
        ],
        stops: [
          0,
          0.2,
          0.5,
          0.8,
          0.9,
          1.0,
          //0.3
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        // begin: Alignment(-1, -1),
        // end: Alignment(2, 2),
      );
    }
    return Container(
      width: width,
      height: height,
      child: OutlineGradientButton(
          radius: Radius.circular(15),
          gradient: gradient,
          strokeWidth: 2,
          backgroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // chip image
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset("assets/images/chip.svg",
                    width: 12,
                    height: 12,
                    color: theme.secondaryColorWithDark(0.1)),
              ),
              SizedBox(width: 5),
              Center(
                  child: Text(
                '${DataFormatter.chipsFormat(credits)}',
                style: AppDecorators.getHeadLine6Style(theme: theme)
                    .copyWith(color: color, fontWeight: FontWeight.bold),
              )),
            ],
          ),
          onTap: () {
            if (this.onTap != null) {
              this.onTap();
            }
          }),
    );
  }
}
