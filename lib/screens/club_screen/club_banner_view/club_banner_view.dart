import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

class ClubBannerView extends StatelessWidget {
  final ClubHomePageModel clubModel;

  ClubBannerView({
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
    return Center(
      child: Column(children: [
        CircleAvatar(
          backgroundColor:
              Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
          radius: 40,
          child: Text(
            _getClubShortName(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            clubModel.clubName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Club code: " + clubModel.clubCode,
                style: TextStyle(
                  color: AppColors.lightGrayColor,
                  fontSize: 14.0,
                  fontFamily: AppAssets.fontFamilyLato,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.copy,
                    color: AppColors.appAccentColor,
                    size: 16,
                  ),
                ),
                onTap: () {
                  Clipboard.setData(
                      new ClipboardData(text: clubModel.clubCode));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Club code copied to clipboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: AppAssets.fontFamilyLato,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
