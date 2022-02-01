import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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
  List<Player> players = [];
  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    populateDummyPlayers();
  }

  populateDummyPlayers() {
    players.add(Player(id: 0, name: "Young"));
    players.add(Player(id: 0, name: "Raja"));
    players.add(Player(id: 0, name: "Bill"));
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
              Container(
                height: 300,
                padding: EdgeInsets.only(top: 16.ph),
                color: Colors.transparent,
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
        floatingActionButton: (_selectedTabIndex == 0)
            ? FloatingActionButton(
                backgroundColor: theme.accentColor,
                onPressed: () async {},
                child: Icon(
                  Icons.add,
                  color: theme.primaryColorWithDark(),
                ),
              )
            : null,
      ),
    );
  }

  Widget playersTab(AppTheme theme) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.pw),
        itemCount: players.length,
        itemBuilder: (context, index) {
          Player player = players[index];
          return Container(
            margin: EdgeInsets.only(
              bottom: 10.ph,
            ),
            child: Row(
              children: [
                Expanded(child: Text(player.name)),
                InkWell(
                  onTap: () {
                    setState(() {
                      players.removeAt(index);
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 25.ph,
                        width: 25.pw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.pw),
                          color: Colors.grey.shade200,
                        ),
                      ),
                      Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget reportTab(AppTheme theme) {
    return Container();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class Player {
  int id;
  String name;

  Player({@required this.id, @required this.name});
}
