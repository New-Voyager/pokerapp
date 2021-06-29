import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/widgets/roud_icon_button.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/color_generator.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

class ProfilePageNew extends StatefulWidget {
  const ProfilePageNew({Key key}) : super(key: key);

  @override
  _ProfilePageNewState createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  String _displayName = "Bob John";
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    // Fetch my profile details
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchMyProfile();
    });
  }

  _fetchMyProfile() async {
    _displayName = await HiveDatasource.getInstance
            .getBox(BoxType.PROFILE_BOX)
            .get(AppStringsNew.keyProfileName) ??
        "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                HeadingWidget(heading: "My Profile"),
                Container(
                  decoration: AppStylesNew.actionRowDecoration.copyWith(
                    border: Border.all(
                      color: AppColorsNew.newBorderColor,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColorsNew.newGreenButtonColor,
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: CircleAvatar(
                          backgroundColor: AppColorsNew.actionRowBgColor,
                          radius: 48,
                          child: Icon(
                            Icons.person,
                            size: 48,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _displayName,
                              style: AppStylesNew.appBarTitleTextStyle,
                            ),
                            AppDimensionsNew.getHorizontalSpace(8),
                            RoundIconButton(
                              icon: Icons.edit,
                              bgColor: AppColorsNew.actionRowBgColor,
                              iconColor: AppColorsNew.labelColor,
                              size: 16,
                              onTap: () async {
                                _controller =
                                    TextEditingController(text: _displayName);
                                final result = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:
                                        AppColorsNew.darkGreenShadeColor,
                                    title: Text(
                                      AppStringsNew.nameChangeTitleText,
                                      style: AppStylesNew.labelTextStyle,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CardFormTextField(
                                          controller: _controller,
                                          maxLines: 1,
                                          hintText: AppStringsNew
                                              .hintTextForTextField,
                                        ),
                                        AppDimensionsNew.getVerticalSizedBox(
                                            12),
                                        RoundedColorButton(
                                          text: AppStringsNew.saveButtonText,
                                          backgroundColor:
                                              AppColorsNew.yellowAccentColor,
                                          textColor:
                                              AppColorsNew.darkGreenShadeColor,
                                          onTapFunction: () {
                                            if (_controller.text.isNotEmpty) {
                                              Navigator.of(context)
                                                  .pop(_controller.text);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                if (result != null && result.isNotEmpty) {
                                  _displayName = result;
                                  HiveDatasource.getInstance
                                      .getBox(BoxType.PROFILE_BOX)
                                      .put(AppStringsNew.keyProfileName,
                                          _displayName);
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Games",
                                    style: AppStylesNew.labelTextStyle),
                                Text(
                                  "254",
                                  style: AppStylesNew.valueTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Hands",
                                    style: AppStylesNew.labelTextStyle),
                                Text(
                                  "3254",
                                  style: AppStylesNew.valueTextStyle,
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
                  child: Column(
                    children: [
                      ListTileItem(
                        text: AppStringsNew.BookmarkedHandsTitle,
                        imagePath: AppAssetsNew.bookmarkedHandsImagePath,
                        index: 0,
                        onTapFunction: () =>
                            navigatorKey.currentState.pushNamed(
                          Routes.bookmarked_hands,
                          arguments: "",
                        ),
                      ),
                      ListTileItem(
                        text: AppStringsNew.statistics,
                        imagePath: AppAssetsNew.statisticsImagePath,
                        index: 1,
                        onTapFunction: () =>
                            navigatorKey.currentState.pushNamed(
                          Routes.hand_statistics,
                        ),
                      ),
                      ListTileItem(
                        text: AppStringsNew.customize,
                        imagePath: AppAssetsNew.customizeImagePath,
                        index: 2,
                        onTapFunction: () {},
                      ),
                      ListTileItem(
                        text: AppStringsNew.helpText,
                        imagePath: AppAssetsNew.bookmarkedHandsImagePath,
                        index: 3,
                        onTapFunction: () {},
                      ),
                      ListTileItem(
                        text: AppStringsNew.tellAFriendText,
                        imagePath: AppAssetsNew.announcementImagePath,
                        index: 4,
                        onTapFunction: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListTileItem extends StatelessWidget {
  final String text;
  final String imagePath;
  final int index;
  final Function onTapFunction;
  ListTileItem(
      {Key key, this.text, this.imagePath, this.index, this.onTapFunction})
      : super(key: key);
  List list = [
    Colors.amber.shade700,
    Colors.deepOrange.shade700,
    Colors.deepPurple.shade700,
    Colors.blueAccent.shade700,
    Colors.tealAccent.shade700,
    Colors.green.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: AppStylesNew.actionRowDecoration,
        child: Row(
          children: [
            SvgPicture.asset(
              imagePath,
              color: list[index ?? 0],
              height: 36,
              width: 36,
            ),
            //  Icon(Icons.bookmarks),
            AppDimensionsNew.getHorizontalSpace(16),
            Expanded(
              child: Text(
                text,
                style: AppStylesNew.cardHeaderTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
