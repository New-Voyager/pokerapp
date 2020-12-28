import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_assets.dart';

class ClubBannerView extends StatelessWidget {
  final ClubModel clubModel;

  ClubBannerView({
    @required this.clubModel,
  });

  String _getClubShortName() {
    return 'BR';
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
      ]),
    );
  }
}
