import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/utils.dart';

class ClubActivityCreditScreen extends StatefulWidget {
  // final ClubHomePageModel clubHomePageModel;
  final String clubCode;
  final String playerId;
  final ClubMemberModel member; // current session is owner?
  const ClubActivityCreditScreen(this.clubCode, this.playerId, this.member);

  @override
  State<ClubActivityCreditScreen> createState() =>
      _ClubActivityCreditScreenState();
}

class _ClubActivityCreditScreenState extends State<ClubActivityCreditScreen> {
  AppTheme theme;
  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16.0.pw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildBanner(),
                dividingSpace(),
                Divider(color: Colors.white),
                dividingSpace(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Credits",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "600",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: theme.secondaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.pw),
                          child: Text(
                            "Change",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0.pw)),
                          ),
                        ),
                      ),
                    ]),
                dividingSpace(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activities",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Balance",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                dividingSpace(),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        itemCount: 12,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Game: ABC",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Buyin",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "600",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "600",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: theme.secondaryColor,
                                        ),
                                      ),
                                    ]),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("28-Nov-2021 11:00 AM")),
                                Divider(color: Colors.white),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBanner() {
    final clubImageDecoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: (widget.member.imageUrl == null) ? 2.pw : 0,
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
        image: (widget.member.imageUrl == null)
            ? null
            : DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.member.imageUrl,
                ),
                fit: BoxFit.cover,
              ));
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackArrowWidget(),
            dividingSpace(),
            Container(
              width: 30.dp,
              height: 30.dp,
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(4),
              decoration: clubImageDecoration,
              alignment: Alignment.center,
              child: (widget.member.imageUrl == null)
                  ? Text(
                      HelperUtils.getClubShortName(widget.member.name),
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        Text(
          "PokerRocks",
          style: TextStyle(
            fontSize: 20.0.pw,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget bannerActionButton({IconData icon, String text, onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40.0.pw,
          width: 40.0.pw,
          child: Icon(
            icon,
            size: 24,
            color: theme.primaryColor,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0.pw),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16.pw, color: Colors.white),
        ),
      ],
    );
  }

  Widget dividingSpace() {
    return SizedBox(width: 16.0.ph, height: 16.0.ph);
  }
}
