import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/utils.dart';

class ClubItemView extends StatelessWidget {
  final ClubModel club;
  final AppTheme theme;
  final AppTextScreen appScreenText;

  ClubItemView(this.club, this.theme, this.appScreenText);

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 10.0, width: 10.0);
    Widget clubName = Text(
      club.clubName,
      style: AppDecorators.getHeadLine3Style(theme: theme),
    );

    if (club.hostUnreadMessageCount != 0 ||
        club.memberUnreadMessageCount != 0 ||
        club.pendingMemberCount != 0 ||
        club.unreadMessageCount != 0) {
      clubName = Badge(
          position: BadgePosition.topEnd(top: -5),
          badgeContent: null,
          child: clubName);
    }

    return Row(
      children: [
        Container(
          width: 60.dp,
          height: 60.dp,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: club.picUrl.isEmpty ? 3.pw : 0,
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
              image: club.picUrl == null || club.picUrl.isEmpty
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(
                        club.picUrl,
                        cacheManager: ImageCacheManager.instance,
                      ),
                      fit: BoxFit.cover,
                    )),
          alignment: Alignment.center,
          child: club.picUrl.isEmpty
              ? Text(
                  HelperUtils.getClubShortName(club.clubName),
                  style: AppDecorators.getHeadLine2Style(theme: theme),
                )
              : SizedBox.shrink(),
        ),
        separator,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Flexible(child: clubName),
                ],
              ),
              separator,
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appScreenText['clubCode'],
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        ),
                        Text(
                          "${club.clubCode}",
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          appScreenText['hostedBy'],
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        ),
                        Text(
                          club.isOwner
                              ? "${appScreenText['YOU']}"
                              : "${club.hostName}",
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              separator,
              Divider(
                height: 8,
                endIndent: 16,
                color: AppColorsNew.newBackgroundBlackColor,
              ),
              Padding(
                padding: EdgeInsets.only(right: 16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   AppStringsNew.memberCountLabel,
                        //   style: AppStylesNew.labelTextStyle,
                        // ),
                        Text(
                          '${club.memberCount} ${club.memberCount == 0 || club.memberCount == 1 ? appScreenText['member'] : appScreenText['members']}',
                          style: AppDecorators.getSubtitle2Style(theme: theme),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Text(
              //   '${club.memberCount} Member${club.memberCount == 0 || club.memberCount == 1 ? '' : 's'}',
              //   style: AppStylesNew.itemInfoTextStyle,
              // ),

              /* separator */
              club.outgoingRequest || club.incomingRequest
                  ? SizedBox.shrink()
                  : separator,
              club.outgoingRequest || club.incomingRequest
                  ? SizedBox.shrink()
                  : Text(
                      "${appScreenText['joinedAt']} ${club.joinDate}",
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class ClubItem extends StatelessWidget {
  final ClubModel club;
  final AppTheme theme;
  final AppTextScreen appScreenText;

  ClubItem({
    @required this.club,
    @required this.theme,
    @required this.appScreenText,
  }) {
    club.incomingRequest = false;
    club.outgoingRequest = true;
    club.isActive = false;
    club.hasJoined = false;
  }

  Widget _buildSideAction(ClubModel club) {
    List<Widget> children = [];

    if (club.memberStatus == 'PENDING') {
      children = [
        CircularProgressWidget(
          showText: false,
          height: 16,
        ),
        AppDimensionsNew.getHorizontalSpace(8),
        Text(
          appScreenText['waitingForApproval'],
          textAlign: TextAlign.center,
          style: AppDecorators.getSubtitle3Style(theme: theme),
        ),
      ];
    }

    if (children.length == 0) {
      return SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: club.isActive
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(left: 12, top: 8.0, bottom: 16),
          child: ClubItemView(club, theme, appScreenText),
        ),
        Visibility(
          visible: (club.memberStatus == 'PENDING'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: theme.fillInColor,
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimensions.cardRadius),
              ),
              // boxShadow: AppStylesNew.cardBoxShadowMedium,
            ),
            child: _buildSideAction(club),
          ),
        ),
      ],
    );
  }
}
