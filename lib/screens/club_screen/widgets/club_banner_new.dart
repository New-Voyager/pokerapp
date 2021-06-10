import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/alerts.dart';

import '../../../utils/color_generator.dart';

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
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: AppColorsNew.newTextGreenColor,
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColorsNew.newSelectedGreenColor,
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(1, 4)),
              ]),
          alignment: Alignment.center,
          child: Text(
            _getClubShortName(),
            style: AppStylesNew.ClubShortCodeTextStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            clubModel.clubName,
            style: AppStylesNew.ClubTitleTextStyle,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Club code: " + clubModel.clubCode,
              style: AppStylesNew.ClubTitleTextStyle.copyWith(fontSize: 12),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.copy,
                  color: AppColorsNew.newTextGreenColor,
                  size: 16,
                ),
              ),
              onTap: () {
                Clipboard.setData(new ClipboardData(text: clubModel.clubCode));
                Alerts.showTextNotification(
                  text: "Club code copied to clipboard",
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
