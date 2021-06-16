import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class OverlayNotificationWidget extends StatelessWidget {
  final String amount;
  final String playerName;
  final int pendingCount;
  final String title;
  final String subTitle;
  final Image image;
  final IconData icon;
  final String svgPath;

  OverlayNotificationWidget(
      {this.amount,
      this.playerName,
      this.pendingCount,
      this.title,
      this.subTitle,
      this.image,
      this.icon,
      this.svgPath});
  @override
  Widget build(BuildContext context) {
    String title = this.title;
    String subTitle = this.subTitle;
    if (title == null || title == '') {
      title = "Buyin request of '$amount' from '$playerName'";
      if (subTitle == null || subTitle == '') {
        subTitle = "Total pending buyin requests : $pendingCount";
      }
    }

    Widget leadingImage;
    if (image != null) {
      leadingImage = image;
    } else if (icon != null) {
      leadingImage = Icon(
        icon,
        size: 20.pw,
        color: Colors.white60,
      );
    } else if (svgPath != null) {
      leadingImage = SvgPicture.asset(
        svgPath,
        height: 24.pw,
        width: 24.pw,
      );
    }
    if (leadingImage != null) {
      leadingImage = Container(
        height: 32.pw,
        width: 32.pw,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            //color: Colors.black,
            border: Border.all(color: AppColorsNew.notificationIconColor)),
        padding: EdgeInsets.all(5.pw),
        margin: EdgeInsets.symmetric(
          horizontal: 5.pw,
          vertical: 5.pw,
        ),
        child: leadingImage,
      );
    } else {
      leadingImage = Icon(
        Icons.info_outline,
      );
    }
    return SlideDismissible(
      key: ValueKey("overlayNotification"),
      direction: DismissDirection.horizontal,
      child: SafeArea(
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 8.ph),
            decoration: BoxDecoration(
              color: AppColorsNew.notificationBackgroundColor,
              borderRadius: BorderRadius.circular(8.pw),
            ),
            child: Row(
              children: [
                leadingImage,
                AppDimensionsNew.getHorizontalSpace(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColorsNew.notificationTitleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.dp,
                        ),
                      ),
                      subTitle == null
                          ? SizedBox.shrink()
                          : Text(
                              subTitle,
                              style: TextStyle(
                                color: AppColorsNew.notificationTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 8.dp,
                              ),
                            ),
                    ],
                  ),
                ),
                AppDimensionsNew.getHorizontalSpace(8),
                IconButton(
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: AppColorsNew.darkGreenShadeColor,
                    ),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
