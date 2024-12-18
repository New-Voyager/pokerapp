import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:get_version/get_version.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/build_info.dart';
import 'package:pokerapp/flavor_config.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/user_update_input.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/custom_divider.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ProfilePageNew extends StatefulWidget {
  const ProfilePageNew({Key key}) : super(key: key);

  @override
  _ProfilePageNewState createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  String _displayName = "Bob John";
  TextEditingController _controller;
  AuthModel _currentUser;
  AppTextScreen _appScreenText;
  int _totalGames;
  int _totalHands;
  @override
  void initState() {
    super.initState();
    // Fetch my profile details
    _appScreenText = getAppTextScreen("profilePageNew");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchMyProfile();
    });
  }

  _fetchMyProfile() async {
    _currentUser = await AuthService.getPlayerInfo();
    final stats = await StatsService.getAlltimeStatsOnly();
    _totalGames = 0;
    _totalHands = 0;
    if (stats != null) {
      _totalGames = stats.alltime.totalGames;
      _totalHands = stats.alltime.totalHands;
    }
    if (_currentUser != null) {
      _displayName = _currentUser.name;

      setState(() {});
    } else {
      log("Failed to fetch user data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        String id = '';

        if (_currentUser != null) {
          id = _currentUser.uuid;
          if (appState.currentFlavor == Flavor.DEV) {
            id = id + '/${_currentUser.playerId}';
          }
        }

        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: _currentUser == null
                  ? CircularProgressWidget(
                      text: _appScreenText['gettingDetails'])
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          HeadingWidget(heading: _appScreenText['myProfile']),

                          // Name tile
                          Container(
                            decoration: AppDecorators.tileDecoration(theme),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.secondaryColor,
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: CircleAvatar(
                                        backgroundColor: theme.fillInColor,
                                        radius: 24.pw,
                                        child: Icon(
                                          Icons.person,
                                          size: 24.pw,
                                          color: theme.supportingColor,
                                        ),
                                      ),
                                    ),
                                    AppDimensionsNew.getHorizontalSpace(16),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(_displayName,
                                              style: AppDecorators
                                                  .getHeadLine4Style(
                                                      theme: theme)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _appScreenText['games'],
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                          Text(
                                            _totalGames.toString(),
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(_appScreenText['hands'],
                                              style: AppDecorators
                                                  .getSubtitle3Style(
                                                      theme: theme)),
                                          Text(
                                            _totalHands.toString(),
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // List of items
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              children: [
                                // Section 1
                                Container(
                                  decoration:
                                      AppDecorators.tileDecoration(theme),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTileItem(
                                        text: _currentUser.name == null
                                            ? _appScreenText['changeScreenName']
                                            : _appScreenText[
                                                'changeScreenName'],
                                        subTitleText: _currentUser.name != null
                                            ? "(${_currentUser.name})"
                                            : "",
                                        icon: Icons.edit,
                                        index: 1,
                                        onTapFunction: () async {
                                          await _updateUserDetails(
                                              UpdateType.SCREEN_NAME, theme);
                                          // Fetch user details from server
                                        },
                                      ),
                                      CustomDivider(),
                                      ListTileItem(
                                        text: _currentUser.email == null
                                            ? _appScreenText['setRecoveryEmail']
                                            : _appScreenText[
                                                'changeRecoveryEmail'],
                                        subTitleText: _currentUser.email != null
                                            ? "(${_currentUser.email})"
                                            : "",
                                        icon: Icons.email,
                                        index: 2,
                                        onTapFunction: () async {
                                          await _updateUserDetails(
                                              UpdateType.EMAIL, theme);
                                          // Fetch user details from server
                                        },
                                      ),
                                      //CustomDivider(),
                                      // ListTileItem(
                                      //   text: _appScreenText[
                                      //       'customizeGameScreen'],
                                      //   imagePath:
                                      //       AppAssetsNew.customizeImagePath,
                                      //   index: 3,
                                      //   onTapFunction: () {
                                      //     Navigator.of(context).pushNamed(
                                      //       Routes.game_screen_customize,
                                      //     );
                                      //   },
                                      // ),
                                      // CustomDivider(),
                                      Visibility(
                                        visible: false,
                                        child: ListTileItem(
                                          text: _appScreenText['chooseTheme'],
                                          icon: Icons.dashboard_customize,
                                          index: 4,
                                          onTapFunction: () {
                                            Navigator.of(context).pushNamed(
                                              Routes.customize,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppDimensionsNew.getVerticalSizedBox(16),

                                // Section 2
                                Container(
                                  decoration:
                                      AppDecorators.tileDecoration(theme),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTileItem(
                                        text: _appScreenText['bookmarkedHands'],
                                        imagePath: AppAssetsNew
                                            .bookmarkedHandsImagePath,
                                        index: 0,
                                        onTapFunction: () =>
                                            navigatorKey.currentState.pushNamed(
                                          Routes.bookmarked_hands,
                                          arguments: "",
                                        ),
                                      ),
                                      CustomDivider(),
                                      ListTileItem(
                                          text: _appScreenText['stats'],
                                          imagePath:
                                              AppAssetsNew.statisticsImagePath,
                                          index: 1,
                                          onTapFunction: () {
                                            navigatorKey.currentState.pushNamed(
                                              Routes.player_statistics,
                                              arguments: _currentUser.uuid,
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                AppDimensionsNew.getVerticalSizedBox(16),

                                // Section 3
                                Container(
                                  decoration:
                                      AppDecorators.tileDecoration(theme),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTileItem(
                                        text: _appScreenText[
                                            'systemAnnouncements'],
                                        imagePath:
                                            AppAssetsNew.announcementImagePath,
                                        index: 2,
                                        badgeCount:
                                            playerState.unreadAnnouncements,
                                        onTapFunction: () {
                                          // mark as read
                                          playerState
                                              .updateSysAnnounceReadDate();
                                          playerState.unreadAnnouncements = 0;
                                          Navigator.of(context).pushNamed(
                                            Routes.system_announcements,
                                          );
                                          setState(() {});

                                          // Navigator.of(context).pushNamed(
                                          //   Routes.customize,
                                          // );
                                        },
                                      ),
                                      CustomDivider(),
                                      ListTileItem(
                                        text: _appScreenText['help'],
                                        icon: Icons.help_center,
                                        index: 3,
                                        onTapFunction: () async {
                                          String version =
                                              "${versionNumber}(${releaseDate})";
                                          Navigator.of(context).pushNamed(
                                            Routes.help,
                                            arguments: version,
                                          );
                                        },
                                      ),
                                      CustomDivider(),
                                      // ListTileItem(
                                      //   text: _appScreenText['tellFriend'],
                                      //   imagePath:
                                      //       AppAssetsNew.announcementImagePath,
                                      //   index: 4,
                                      //   onTapFunction: () {},
                                      // ),
                                      // AppDimensionsNew.getVerticalSizedBox(16),
                                      ListTileItem(
                                        text: _appScreenText['logout'],
                                        icon: Icons.logout,
                                        index: 5,
                                        onTapFunction: () async {
                                          await AuthService.logout();
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.registration,
                                            (route) => false,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppDimensionsNew.getVerticalSizedBox(20.ph),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Text('id: ${id}')),
                          // Container(
                          //     margin: EdgeInsets.symmetric(vertical: 8),
                          //     child: Text('${versionNumber} ${releaseDate}')),
                          AppDimensionsNew.getVerticalSizedBox(80.ph),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  _updateUserDetails(UpdateType type, AppTheme theme) async {
    String defaultText = type == UpdateType.SCREEN_NAME
        ? _currentUser.name
        : type == UpdateType.DISPLAY_NAME
            ? _currentUser.name
            : type == UpdateType.EMAIL
                ? _currentUser.email
                : "";
    _controller = TextEditingController(text: defaultText);
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.fillInColor,
        title: Text(
          type == UpdateType.SCREEN_NAME
              ? _appScreenText['changeScreenName']
              : type == UpdateType.DISPLAY_NAME
                  ? _appScreenText['changeDisplayName']
                  : type == UpdateType.EMAIL
                      ? _appScreenText['changeEmail']
                      : _appScreenText['updateDetails'],
          style: AppDecorators.getSubtitle3Style(theme: theme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              controller: _controller,
              maxLines: 1,
              hintText: _appScreenText['enterText'],
              theme: theme,
            ),
            AppDimensionsNew.getVerticalSizedBox(12),
            RoundRectButton(
              text: _appScreenText['SAVE'],
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.of(context).pop(_controller.text);
                }
              },
              theme: theme,
            ),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      if (type == UpdateType.EMAIL) {
        if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(result)) {
          toast("$result ${_appScreenText['isInvalidEmail']}");
          return;
        }
      }

      PlayerUpdateInput input = PlayerUpdateInput(
        name: type == UpdateType.SCREEN_NAME ? result : null,
        displayName: type == UpdateType.DISPLAY_NAME ? result : null,
        email: type == UpdateType.EMAIL ? result : null,
      );
      ConnectionDialog.show(
          context: context,
          loadingText: "${_appScreenText['updatingDetails']}");
      final res = await AuthService.updateUserDetails(input);

      if (res != null && res == true) {
        Alerts.showNotification(
            titleText: "${_appScreenText['userDetailsUpdated']}");
      } else {
        Alerts.showNotification(
            titleText: "${_appScreenText['failedToUpdate']}");
      }
      await _fetchMyProfile();
      ConnectionDialog.dismiss(context: context);
      //setState(() {});
    }
  }
}

enum UpdateType { SCREEN_NAME, DISPLAY_NAME, EMAIL }

class ListTileItem extends StatelessWidget {
  final String text;
  final String subTitleText;
  final String imagePath;
  final IconData icon;
  final int index;
  final int badgeCount;
  final Function onTapFunction;
  ListTileItem(
      {Key key,
      this.text,
      this.subTitleText,
      this.icon,
      this.imagePath,
      this.index,
      this.badgeCount,
      this.onTapFunction})
      : super(key: key);
  final List list = [
    Colors.amber.shade700,
    Colors.deepOrange.shade700,
    Colors.deepPurple.shade700,
    Colors.blueAccent.shade700,
    Colors.tealAccent.shade700,
    Colors.redAccent.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    Widget tileText = Text(
      text,
      style: AppDecorators.getHeadLine4Style(theme: theme),
    );
    if (badgeCount != null) {
      tileText = Badge(
        animationType: BadgeAnimationType.scale,
        showBadge: badgeCount > 0,
        position: BadgePosition.topEnd(top: 0, end: -80),
        badgeContent: Text(badgeCount.toString()),
        child: tileText,
      );
    }
    Widget image;
    if (this.icon != null) {
      image = Icon(
        this.icon,
        size: 24,
        color: list[index ?? 0],
      );
    } else {
      image = SvgPicture.asset(
        imagePath,
        color: list[index ?? 0],
        height: 24,
        width: 24,
      );
    }
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        //  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //decoration: AppStylesNew.actionRowDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image,
            //  Icon(Icons.bookmarks),
            AppDimensionsNew.getHorizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  tileText,
                  Visibility(
                    visible: subTitleText != null,
                    child: Text(
                      subTitleText ?? "",
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
