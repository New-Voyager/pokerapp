import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:provider/provider.dart';

class AnnouncementsView extends StatefulWidget {
  final ClubHomePageModel clubModel;
  const AnnouncementsView({Key key, this.clubModel}) : super(key: key);

  @override
  _AnnouncementsViewState createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  List<AnnouncementModel> _listOfAnnounce = [];
  bool loading = true;
  AppTextScreen _appScreenText;
  bool canAnnounce = false;
  @override
  void initState() {
    super.initState();
    if (widget.clubModel.isOwner) {
      canAnnounce = true;
    } else {
      if (widget.clubModel.isManager &&
          widget.clubModel.role.makeAnnouncement) {
        canAnnounce = true;
      }
    }
    _appScreenText = getAppTextScreen("announcementsView");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchAnnouncements();
    });
  }

  _fetchAnnouncements() async {
    _listOfAnnounce.clear();
    _listOfAnnounce.addAll(
        await ClubsService.getAnnouncementsForAClub(widget.clubModel.clubCode));
    _listOfAnnounce.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    setState(() {
      loading = false;
    });
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
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  _appScreenText['announcements'],
                                  style: AppDecorators.getAccentTextStyle(
                                    theme: theme,
                                  ),
                                ),
                                Text(
                                  widget.clubModel.clubName,
                                  style: AppDecorators.getSubtitle3Style(
                                      theme: theme),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: canAnnounce,
                            child: RoundRectButton(
                                text: "+ ${_appScreenText['NEW']}",
                                onTap: () => _handleNewAnnouncement(theme),
                                theme: theme),
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
                                    _appScreenText['noAnnouncements'],
                                    style: AppDecorators.getAccentTextStyle(
                                      theme: theme,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: _listOfAnnounce.length,
                                  itemBuilder: (context, index) {
                                    AnnouncementModel model =
                                        _listOfAnnounce.elementAt(index);
                                    return getAnnouncementItem(model, theme);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  _handleNewAnnouncement(AppTheme theme) async {
    final _textCounter = ValueNotifier<int>(0);
    final int _maxAnnouncementChars = 250;

    final res = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _controller = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.secondaryColor,
            ),
          ),
          backgroundColor: theme.fillInColor,
          title: Row(
            children: [
              Icon(
                Icons.campaign,
                color: theme.secondaryColorWithDark(),
              ),
              AppDimensionsNew.getHorizontalSpace(8),
              Text(
                _appScreenText['newAnnouncements'],
                style: AppDecorators.getSubtitle3Style(theme: theme),
              )
            ],
          ),
          content: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardFormTextField(
                  onChanged: (String t) {
                    _textCounter.value = t.length;
                  },
                  hintText: _appScreenText['enterTextHere'],
                  controller: _controller,
                  maxLines: 8,
                  theme: theme,
                ),
                AppDimensionsNew.getVerticalSizedBox(16),
                ValueListenableBuilder(
                  valueListenable: _textCounter,
                  builder: (_, int c, __) => Text(
                    '${c} / $_maxAnnouncementChars',
                    style: TextStyle(
                      color:
                          c > _maxAnnouncementChars ? Colors.red : Colors.white,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                AppDimensionsNew.getVerticalSizedBox(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundRectButton(
                      text: _appScreenText['cancel'],
                      theme: theme,
                      // borderColor: theme.secondaryColor,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _textCounter,
                      builder: (_, int c, __) => Opacity(
                        opacity: c > _maxAnnouncementChars ? 0.70 : 1.0,
                        child: RoundRectButton(
                          text: _appScreenText['announce'],
                          onTap: () {
                            if (c > _maxAnnouncementChars) return;
                            Navigator.of(context).pop(_controller.text);
                          },
                          theme: theme,
                        ),
                      ),
                    ),
                  ],
                ),
                AppDimensionsNew.getVerticalSizedBox(16),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        );
      },
    );

    if (res != null) {
      final result = await ClubsService.createAnnouncement(
        widget.clubModel.clubCode,
        res,
        DateTime.now().add(
          Duration(days: 10),
        ),
      );
      if (result.toString().isNotEmpty) {
        Alerts.showNotification(
            titleText: _appScreenText['announcementPosted'],
            duration: Duration(seconds: 5));
        setState(() {
          loading = true;
        });
        await _fetchAnnouncements();
      } else {
        Alerts.showNotification(
            titleText: _appScreenText['failedToAnnounce'],
            duration: Duration(seconds: 5));
      }
    }
  }

  Widget getAnnouncementItem(AnnouncementModel model, AppTheme theme) {
    return Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: AppDecorators.tileDecoration(theme),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.text,
                  style: AppDecorators.getHeadLine4Style(theme: theme),
                ),
              ),
            ],
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Posted by " +
                    (model.playerName == '' ? 'admin' : model.playerName),
                style: AppDecorators.getSubtitle3Style(
                  theme: theme,
                ),
              ),
              Row(
                children: [
                  AppDimensionsNew.getHorizontalSpace(16),
                  Icon(
                    Icons.access_time,
                    color: theme.secondaryColorWithDark(),
                    size: 16,
                  ),
                  AppDimensionsNew.getHorizontalSpace(4),
                  Text(
                    "${DataFormatter.dateFormat(model.createdAt)}",
                    style: AppDecorators.getSubtitle3Style(
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }
}
