import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
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
  List<Player> allPlayers = [];
  List<Player> selectedPlayers = [];
  List<Player> searchPlayers = [];

  bool playersEditMode = false;
  TextEditingController searchTextController = TextEditingController();

  int report_player_width = 2;
  int report_hands_width = 2;
  int report_tips_width = 2;
  int report_buyin_width = 2;
  int report_profit_width = 2;

  int _selectedReportDateRangeIndex = 0;

  DateTimeRange _dateTimeRange;

  @override
  void initState() {
    super.initState();
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

    populateDummyPlayers();
  }

  populateDummyPlayers() {
    allPlayers.add(Player(id: 1, name: "Young"));
    allPlayers.add(Player(id: 2, name: "Raja"));
    allPlayers.add(Player(id: 3, name: "Bill"));
    allPlayers.add(Player(id: 4, name: "Sheldon"));
    allPlayers.add(Player(id: 5, name: "Raj"));

    searchPlayers = allPlayers;
  }

  @override
  Widget build(BuildContext context) {
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
                    reportTab(theme),
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

  Widget playersTab(AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
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
          SizedBox(height: 16.ph),
          Expanded(
            child: ListView.builder(
                itemCount: (!playersEditMode)
                    ? selectedPlayers.length
                    : searchPlayers.length,
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  Player player = (!playersEditMode)
                      ? selectedPlayers[index]
                      : searchPlayers[index];
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 10.ph,
                    ),
                    child: SwitchWidget2(
                      value: player.selected,
                      onChange: (bool b) {
                        Player selectedPlayer = allPlayers
                            .firstWhere((element) => (element.id == player.id));
                        selectedPlayer.selected = b;
                      },
                      label: player.name,
                      visibleSwitch: playersEditMode,
                    ),
                  );
                }),
          ),
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
                            selectedPlayers = [];
                            selectedPlayers.addAll(allPlayers
                                .where((element) => (element.selected)));
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

  Widget reportTab(AppTheme theme) {
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
                        child: LabelText(label: 'Minimum Rank', theme: theme)),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                        flex: 5,
                        child: LabelText(label: '340.30', theme: theme)),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 4,
                        child: LabelText(label: 'Credit back %', theme: theme)),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            LabelText(label: '30', theme: theme),
                            SizedBox(width: 32.pw),
                            RoundRectButton(
                                text: "Change", onTap: () {}, theme: theme),
                          ],
                        )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 4,
                        child: LabelText(label: 'Credit back', theme: theme)),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                        flex: 5,
                        child: LabelText(label: '100.60', theme: theme)),
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
                itemCount: 20,
                itemBuilder: (context, index) {
                  // index 0 draws the header
                  if (index == 0) return _buildTableHeader(theme);

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0.pw),
                    height: 50.0.ph,
                    child: Row(
                      children: [
                        _buildTableContentChild(
                          flex: report_player_width,
                          data: "Young",
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_hands_width,
                          data: "124",
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_tips_width,
                          data: "65.30",
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_buyin_width,
                          data: "1345.20",
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: report_profit_width,
                          data: "-543.23",
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

  Widget _buildTableContentChild({
    int flex = 1,
    var data,
    AppTheme theme,
  }) =>
      Expanded(
        flex: flex,
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              data is double ? DataFormatter.chipsFormat(data) : data,
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

  Widget _buildTableHeader(AppTheme theme) => Container(
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
              text: 'Tips',
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

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void exitPlayersEditMode() {
    playersEditMode = false;
    searchTextController.text = "";
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
}

class Player {
  int id;
  String name;
  bool selected;

  Player({@required this.id, @required this.name, this.selected = false});
}
