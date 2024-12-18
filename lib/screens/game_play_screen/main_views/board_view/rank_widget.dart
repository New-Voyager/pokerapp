import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RankWidget extends StatelessWidget {
  final AppTheme theme;
  final ValueNotifier<String> rankTextNotifier;

  RankWidget(this.theme, this.rankTextNotifier);

  bool _hideRankStr(String rankStr) {
    return rankStr == null || rankStr.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = AppStylesNew.footerResultTextStyle4.copyWith(
      fontSize: 16.dp,
      color: Colors.white,
    );
    return ValueListenableBuilder(
      valueListenable: rankTextNotifier,
      builder: (_, rankStr, __) {
        //Color color = theme.accentColorWithDark();
        Color color = theme.fillInColor;
        if (rankStr.toString().toLowerCase() == 'low') {
          color = Colors.blueGrey;
        }
        return AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          reverseDuration: AppConstants.animationDuration,
          child: _hideRankStr(rankStr)
              ? const SizedBox.shrink()
              : Container(
                  // margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.pw,
                    vertical: 2.pw,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: color, //theme.accentColorWithDark(),
                  ),
                  child: Text(
                    rankStr,
                    style: textStyle,
                  ),
                ),
        );
      },
    );
  }
}
