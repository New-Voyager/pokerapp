import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

class OverlayNotificationWidget extends StatelessWidget {
  final String amount;
  final String playerName;
  final int pendingCount;
  final String title;
  final String subTitle;

  OverlayNotificationWidget(
      {this.amount,
      this.playerName,
      this.pendingCount,
      this.title,
      this.subTitle});
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

    return SlideDismissible(
      key: ValueKey("overlayNotification"),
      direction: DismissDirection.horizontal,
      child: SafeArea(
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.grey.shade200, Colors.white]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              tileColor: Colors.transparent,
              title: Text(
                title,
                style: TextStyle(
                  color: AppColors.appAccentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: subTitle == null
                  ? SizedBox.shrink()
                  : Text(
                      subTitle,
                      style: TextStyle(
                        color: AppColors.lightGrayTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: AppColors.appAccentColor,
                  ),
                  onPressed: () {
                    OverlaySupportEntry.of(context).dismiss();
                  }),
              leading: Image.asset(
                AppAssets.cardsImage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
