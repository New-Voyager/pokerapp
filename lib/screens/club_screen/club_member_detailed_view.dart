import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/set_tips_back_dialog.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class ClubMembersDetailsView extends StatefulWidget {
  final String clubCode;
  final String playerId;
  final ClubMemberModel member;
  final bool isClubOwner; // current session is owner?

  ClubMembersDetailsView(this.clubCode, this.playerId, this.isClubOwner, this.member);

  @override
  _ClubMembersDetailsView createState() =>
      _ClubMembersDetailsView(this.clubCode, this.playerId, this.isClubOwner);
}

class _ClubMembersDetailsView extends State<ClubMembersDetailsView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_member_detail_view;
  bool loadingDone = false;
  ClubMemberModel _data;
  final String clubCode;
  final String playerId;
  final bool isClubOwner; // current session is owner?
  bool creditTracking = false;
  String oldPhoneText;
  String oldNotes;
  int oldTipsBack;
  TextEditingController _contactEditingController;
  TextEditingController _notesEditingController;
  bool updated = false;
  bool closed = false;
  _ClubMembersDetailsView(this.clubCode, this.playerId, this.isClubOwner);

  AppTextScreen _appScreenText;

  _fetchData() async {
    _data = await ClubInteriorService.getClubMemberDetail(clubCode, playerId);
    oldPhoneText = _data.contactInfo;
    oldNotes = _data.notes;
    oldTipsBack = _data.tipsBack;
    loadingDone = true;

    if (closed) {
      return;
    } 

    if (widget.member == null) {
      _data.creditTracking = true;
      creditTracking = true;
    } else {
      creditTracking = widget.member.creditTracking ?? false;
    }

    if (_data != null) {
      // update ui
      _contactEditingController =
          TextEditingController(text: _data.contactInfo);
      _notesEditingController = TextEditingController(text: _data.notes);
      _notesEditingController.addListener(() {
        _data.notes = _notesEditingController.text;
        _data.edited = true;
      });
      _contactEditingController.addListener(() {
        _data.edited = true;
        _data.contactInfo = _contactEditingController.text;
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("clubMembersDetailsView");

    _fetchData();
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  void goBack(BuildContext context) async {
    if (this._data != null && this._data.edited) {
      if (oldPhoneText != _data.contactInfo ||
          oldNotes != _data.notes ||
          oldTipsBack != _data.tipsBack) {
        ConnectionDialog.show(
            context: context, loadingText: "Updating player information...");
        try {
          // save the data
          await ClubInteriorService.updateClubMember(this._data);
          updated = true;
        } catch (err) {}
        ConnectionDialog.dismiss(
          context: context,
        );
      }
    }
    Navigator.of(context).pop(updated);
  }

  List<Widget> getMemberButtons(AppTheme theme) {
    List<Widget> children = [
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

      // boot
      CircleImageButton(
        icon: Icons.eject_rounded,
        theme: theme,
        caption: _appScreenText['boot'],
        onTap: () async {
          await kickPlayerOut();
        },
      ),
    ];

    if (_data.isManager) {
      children.add(
          // demote
          CircleImageButton(
        icon: Icons.arrow_downward_rounded,
        theme: theme,
        caption: 'Demote',
        onTap: () async {
          await demoteManager();
        },
      ));
    } else {
      children.add(
          // promote
          CircleImageButton(
        icon: Icons.arrow_upward_rounded,
        theme: theme,
        caption: 'Promote',
        onTap: () async {
          await promoteManager();
        },
      ));
    }
    return children;
  }

  void demoteManager() async {
    await changeManagerStatus(false);
  }

  void promoteManager() async {
    await changeManagerStatus(true);
  }

  @override
  Widget build(BuildContext context) {
    String memberRole = '';
    if (loadingDone) {
      if (_data.isManager ?? false) {
        memberRole = 'Manager';
      } else if (_data.isOwner) {
        memberRole = 'Owner';
      } else {
        memberRole = 'Member';
      }
    }

    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: "",
            onBackHandle: () {
              goBack(context);
            },
          ),
          body: !loadingDone
              ? CircularProgressWidget()
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                                  style: AppDecorators.getHeadLine2Style(
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
                              Text(memberRole,
                                  textAlign: TextAlign.end,
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme)),
                              _data.isOwner
                                  ? SizedBox.shrink()
                                  : Container(
                                      padding:
                                          EdgeInsets.only(bottom: 5, top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: getMemberButtons(theme),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Divider(
                          color: theme.supportingColor,
                        ),
                        
                        !creditTracking ? Container()
                        : ListTile(
                          leading: Icon(Icons.credit_card,
                              color: theme.secondaryColor),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Credits",
                                style: AppDecorators.getHeadLine4Style(
                                    theme: theme),
                              ),
                              SizedBox(width: 30.pw),
                              Text(
                                DataFormatter.chipsFormat(
                                    _data.availableCredit),
                                style: AppDecorators.getHeadLine3Style(
                                        theme: theme)
                                    .copyWith(
                                        color: _data.availableCredit < 0
                                            ? Colors.redAccent
                                            : Colors.greenAccent),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: theme.accentColor),
                          onTap: () async {
                            bool ret = await Navigator.pushNamed(
                              context,
                              Routes.club_member_credit_detail_view,
                              arguments: {
                                'clubCode': widget.clubCode,
                                'playerId': widget.playerId,
                                'owner': true,
                              },
                            ) as bool;
                            if (ret ?? false) {
                              _fetchData();
                            }
                          },
                        ),
                        !creditTracking ? Container()
                        : Divider(
                          color: theme.supportingColor,
                        ),
                        detailTile(theme),
                        Divider(
                          color: theme.supportingColor,
                        ),
                        !creditTracking ? Container()
                        :  tipsBack(theme),
                        Divider(
                          color: theme.fillInColor,
                        ),
                        contactInfo(theme),
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

  Widget tipsBack(AppTheme theme) {
    return ListTile(
      leading: Icon(Icons.credit_card, color: theme.secondaryColor),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tips Back",
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          SizedBox(width: 30.pw),
          Text(
            DataFormatter.chipsFormat(_data.tipsBack.toDouble()),
            style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
                color: _data.availableCredit < 0
                    ? Colors.redAccent
                    : Colors.greenAccent),
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: theme.accentColor),
      onTap: () async {
        log('something');
        int value = await SetTipsBackDialog.prompt(
            context: context,
            clubCode: widget.clubCode,
            playerUuid: widget.playerId,
            tipsBack: _data.tipsBack);
        if (value != null && !closed) {
          if (value <= 100) {
            _data.tipsBack = value;
            updated = true;
            this._data.edited = true;
            setState(() {});
          }
        }
      },
    );
  }

  Widget contactInfo(AppTheme theme) {
    return // contact info
        Container(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Icon(Icons.phone, color: theme.secondaryColor),
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
    );
  }

  Future<void> kickPlayerOut() async {
    final response = await showPrompt(
        context, _appScreenText['kickTitle'], _appScreenText['kickPrompt'],
        positiveButtonText: _appScreenText['kickConfirm'],
        negativeButtonText: _appScreenText['kickNegative']);
    if (response != null && response == true) {
      ConnectionDialog.show(
          context: context, loadingText: "Removing player from club..");
      final result = await ClubsService.kickMember(clubCode, playerId);
      ConnectionDialog.dismiss(
        context: context,
      );

      if (result != null && result != '') {
        updated = true;
        Alerts.showNotification(
            titleText: 'Kick Player',
            subTitleText: 'Player is removed from the club.');
        Navigator.of(context).pop(updated);
      } else {
        Alerts.showNotification(
            titleText: 'Kick Player',
            subTitleText:
                'Unable to remove the player from the club. Try again later.');
      }
    }
  }

  Future<void> changeManagerStatus(bool promote) async {
    String prompt = 'Do you want to promote the player as Manager?';
    if (!promote) {
      prompt = 'Do you want to demote the player from Manager?';
    }
    final response = await showPrompt(context, 'Manager', prompt,
        positiveButtonText: 'Yes', negativeButtonText: 'No');
    if (response != null && response == true) {
      ConnectionDialog.show(context: context, loadingText: "Updating...");
      final result =
          await ClubsService.promotePlayer(clubCode, playerId, promote);
      ConnectionDialog.dismiss(
        context: context,
      );

      if (result != null && result != '') {
        updated = true;
        String text = 'Player is promoted as manager';
        if (!promote) {
          text = 'Player is demoted from manager';
        }
        Alerts.showNotification(titleText: 'Manager', subTitleText: text);
        _data.isManager = promote;
        setState(() {});
      } else {
        Alerts.showNotification(
            titleText: 'Manager',
            subTitleText: 'Failed to update the status. Try again later.');
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
