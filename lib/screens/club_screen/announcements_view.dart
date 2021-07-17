import 'package:flutter/material.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

class AnnouncementsView extends StatefulWidget {
  final ClubHomePageModel clubModel;
  const AnnouncementsView({Key key, this.clubModel}) : super(key: key);

  @override
  _AnnouncementsViewState createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  List<AnnouncementModel> _listOfAnnounce = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchAnnouncements();
    });
  }

  _fetchAnnouncements() async {
    _listOfAnnounce.clear();
    _listOfAnnounce.addAll(
        await ClubsService.getAnnouncementsForAClub(widget.clubModel.clubCode));
    setState(() {
      loading = false;
    });
  }

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
                              widget.clubModel.clubName,
                              style: AppStylesNew.labelTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.clubModel.isOwner,
                        child: RoundedColorButton(
                          text: "+ New",
                          backgroundColor: AppColorsNew.yellowAccentColor,
                          textColor: AppColorsNew.darkGreenShadeColor,
                          onTapFunction: () => _handleNewAnnouncement(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressWidget(),
                        )
                      : _listOfAnnounce.isEmpty
                          ? Center(
                              child: Text(
                                AppStringsNew.noAnnouncementText,
                                style: AppStylesNew.titleTextStyle,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _listOfAnnounce.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                AnnouncementModel model =
                                    _listOfAnnounce.elementAt(index);
                                return Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: AppStylesNew.actionRowDecoration,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(model.text),
                                          ),
                                        ],
                                      ),
                                      AppDimensionsNew.getVerticalSizedBox(16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: AppColorsNew.labelColor,
                                            size: 16,
                                          ),
                                          AppDimensionsNew.getHorizontalSpace(
                                              4),
                                          Text(
                                            "Soma",
                                            style: AppStylesNew.labelTextStyle,
                                          ),
                                          AppDimensionsNew.getHorizontalSpace(
                                              16),
                                          Icon(
                                            Icons.access_time,
                                            color: AppColorsNew.labelColor,
                                            size: 16,
                                          ),
                                          AppDimensionsNew.getHorizontalSpace(
                                              4),
                                          Text(
                                            "${DataFormatter.dateFormat(model.createdAt)}",
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
    final res = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _controller = TextEditingController();
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
               AppStringsNew.newAnnouncementText,
                style: AppStylesNew.labelTextStyle,
              )
            ],
          ),
          content: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppStringsNew.enterTextHint,
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
                    onTapFunction: () => Navigator.of(context).pop(),
                  ),
                  RoundedColorButton(
                    text: AppStringsNew.announceButtonText,
                    textColor: AppColorsNew.darkGreenShadeColor,
                    backgroundColor: AppColorsNew.newGreenButtonColor,
                    borderColor: AppColorsNew.darkGreenShadeColor,
                    onTapFunction: () =>
                        Navigator.of(context).pop(_controller.text),
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

    if (res != null) {
      final result = await ClubsService.createAnnouncement(
          widget.clubModel.clubCode,
          res,
          DateTime.now().add(Duration(days: 10)));
      if (result) {
        Alerts.showNotification(
            titleText: AppStringsNew.announcementSuccessText,
            duration: Duration(seconds: 5));
        setState(() {
          loading = true;
        });
        await _fetchAnnouncements();
       
      } else {
        Alerts.showNotification(
            titleText: AppStringsNew.announcementFailedText,
            duration: Duration(seconds: 5));
      }
    }
  }
}
