import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/member_activity_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/set_tips_back_dialog.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/date_range_picker.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/texts.dart';

class ClubMembersUnderAgent extends StatefulWidget {
  final ClubMemberModel member;

  ClubMembersUnderAgent(this.member, {Key key}) : super(key: key);

  @override
  State<ClubMembersUnderAgent> createState() => _ClubMembersUnderAgentState();
}

class _ClubMembersUnderAgentState extends State<ClubMembersUnderAgent>
    with SingleTickerProviderStateMixin {
  AppTheme theme;
  TabController _tabController;
  int _selectedTabIndex = 0;
  // List<Player> allPlayers = [];
  // List<Player> selectedPlayers = [];
  ClubMemberModel agent;
  List<ClubMemberModel> searchPlayers = [];
  List<ClubMemberModel> playersUnderMe = [];
  List<ClubMemberModel> playersUnderNoAgents = [];

  List<ClubMemberModel> addedPlayers = [];
  List<ClubMemberModel> removedPlayers = [];

  List<ClubMemberModel> allPlayers = [];
  bool loading = true;
  bool playersLoading = false;

  bool playersEditMode = false;
  TextEditingController searchTextController = TextEditingController();

  void initialize() async {
    final clubMembers =
        await appState.cacheService.getMembers(widget.member.clubCode);

    for (final member in clubMembers) {
      if (member.playerId == widget.member.playerId) {
        agent = member;
        break;
      }
    }

    for (final member in clubMembers) {
      if (member.agentUuid == widget.member.playerId) {
        playersUnderMe.add(member);
        allPlayers.add(member);
      } else {
        if (member.agentUuid == null || member.agentUuid == '') {
          playersUnderNoAgents.add(member);
          allPlayers.add(member);
        }
      }
    }

    theme = AppTheme.getTheme(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        exitPlayersEditMode();
        _selectedTabIndex = _tabController.index;
      });
    });

    searchTextController.addListener(() {
      String searchText = searchTextController.text.trim();
      setState(() {
        searchPlayers = allPlayers
            .where((element) =>
                (element.name.toLowerCase().contains(searchText.toLowerCase())))
            .toList();
      });
    });

    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    }
    final theme = AppTheme.getTheme(context);
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: widget.member.name,
          onBackHandle: () {
            goBack(context);
          },
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: theme.accentColor,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Players",
                    ),
                    Tab(
                      text: "Report",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    playersTab(theme),
                    ReportTab(widget.member, widget.member.clubCode,
                        widget.member.playerId),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: (_selectedTabIndex == 0 && !playersEditMode)
            ? FloatingActionButton(
                backgroundColor: theme.accentColor,
                onPressed: () async {
                  setState(() {
                    playersEditMode = true;
                  });
                },
                child: Icon(
                  Icons.edit,
                  color: theme.primaryColorWithDark(),
                ),
              )
            : null,
      ),
    );
  }

  Widget playerUnderMeList(AppTheme theme) {
    return Expanded(
      key: UniqueKey(),
      child: ListView.builder(
          itemCount: playersUnderMe.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            ClubMemberModel member = playersUnderMe[index];
            return Container(
              margin: EdgeInsets.only(
                bottom: 10.ph,
              ),
              child: LabelText(label: member.name, theme: theme),
            );
          }),
    );
  }

  Widget nonAgentPlayers(AppTheme theme) {
    List<ClubMemberModel> players = allPlayers;
    if (searchPlayers.length > 0) {
      players = searchPlayers;
    }

    final Map<String, bool> underMePlayer = {};
    for (final player in players) {
      bool underMe = false;
      for (final memberUnderMe in playersUnderMe) {
        if (memberUnderMe.playerId == player.playerId) {
          underMe = true;
          break;
        }
      }
      if (underMe) {
        underMePlayer[player.playerId] = true;
      }
    }
    List<ClubMemberModel> playersSorted = [];
    Map<String, bool> addedToList = {};
    for (final player in players) {
      if (underMePlayer[player.playerId] ?? false) {
        playersSorted.add(player);
        addedToList[player.playerId] = true;
      }
    }
    for (final player in players) {
      if (!(addedToList[player.playerId] ?? false)) {
        playersSorted.add(player);
      }
    }

    return Expanded(
      child: ListView.builder(
          itemCount: playersSorted.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            ClubMemberModel member = playersSorted[index];
            bool underMe = false;
            for (final memberUnderMe in playersUnderMe) {
              if (memberUnderMe.playerId == member.playerId) {
                underMe = true;
                break;
              }
            }
            if (underMe) {
              for (final removedPlayer in removedPlayers) {
                if (removedPlayer.playerId == member.playerId) {
                  underMe = false;
                  break;
                }
              }
            } else {
              for (final addedPlayer in addedPlayers) {
                if (addedPlayer.playerId == member.playerId) {
                  underMe = true;
                  break;
                }
              }
            }
            return Container(
                margin: EdgeInsets.only(
                  bottom: 10.ph,
                ),
                child: SwitchWidget2(
                    value: underMe,
                    label: member.name,
                    onChange: (bool v) {
                      if (v) {
                        for (final player in removedPlayers) {
                          if (player.playerId == member.playerId) {
                            //playerFound = true;
                            removedPlayers.remove(player);
                            break;
                          }
                        }
                        for (final player in addedPlayers) {
                          if (player.playerId == member.playerId) {
                            addedPlayers.remove(player);
                            break;
                          }
                        }
                        addedPlayers.add(member);
                      } else {
                        for (final player in addedPlayers) {
                          if (player.playerId == member.playerId) {
                            addedPlayers.remove(player);
                            break;
                          }
                        }
                        for (final player in removedPlayers) {
                          if (player.playerId == member.playerId) {
                            //playerFound = true;
                            removedPlayers.remove(player);
                            break;
                          }
                        }
                        removedPlayers.add(member);
                      }
                    }));
          }),
    );
  }

  Widget playersTab(AppTheme theme) {
    if (playersLoading) {
      return CircularProgressWidget(text: 'Loading...');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          !playersEditMode ? playerUnderMeList(theme) : Container(),
          playersEditMode
              ? Padding(
                  padding: EdgeInsets.only(top: 16.ph),
                  child: TextField(
                    controller: searchTextController,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: theme.accentColor)),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: theme.accentColor),
                      ),
                      prefixIcon: Icon(Icons.search, color: theme.accentColor),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(height: 8.ph),
          playersEditMode ? nonAgentPlayers(theme) : Container(),
          playersEditMode
              ? Column(
                  children: [
                    Divider(
                      color: Colors.white,
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundRectButton(
                          onTap: () async {
                            List<ClubMemberModel> newlyAddedPlayers = [];
                            List<ClubMemberModel> removedExistingPlayers = [];
                            for (final member in addedPlayers) {
                              bool found = false;
                              for (final player in playersUnderMe) {
                                if (player.playerId == member.playerId) {
                                  found = true;
                                  break;
                                }
                              }
                              if (!found) {
                                newlyAddedPlayers.add(member);
                              }
                            }

                            for (final member in removedPlayers) {
                              bool found = false;
                              for (final player in playersUnderMe) {
                                if (player.playerId == member.playerId) {
                                  found = true;
                                  break;
                                }
                              }
                              if (found) {
                                removedExistingPlayers.add(member);
                              }
                            }

                            setState(() {
                              playersLoading = true;
                            });

                            for (final member in newlyAddedPlayers) {
                              await ClubInteriorService.setAgent(
                                  member.clubCode,
                                  member.playerId,
                                  agent.playerId);
                              member.agentUuid = agent.playerId;
                              member.agentName = agent.name;
                              playersUnderMe.add(member);
                            }

                            for (final member in removedExistingPlayers) {
                              await ClubInteriorService.setAgent(
                                  member.clubCode, member.playerId, '');
                              member.agentUuid = '';
                              member.agentName = '';
                              playersUnderMe.remove(member);
                            }
                            setState(() {
                              exitPlayersEditMode();
                            });
                          },
                          text: 'Apply', //_appScreenText['hostGame'],
                          theme: theme,
                        ),
                        SizedBox(width: 60.pw),
                        RoundRectButton(
                          onTap: () async {
                            setState(() {
                              exitPlayersEditMode();
                            });
                          },
                          text: 'Cancel', //_appScreenText['hostGame'],
                          theme: theme,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.ph,
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void exitPlayersEditMode() {
    playersEditMode = false;
    playersLoading = false;
    searchTextController.text = "";
  }
}

class ReportTab extends StatefulWidget {
  final String clubCode;
  final String agentId;
  final ClubMemberModel member;

  ReportTab(this.member, this.clubCode, this.agentId);

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final int report_player_width = 2;

  final int report_hands_width = 2;

  final int report_tips_width = 2;

  final int report_buyin_width = 2;

  final int report_profit_width = 2;

  int _selectedReportDateRangeIndex = 0;
  bool loading = true;
  DateTimeRange _dateTimeRange;
  int dateSelection = 1;
  double totalFees = 0;
  double agentFeeBackPercent = 30;
  double agentFeeBackAmount = 0;
  List<MemberActivity> memberActivities = [];
  void fetchData() async {
    loading = true;
    setState(() {});

    // this week
    // DateTime now = DateTime.now();
    // DateTime nowAdjust = DateTime(now.year, now.month, now.day);
    // DateTime start = findFirstDateOfTheWeek(nowAdjust).toUtc();
    // DateTime end = findLastDateOfTheWeek(nowAdjust).toUtc();

    // last week
    // this month
    // last month
    // custom date

    // load here
    final activities = await ClubInteriorService.getAgentPlayerActivities(
        widget.clubCode,
        widget.agentId,
        _dateTimeRange.start,
        _dateTimeRange.end);
    memberActivities = [];
    Map<String, MemberActivity> activityMap = {};
    for (final activity in activities) {
      if (activityMap[activity.playerUuid] == null) {
        activityMap[activity.playerUuid] = activity;
      }
    }
    for (final activity in activityMap.values) {
      memberActivities.add(activity);
    }

    totalFees = 0;
    for (final member in memberActivities) {
      totalFees += member.tips;
    }
    agentFeeBackPercent = (widget.member.agentFeeBack ?? 0).toDouble();
    agentFeeBackAmount = totalFees * agentFeeBackPercent / 100;
    loading = false;
    setState(() {});
  }

  void initDates() {
    var now = DateTime.now();
    var startDate = now.subtract(Duration(days: now.weekday));
    startDate =
        DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    var endDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
  }

  @override
  void initState() {
    super.initState();

    initDates();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.getTheme(context);

    final now = DateTime.now();

    String startDateStr = DateFormat('dd MMM').format(_dateTimeRange.start);
    String endDateStr = DateFormat('dd MMM').format(_dateTimeRange.end);
    if (_dateTimeRange.start.year != now.year) {
      startDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.start);
      endDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.end);
    }

    if (loading) {
      return CircularProgressWidget(text: 'Loading...');
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.ph, left: 16.pw, right: 16.pw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioToggleButtonsWidget<String>(
                    defaultValue: _selectedReportDateRangeIndex,
                    values: [
                      'This\nWeek',
                      'Last\nWeek',
                      'This\nMonth',
                      'Last\nMonth',
                      'Custom',
                      // 'Last Week',
                      // 'Last Month'
                    ],
                    onSelect: (int value) async {
                      _selectedReportDateRangeIndex = value;
                      if (value == 0) {
                        var startDate =
                            now.subtract(Duration(days: now.weekday - 1));
                        startDate = DateTime(startDate.year, startDate.month,
                            startDate.day, 0, 0, 0);
                        var endDate =
                            DateTime(now.year, now.month, now.day, 0, 0, 0);
                        _dateTimeRange =
                            DateTimeRange(start: startDate, end: endDate);
                        setState(() {});
                      } else if (value == 1) {
                        var startDate = now
                            .subtract(Duration(days: now.weekday))
                            .subtract(Duration(days: 7));
                        startDate = DateTime(startDate.year, startDate.month,
                            startDate.day, 0, 0, 0);
                        var endDate = startDate.add(Duration(days: 7));
                        _dateTimeRange =
                            DateTimeRange(start: startDate, end: endDate);
                        setState(() {});
                      } else if (value == 2) {
                        var startDate =
                            now.subtract(Duration(days: now.day - 1));
                        startDate = DateTime(startDate.year, startDate.month,
                            startDate.day, 0, 0, 0);
                        var endDate =
                            startDate.add(Duration(days: now.day - 1));
                        _dateTimeRange =
                            DateTimeRange(start: startDate, end: endDate);
                        setState(() {});
                      } else if (value == 3) {
                        var startDate =
                            DateTime(now.year, now.month - 2, 1, 0, 0, 0);
                        var endDate =
                            DateTime(now.year, now.month - 1, 0, 0, 0, 0);
                        _dateTimeRange =
                            DateTimeRange(start: startDate, end: endDate);
                        setState(() {});
                      } else if (value == 4) {
                        await _handleDateRangePicker(context, theme);

                        setState(() {});
                      }

                      fetchData();
                    },
                  ),
                  // Text("Selected Date Range: $_dateTimeRange"),
                  Center(
                    child: Text(((startDateStr != endDateStr)
                        ? '${startDateStr} - ${endDateStr}'
                        : '$startDateStr')),
                  ),
                  SizedBox(height: 16.pw),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 4,
                        child: LabelText(label: 'Total Fees', theme: theme)),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                        flex: 5,
                        child: LabelText(
                            label: DataFormatter.chipsFormat(totalFees),
                            theme: theme)),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 4,
                        child: LabelText(label: 'Fee Credits %', theme: theme)),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            LabelText(
                                label: DataFormatter.chipsFormat(
                                        agentFeeBackPercent) +
                                    '%',
                                theme: theme),
                            SizedBox(width: 32.pw),
                            RoundRectButton(
                                text: "Change",
                                onTap: () async {
                                  int value = await SetTipsBackDialog.prompt(
                                      context: context,
                                      clubCode: widget.clubCode,
                                      playerUuid: widget.agentId,
                                      title: 'Agent Fee Credits',
                                      tipsBack: agentFeeBackPercent.toInt());
                                  if (value != null) {
                                    if (value <= 100) {
                                      agentFeeBackPercent = value.toDouble();
                                      await ClubInteriorService
                                          .updateClubMemberByParam(
                                        widget.clubCode,
                                        widget.agentId,
                                        agentFeeBack:
                                            agentFeeBackPercent.toInt(),
                                      );
                                      widget.member.agentFeeBack =
                                          agentFeeBackPercent.toInt();
                                      fetchData();
                                    }
                                  }
                                },
                                theme: theme),
                          ],
                        )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 4,
                        child: LabelText(label: 'Fee Credits', theme: theme)),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                        flex: 5,
                        child: LabelText(
                            label:
                                DataFormatter.chipsFormat(agentFeeBackAmount),
                            theme: theme)),
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 16.ph,
            ),
            Expanded(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: memberActivities.length + 1,
                itemBuilder: (context, index) {
                  // index 0 draws the header
                  if (index == 0) return _buildTableHeader(theme);
                  final memberActivity = memberActivities[index - 1];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0.pw),
                    height: 50.0.ph,
                    child: Row(
                      children: [
                        _buildTableContentChild(
                          flex: report_player_width,
                          data: memberActivity.name,
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_hands_width,
                          data: memberActivity.handsPlayed,
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_tips_width,
                          data: DataFormatter.chipsFormat(memberActivity.tips),
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_buyin_width,
                          data: DataFormatter.chipsFormat(memberActivity.buyin),
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_profit_width,
                          data:
                              DataFormatter.chipsFormat(memberActivity.profit),
                          theme: theme,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  if (index == 0)
                    return Container();
                  else
                    return Divider(color: Color(0xff707070));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(AppTheme theme) {
    return Container(
      height: 70.0.ph,
      margin: EdgeInsets.all(10.pw),
      color: theme.fillInColor,
      child: Row(
        children: [
          _buildHeaderChild(
            flex: report_player_width,
            text: 'Player',
          ),
          _buildHeaderChild(
            flex: report_hands_width,
            text: '#Hands',
          ),
          _buildHeaderChild(
            flex: report_tips_width,
            text: 'Fees',
          ),
          _buildHeaderChild(
            flex: report_buyin_width,
            text: 'Buyin',
          ),
          _buildHeaderChild(
            flex: report_profit_width,
            text: 'Profit',
          ),
        ],
      ),
    );
  }

  _handleDateRangePicker(BuildContext context, AppTheme theme) async {
    DateTime now = DateTime.now();
    // var startDate = await datePicker(
    //   minimumDate: now.subtract(Duration(days: 90)),
    //   maximumDate: now,
    //   initialDate: now.subtract(Duration(days: 7)),
    //   theme: theme,
    //   title: "Start Date",
    // );

    // if (startDate != null) {
    //   var endDate = await datePicker(
    //     minimumDate: startDate,
    //     maximumDate: now,
    //     initialDate: now.subtract(Duration(minutes: 1)),
    //     theme: theme,
    //     title: "End Date",
    //   );

    //   _dateTimeRange = DateTimeRange(
    //       start: startDate, end: (endDate != null) ? endDate : DateTime.now());
    // } else {
    //   _dateTimeRange = DateTimeRange(
    //       start: DateTime.now().subtract(Duration(days: 7)),
    //       end: DateTime.now());
    // }

    var newDateRange = await DateRangePicker.show(context,
        minimumDate: now.subtract(Duration(days: 90)),
        maximumDate: now,
        initialDate: now.subtract(Duration(days: 7)),
        title: "Custom",
        theme: theme);

    if (newDateRange != null) {
      _dateTimeRange = newDateRange;
      setState(() {});
    }
  }

  datePicker(
      {@required DateTime minimumDate,
      @required DateTime maximumDate,
      @required DateTime initialDate,
      @required String title,
      @required AppTheme theme}) async {
    log('minimum date: ${minimumDate.toIso8601String()} maximum date: ${maximumDate.toIso8601String()}');
    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        var selectedDate = initialDate;
        return Material(
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Brightness.dark,
            ),
            child: Container(
              decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.accentColor, width: 3),
              ),
              padding: EdgeInsets.all(8.pw),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppDecorators.getHeadLine2Style(
                      theme: theme,
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: initialDate,
                        minimumYear: 1,
                        maximumDate: maximumDate,
                        minimumDate: minimumDate,
                        onDateTimeChanged: (val) {
                          setState(() {
                            selectedDate = val;
                          });
                        }),
                  ),
                  RoundRectButton(
                      onTap: () {
                        Navigator.of(context).pop(selectedDate);
                      },
                      text: "OK",
                      theme: theme),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderChild({int flex = 1, String text = 'Player'}) => Expanded(
        flex: flex,
        child: Center(
          child: text.isEmpty
              ? Container()
              : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    text,
                    style: TextStyle(color: Color(0xffef9712)),
                  ),
                ),
        ),
      );

  Widget _buildTableContentChild({
    int flex = 1,
    var data,
    AppTheme theme,
  }) {
    if (data is int) {
      data = data.toDouble();
    }
    return Expanded(
      flex: flex,
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            (data is double || data is int)
                ? DataFormatter.chipsFormat(data)
                : data,
            style: TextStyle(
              color: data is double
                  ? data > 0
                      ? theme.secondaryColor
                      : theme.negativeOrErrorColor
                  : theme.supportingColor,
            ),
          ),
        ),
      ),
    );
  }
}
