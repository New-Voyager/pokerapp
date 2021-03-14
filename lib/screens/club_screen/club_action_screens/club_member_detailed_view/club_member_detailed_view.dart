import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';

class ClubMembersDetailsView extends StatefulWidget {
  String clubCode;
  String playerId;

  ClubMembersDetailsView(ClubMemberModel data) {
    this.clubCode = data.clubCode;
    this.playerId = data.playerId;
  }

  @override
  _ClubMembersDetailsView createState() =>
      _ClubMembersDetailsView(this.clubCode, this.playerId);
}

class _ClubMembersDetailsView extends State<ClubMembersDetailsView> {
  bool loadingDone = false;
  ClubMemberModel _data;
  final String clubCode;
  final String playerId;
  TextEditingController _contactEditingController;
  TextEditingController _notesEditingController;

  _ClubMembersDetailsView(this.clubCode, this.playerId);
  bool _isEditingContact = false;

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
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 14,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => goBack(context),
        ),
        titleSpacing: 0,
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text(
          "Members",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.appAccentColor,
            fontSize: 14.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                child: Column(
                  children: [
                    //banner view
                    Container(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(
                                    (math.Random().nextDouble() * 0xFFFFFF)
                                        .toInt())
                                .withOpacity(1.0),
                            child: ClipOval(
                              child: Icon(AppIcons.user),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              _data.name,
                              style: TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Last active: " + _data.lastPlayedDate,
                              style: TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //message
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.chatScreen,
                                          arguments: {
                                            'clubCode': widget.clubCode,
                                            'player': widget.playerId,
                                          },
                                        );
                                      },
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: Icon(
                                        AppIcons.message,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.all(16),
                                      shape: CircleBorder(),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.chatScreen,
                                          arguments: {
                                            'clubCode': widget.clubCode,
                                            'player': widget.playerId,
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Message",
                                              style: TextStyle(
                                                fontFamily:
                                                    AppAssets.fontFamilyLato,
                                                color: AppColors.appAccentColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //boot
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.eject,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(16),
                                      shape: CircleBorder(),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Boot",
                                            style: TextStyle(
                                              fontFamily:
                                                  AppAssets.fontFamilyLato,
                                              color: AppColors.appAccentColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //settle
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.account_balance,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(16),
                                      shape: CircleBorder(),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Settle",
                                            style: TextStyle(
                                              fontFamily:
                                                  AppAssets.fontFamilyLato,
                                              color: AppColors.appAccentColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.listViewDividerColor,
                    ),
                    detailTile(),
                    Divider(
                      color: AppColors.listViewDividerColor,
                    ),
                    // contact info
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: CupertinoTextField(
                                controller: _contactEditingController,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.listViewDividerColor,
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
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: CupertinoTextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: _notesEditingController,
                                placeholder: 'insert notes here',
                                placeholderStyle: TextStyle(
                                  color: AppColors.listViewDividerColor,
                                  fontFamily: AppAssets.fontFamilyLato,
                                  fontSize: 18,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppAssets.fontFamilyLato,
                                  fontSize: 18,
                                ),
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
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
    );
  }

  Widget _editContactTextField() {
    if (_isEditingContact)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              _data.contactInfo = newValue;
              _isEditingContact = false;
            });
          },
          autofocus: true,
          controller: _contactEditingController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingContact = true;
          });
        },
        child: Text(
          _data.contactInfo,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }

  _showDialog(BuildContext context) async {
    final textField = new CupertinoTextField(
      controller: TextEditingController(text: _data.creditLimit.toString()),
      autofocus: true,
      keyboardType: TextInputType.number,
      onSubmitted: (value) => _data.creditLimit = int.parse(value),
      style: TextStyle(
        color: Colors.black,
        fontFamily: AppAssets.fontFamilyLato,
        fontSize: 18,
      ),
    );

    await showDialog<String>(
      context: context,
      builder: (_) => new _SystemPadding(
        child: new AlertDialog(
          backgroundColor: AppColors.cardBackgroundColor,
          contentPadding: const EdgeInsets.all(8.0),
          content: new Row(
            children: <Widget>[
              Text(
                'Credit Limit',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppAssets.fontFamilyLato,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10, width: 20),
              new Expanded(child: textField)
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.appAccentColor,
                    fontFamily: AppAssets.fontFamilyLato,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text(
                  'Set',
                  style: TextStyle(
                    color: AppColors.appAccentColor,
                    fontFamily: AppAssets.fontFamilyLato,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  String value = textField.controller.value.text;
                  Navigator.pop(context);
                  _data.creditLimit = int.parse(value);
                })
          ],
        ),
      ),
    );
  }

  void onCreditLimitEdit(BuildContext context) async {
    await _showDialog(context);
  }

  Color getBalanceColor(double number) {
    if (number == null) {
      return Colors.white;
    }

    return number == 0
        ? Colors.white
        : number > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  Widget detailTile() {
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
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Balance",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.balanceStr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: getBalanceColor(_data.balance),
                        fontSize: 20,
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    AppIcons.poker_chip,
                    color: Colors.cyan,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Credit Limit",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () => onCreditLimitEdit(context),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _data.creditLimit.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.blue,
                            )
                          ]),
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
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Games Played",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.totalGames.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
                      "Total Buy-in",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.totalBuyinStr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
                      "Total Winnings",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.totalWinningsStr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
                      "Rake Paid",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _data.rakeStr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                      ),
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

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
