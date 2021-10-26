import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class ClubMembersDetailsView extends StatefulWidget {
  final String clubCode;
  final String playerId;

  ClubMembersDetailsView(this.clubCode, this.playerId);

  @override
  _ClubMembersDetailsView createState() =>
      _ClubMembersDetailsView(this.clubCode, this.playerId);
}

class _ClubMembersDetailsView extends State<ClubMembersDetailsView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_member_detail_view;
  bool loadingDone = false;
  ClubMemberModel _data;
  final String clubCode;
  final String playerId;
  TextEditingController _contactEditingController;
  TextEditingController _notesEditingController;

  _ClubMembersDetailsView(this.clubCode, this.playerId);

  AppTextScreen _appScreenText;

  _fetchData() async {
    _data = await ClubInteriorService.getClubMemberDetail(clubCode, playerId);
    loadingDone = true;
    setState(() {
      if (loadingDone && _data != null) {
        // update ui
        _contactEditingController =
            TextEditingController(text: _data.contactInfo);
        _notesEditingController = TextEditingController(text: _data.notes);
        _notesEditingController
            .addListener(() => _data.notes = _notesEditingController.text);
        _contactEditingController.addListener(
            () => _data.contactInfo = _contactEditingController.text);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("clubMembersDetailsView");

    _fetchData();
  }

  void goBack(BuildContext context) async {
    if (this._data.edited) {
      // save the data
      await ClubInteriorService.updateClubMember(this._data);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: "",
          ),
          body: !loadingDone
              ? CircularProgressWidget()
              : SingleChildScrollView(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        //banner view
                        Container(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor:
                                    theme.supportingColor.withAlpha(100),
                                child: ClipOval(
                                  child: Icon(
                                    AppIcons.user,
                                    color: theme.fillInColor,
                                    size: 24.dp,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  _data.name,
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  _appScreenText['lastActive'] +
                                      ' ' +
                                      _data.lastPlayedDate,
                                  style: AppDecorators.getSubtitle3Style(
                                      theme: theme),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5, top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //message
                                    CircleImageButton(
                                      theme: theme,
                                      icon: Icons.message,
                                      caption: _appScreenText['message'],
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.chatScreen,
                                          arguments: {
                                            'clubCode': widget.clubCode,
                                            'player': widget.playerId,
                                            'name': _data.name,
                                          },
                                        );
                                      },
                                    ),

                                    //boot
                                    CircleImageButton(
                                      icon: Icons.eject_rounded,
                                      theme: theme,
                                      caption: _appScreenText['boot'],
                                      onTap: () async {
                                        await kickPlayerOut();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: theme.supportingColor,
                        ),
                        detailTile(theme),
                        Divider(
                          color: theme.supportingColor,
                        ),
                        // contact info
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Icon(Icons.phone,
                                    color: theme.secondaryColor),
                              ),
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: CardFormTextField(
                                    theme: theme,
                                    controller: _contactEditingController,
                                    hintText: _appScreenText['mobileNumber'],
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: theme.fillInColor,
                        ),
                        // notes view
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.note,
                                  color: theme.secondaryColor,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: CardFormTextField(
                                    theme: theme,
                                    controller: _notesEditingController,
                                    hintText: _appScreenText['insertNotesHere'],
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> kickPlayerOut() async {
    final response = await showPrompt(context, 'Kick Player',
        'Do you want to kick the player out of the club?',
        positiveButtonText: "Yes", negativeButtonText: "No");
    log("$response");
    if (response != null && response == true) {
      ConnectionDialog.show(
          context: context, loadingText: "Removing player from club..");
      final result = await ClubsService.kickMember(clubCode, playerId);
      ConnectionDialog.dismiss(
        context: context,
      );

      if (result != null && result != '') {
        Alerts.showNotification(
            titleText: 'Kick Player',
            subTitleText: 'Player is removed from the club.');
        Navigator.of(context).pop();
      } else {
        Alerts.showNotification(
            titleText: 'Kick Player',
            subTitleText:
                'Unable to remove the player from the club. Try again later.');
      }
    }
  }

  void onCreditLimitEdit(BuildContext context) async {
    //await _showDialog(context);
  }

  Color getBalanceColor(double number, AppTheme theme) {
    if (number == null) {
      return Colors.white;
    }

    return number == 0
        ? Colors.white
        : number > 0
            ? theme.secondaryColor
            : theme.negativeOrErrorColor;
  }

  Widget detailTile(AppTheme theme) {
    //list view
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    AppIcons.poker_chip,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _appScreenText['gamesPlayed'],
                      textAlign: TextAlign.left,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.totalGames.toString(),
                      textAlign: TextAlign.center,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    AppIcons.poker_chip,
                    color: Colors.pink,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _appScreenText['totalBuyin'],
                      textAlign: TextAlign.left,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.totalBuyinStr,
                      textAlign: TextAlign.center,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    AppIcons.poker_chip,
                    color: Colors.yellow,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _appScreenText['totalWinnings'],
                      textAlign: TextAlign.left,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.totalWinningsStr,
                      textAlign: TextAlign.center,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    AppIcons.poker_chip,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _appScreenText['rakePaid'],
                      textAlign: TextAlign.left,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.rakeStr,
                      textAlign: TextAlign.center,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IconAndTitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final Widget child;
  IconAndTitleWidget({this.icon, this.text, this.onTap, this.child});
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        children: [
          child ??
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColorWithDark(),
                    boxShadow: [
                      BoxShadow(
                        color: theme.secondaryColor,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 0),
                      ),
                    ]),
                child: Icon(
                  icon ?? Icons.info,
                  size: 20.dp,
                  color: theme.supportingColor,
                ),
                padding: EdgeInsets.all(16),
              ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              text,
              style: AppDecorators.getSubtitle3Style(theme: theme),
            ),
          ),
        ],
      ),
    );
  }
}
