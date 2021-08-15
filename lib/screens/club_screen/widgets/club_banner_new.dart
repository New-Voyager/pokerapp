import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubBannerViewNew extends StatelessWidget {
  final ClubHomePageModel clubModel;
  final AppTextScreen appScreenText;

  ClubBannerViewNew({@required this.clubModel, @required this.appScreenText});

  String _getClubShortName() {
    String clubName = clubModel.clubName;
    var clubNameSplit = clubName.split(' ');
    if (clubNameSplit.length >= 2)
      return '${clubNameSplit[0].substring(0, 1)}${clubNameSplit[1].substring(0, 1)}'
          .toUpperCase();

    try {
      return '${clubName.substring(0, 2)}'.toUpperCase();
    } catch (e) {
      return clubName.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80.pw,
          width: 80.pw,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 3.pw,
              color: theme.secondaryColor,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor,
                blurRadius: 1.pw,
                spreadRadius: 1.pw,
                offset: Offset(1.pw, 4.pw),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _getClubShortName(),
            style: AppDecorators.getHeadLine2Style(theme: theme),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0.pw),
          child: Text(
            clubModel.clubName,
            style: AppDecorators.getHeadLine2Style(theme: theme),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              appScreenText['CLUBCODE'] + ": ",
              style: AppDecorators.getSubtitle3Style(theme: theme),
            ),
            Text(
              clubModel.clubCode,
              style: AppDecorators.getHeadLine3Style(theme: theme),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8.pw),
                child: Icon(
                  Icons.copy,
                  color: theme.secondaryColor,
                  size: 16.pw,
                ),
              ),
              onTap: () {
                Clipboard.setData(
                  new ClipboardData(text: clubModel.clubCode),
                );
                Alerts.showNotification(
                  titleText: appScreenText['CLUBCODECOPIEDTOCLIPBOARD'],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
