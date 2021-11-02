import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/utils.dart';

class ClubBannerViewNew extends StatelessWidget {
  final ClubHomePageModel clubModel;
  final AppTextScreen appScreenText;

  ClubBannerViewNew({@required this.clubModel, @required this.appScreenText});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    final decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: clubModel.picUrl.isEmpty ? 3.pw : 0,
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
        image: clubModel.picUrl.isEmpty
            ? null
            : DecorationImage(
                image: CachedNetworkImageProvider(
                  clubModel.picUrl,
                ),
                fit: BoxFit.cover,
              ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
            width: 80.dp,
            height: 80.dp,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.all(4),
            decoration: decoration,
            alignment: Alignment.center,
            child: clubModel.picUrl.isEmpty
                ? Text(
                    HelperUtils.getClubShortName(clubModel.clubName),
                    style: AppDecorators.getHeadLine2Style(theme: theme),
                  )
                : SizedBox.shrink(),
          ),
          // Positioned(
          //   right: -40,
          //   bottom: 10,
          // child: Transform.scale(
          // scale: 1.2,
          // child: Icon(
          //   Icons.settings_outlined,
          //   color: theme.accentColor,
          // ))),
          ],
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
              appScreenText['clubCode'] + ": ",
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
                  titleText: appScreenText['codeCopiedToClipboard'],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
