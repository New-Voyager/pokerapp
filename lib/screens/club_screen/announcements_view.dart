import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

class AnnouncementsView extends StatefulWidget {
  final String clubName;
  const AnnouncementsView({Key key, this.clubName}) : super(key: key);

  @override
  _AnnouncementsViewState createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: AppStylesNew.BgGreenRadialGradient,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      BackArrowWidget(),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppStringsNew.announcementsTitleText,
                              style: AppStylesNew.accentTextStyle,
                            ),
                            Text(
                              widget.clubName,
                              style: AppStylesNew.labelTextStyle,
                            ),
                          ],
                        ),
                      ),
                      RoundedColorButton(
                        text: "+ New",
                        backgroundColor: AppColorsNew.yellowAccentColor,
                        textColor: AppColorsNew.darkGreenShadeColor,
                        onTapFunction: () => _handleNewAnnouncement(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(8),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: AppStylesNew.actionRowDecoration,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      "Hellow ther this is notifciation one for testing Hellow ther this is notifciation one for testing..."),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColorsNew.labelColor,
                                  size: 16,
                                ),
                                AppDimensionsNew.getHorizontalSpace(4),
                                Text(
                                  "Soma",
                                  style: AppStylesNew.labelTextStyle,
                                ),
                                AppDimensionsNew.getHorizontalSpace(16),
                                Icon(
                                  Icons.access_time,
                                  color: AppColorsNew.labelColor,
                                  size: 16,
                                ),
                                AppDimensionsNew.getHorizontalSpace(4),
                                Text(
                                  "15-Jun-2021",
                                  style: AppStylesNew.labelTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _handleNewAnnouncement() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColorsNew.newBorderColor,
              )),
          backgroundColor: AppColorsNew.newDialogBgColor,
          title: Row(
            children: [
              Icon(
                Icons.campaign,
                color: AppColorsNew.labelColor,
              ),
              AppDimensionsNew.getHorizontalSpace(8),
              Text(
                "New Announcement",
                style: AppStylesNew.labelTextStyle,
              )
            ],
          ),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter text here",
                  fillColor: AppColorsNew.actionRowBgColor,
                  filled: true,
                  border: InputBorder.none,
                ),
                minLines: 5,
                maxLines: 8,
              ),
              AppDimensionsNew.getVerticalSizedBox(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundedColorButton(
                    text: AppStringsNew.cancelButtonText,
                    textColor: AppColorsNew.newRedButtonColor,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColorsNew.newRedButtonColor,
                  ),
                  RoundedColorButton(
                    text: AppStringsNew.announceButtonText,
                    textColor: AppColorsNew.darkGreenShadeColor,
                    backgroundColor: AppColorsNew.newGreenButtonColor,
                    borderColor: AppColorsNew.darkGreenShadeColor,
                  ),
                ],
              ),
              AppDimensionsNew.getVerticalSizedBox(16),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        );
      },
    );
  }
}
