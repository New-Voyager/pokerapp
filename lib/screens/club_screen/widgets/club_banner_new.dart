import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/alerts.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubBannerViewNew extends StatelessWidget {
  final ClubHomePageModel clubModel;

  ClubBannerViewNew({
    @required this.clubModel,
  });

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
              color: AppColorsNew.newTextGreenColor,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColorsNew.newSelectedGreenColor,
                blurRadius: 1.pw,
                spreadRadius: 1.pw,
                offset: Offset(1.pw, 4.pw),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _getClubShortName(),
            style: AppStylesNew.clubShortCodeTextStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0.pw),
          child: Text(
            clubModel.clubName,
            style: AppStylesNew.clubTitleTextStyle,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              AppStringsNew.clubCodeText + ": ",
              style: AppStylesNew.labelTextStyle,
            ),
            Text(
              clubModel.clubCode,
              style: AppStylesNew.valueTextStyle.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8.pw),
                child: Icon(
                  Icons.copy,
                  color: AppColorsNew.newTextGreenColor,
                  size: 16.pw,
                ),
              ),
              onTap: () {
                Clipboard.setData(
                  new ClipboardData(text: clubModel.clubCode),
                );
                Alerts.showNotification(
                  titleText: "Club code copied to clipboard",
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
