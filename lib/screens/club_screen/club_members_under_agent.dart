import 'package:flutter/material.dart';
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
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/utils.dart';
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

    if (widget.member.isAgent) {
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
    DateTime now = DateTime.now();
    DateTime nowAdjust = DateTime(now.year, now.month, now.day);
    DateTime start = findFirstDateOfTheWeek(nowAdjust).toUtc();
    DateTime end = findLastDateOfTheWeek(nowAdjust).toUtc();

    // last week
    // this month
    // last month
    // custom date

    // load here
    final activities = await ClubInteriorService.getAgentPlayerActivities(
        widget.clubCode, widget.agentId, start, end);
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.getTheme(context);

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
                      'This Week',
                      'Last Week',
                      'This Month',
                      'Last Month',
                      'Custom',
                      // 'Last Week',
                      // 'Last Month'
                    ],
                    onSelect: (int value) async {
                      final now = DateTime.now();
                      _selectedReportDateRangeIndex = value;
                      if (value == 0) {
                        setState(() {});
                      } else if (value == 1) {
                        setState(() {});
                      } else if (value == 2) {
                        setState(() {});
                      } else if (value == 3) {
                        setState(() {});
                      } else if (value == 4) {
                        await _handleDateRangePicker(context, theme);

                        setState(() {});
                      }
                    },
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
    final dateRange = await showDateRangePicker(
      initialDateRange: _dateTimeRange,
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 3650)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: theme.primaryColor,
            accentColor: theme.accentColor,
            colorScheme: ColorScheme.light(primary: theme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (dateRange != null) {
      _dateTimeRange = dateRange;
    }
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
