import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/switch.dart';

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
    return Container();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void exitPlayersEditMode() {
    playersEditMode = false;
    searchTextController.text = "";
  }
}

class Player {
  int id;
  String name;
  bool selected;

  Player({@required this.id, @required this.name, this.selected = false});
}
