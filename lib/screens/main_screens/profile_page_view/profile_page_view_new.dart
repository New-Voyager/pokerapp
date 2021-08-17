import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_version/get_version.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/user_update_input.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';

class ProfilePageNew extends StatefulWidget {
  const ProfilePageNew({Key key}) : super(key: key);

  @override
  _ProfilePageNewState createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  String _displayName = "Bob John";
  TextEditingController _controller;
  AuthModel _currentUser;

  @override
  void initState() {
    super.initState();
    // Fetch my profile details
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchMyProfile();
    });
  }

  _fetchMyProfile() async {
    _currentUser = await AuthService.getPlayerInfo();
    if (_currentUser != null) {
      _displayName = _currentUser.name;

      //  await HiveDatasource.getInstance
      //         .getBox(BoxType.PROFILE_BOX)
      //         .get(AppStringsNew.keyProfileName) ??
      //     "";
      setState(() {});
    } else {
      log("Failed to fetch user data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: _currentUser == null
                  ? CircularProgressWidget(
                      text: AppStringsNew.loadingDetailsText,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Container(
                          //   padding: EdgeInsets.all(16),
                          //   child: Text(AppStringsNew.myProfileTitleText,
                          //       style: AppDecorators.getAccentTextStyle(
                          //           theme: theme)),
                          // ),
                          HeadingWidget(
                              heading: AppStringsNew.myProfileTitleText),

                          Container(
                            decoration: AppDecorators.tileDecoration(theme),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Column(
                              children: [
                                Row(
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
                                        radius: 24,
                                        child: Icon(
                                          Icons.person,
                                          size: 24,
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
                                          AppDimensionsNew.getHorizontalSpace(
                                              8),
                                          RoundIconButton(
                                            icon: Icons.edit,
                                            bgColor: theme.fillInColor,
                                            iconColor: theme.accentColor,
                                            size: 16,
                                            onTap: () async {
                                              await _updateUserDetails(
                                                  UpdateType.SCREEN_NAME,
                                                  theme);
                                              // Fetch user details from server
                                            },
                                          ),
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
                                            AppStringsNew.gamesText,
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                          Text(
                                            "254",
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
                                          Text(AppStringsNew.hands,
                                              style: AppDecorators
                                                  .getSubtitle3Style(
                                                      theme: theme)),
                                          Text(
                                            "3254",
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
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              children: [
                                //
                                Container(
                                  decoration:
                                      AppDecorators.tileDecoration(theme),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //   margin:
                                      //       EdgeInsets.symmetric(horizontal: 16),
                                      //   child: Text(
                                      //     "Personal Details",
                                      //     style: AppStylesNew.labelTextStyle,
                                      //   ),
                                      // ),
                                      ListTileItem(
                                        text: _currentUser.name == null
                                            ? AppStringsNew.setDisplayName
                                            : AppStringsNew.changeDisplayName,
                                        subTitleText: _currentUser.name != null
                                            ? "(${_currentUser.name})"
                                            : "",
                                        imagePath:
                                            AppAssetsNew.statisticsImagePath,
                                        index: 1,
                                        onTapFunction: () async {
                                          await _updateUserDetails(
                                              UpdateType.DISPLAY_NAME, theme);
                                          // Fetch user details from server
                                        },
                                      ),
                                      ListTileItem(
                                        text: _currentUser.email == null
                                            ? AppStringsNew.setRecoveryMail
                                            : AppStringsNew.changeRecoveryMail,
                                        subTitleText: _currentUser.email != null
                                            ? "(${_currentUser.email})"
                                            : "",
                                        imagePath:
                                            AppAssetsNew.customizeImagePath,
                                        index: 2,
                                        onTapFunction: () async {
                                          await _updateUserDetails(
                                              UpdateType.EMAIL, theme);
                                          // Fetch user details from server
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                AppDimensionsNew.getVerticalSizedBox(16),
                                Container(
                                  decoration:
                                      AppDecorators.tileDecoration(theme),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //   margin:
                                      //       EdgeInsets.symmetric(horizontal: 16),
                                      //   child: Text(
                                      //     "Game Details",
                                      //     style: AppStylesNew.labelTextStyle,
                                      //   ),
                                      // ),
                                      ListTileItem(
                                        text:
                                            AppStringsNew.BookmarkedHandsTitle,
                                        imagePath: AppAssetsNew
                                            .bookmarkedHandsImagePath,
                                        index: 0,
                                        onTapFunction: () =>
                                            navigatorKey.currentState.pushNamed(
                                          Routes.bookmarked_hands,
                                          arguments: "",
                                        ),
                                      ),
                                      ListTileItem(
                                          text: AppStringsNew.statistics,
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
                                Container(
                                  decoration:
                                      AppDecorators.tileDecoration(theme),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //   margin:
                                      //       EdgeInsets.symmetric(horizontal: 16),
                                      //   child: Text(
                                      //     "Other Settings",
                                      //     style: AppStylesNew.labelTextStyle,
                                      //   ),
                                      // ),
                                      ListTileItem(
                                        text: AppStringsNew.customize,
                                        imagePath:
                                            AppAssetsNew.customizeImagePath,
                                        index: 2,
                                        onTapFunction: () {
                                          Navigator.of(context).pushNamed(
                                            Routes.game_screen_customize,
                                          );
                                          
                                          // Navigator.of(context).pushNamed(
                                          //   Routes.customize,
                                          // );
                                        },
                                      ),
                                      ListTileItem(
                                        text: AppStringsNew.helpText,
                                        imagePath: AppAssetsNew
                                            .bookmarkedHandsImagePath,
                                        index: 3,
                                        onTapFunction: () async {
                                          String version =
                                              await GetVersion.projectVersion;
                                          Navigator.of(context).pushNamed(
                                            Routes.help,
                                            arguments: version,
                                          );
                                        },
                                      ),
                                      ListTileItem(
                                        text: AppStringsNew.tellAFriendText,
                                        imagePath:
                                            AppAssetsNew.announcementImagePath,
                                        index: 4,
                                        onTapFunction: () {},
                                      ),
                                      AppDimensionsNew.getVerticalSizedBox(16),
                                      ListTileItem(
                                        text: AppStringsNew.logout,
                                        imagePath:
                                            AppAssetsNew.announcementImagePath,
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
                          AppDimensionsNew.getVerticalSizedBox(100),
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
              ? AppStringsNew.nameChangeTitleText
              : type == UpdateType.DISPLAY_NAME
                  ? AppStringsNew.displayNameChangeTitleText
                  : type == UpdateType.EMAIL
                      ? AppStringsNew.emailChangeTitleText
                      : "Update details",
          style: AppDecorators.getSubtitle3Style(theme: theme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              controller: _controller,
              maxLines: 1,
              hintText: AppStringsNew.hintTextForTextField,
              theme: theme,
            ),
            AppDimensionsNew.getVerticalSizedBox(12),
            RoundedColorButton(
              text: AppStringsNew.saveButtonText,
              backgroundColor: theme.accentColor,
              textColor: theme.primaryColorWithDark(),
              onTapFunction: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.of(context).pop(_controller.text);
                }
              },
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
          toast("$result is invalid email.");
          return;
        }
      }

      PlayerUpdateInput input = PlayerUpdateInput(
        name: type == UpdateType.SCREEN_NAME ? result : null,
        displayName: type == UpdateType.DISPLAY_NAME ? result : null,
        email: type == UpdateType.EMAIL ? result : null,
      );
      ConnectionDialog.show(
          context: context, loadingText: "Updating details...");
      final res = await AuthService.updateUserDetails(input);

      if (res != null && res == true) {
        Alerts.showNotification(titleText: "User details updated!");
      } else {
        Alerts.showNotification(titleText: "Failed to update user details!");
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
  final int index;
  final Function onTapFunction;
  ListTileItem(
      {Key key,
      this.text,
      this.subTitleText,
      this.imagePath,
      this.index,
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
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        //  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //decoration: AppStylesNew.actionRowDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              color: list[index ?? 0],
              height: 24,
              width: 24,
            ),
            //  Icon(Icons.bookmarks),
            AppDimensionsNew.getHorizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
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
