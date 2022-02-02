import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
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
  List<ClubMemberModel> searchPlayers = [];
  List<ClubMemberModel> playersUnderMe = [];
  List<ClubMemberModel> playersUnderNoAgents = [];
  List<ClubMemberModel> allPlayers = [];
  bool loading = true;

  bool playersEditMode = false;
  TextEditingController searchTextController = TextEditingController();

  void initialize() async {
    final clubMembers =
        await appState.cacheService.getMembers(widget.member.clubCode);

    allPlayers = clubMembers;
    for (final member in clubMembers) {
      if (member.playerId == widget.member.playerId) {
        break;
      }
    }

    if (widget.member.isAgent) {
      for (final member in clubMembers) {
        if (member.agentUuid == widget.member.playerId) {
          playersUnderMe.add(member);
        } else {
          if (member.agentUuid == null || member.agentUuid == '') {
            playersUnderNoAgents.add(member);
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
        searchPlayers = playersUnderNoAgents
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

  Widget playerUnderMeList(AppTheme theme) {
    return ListView.builder(
        itemCount:
            (!playersEditMode) ? playersUnderMe.length : searchPlayers.length,
        shrinkWrap: false,
        itemBuilder: (context, index) {
          ClubMemberModel member =
              (!playersEditMode) ? playersUnderMe[index] : searchPlayers[index];
          return Container(
            margin: EdgeInsets.only(
              bottom: 10.ph,
            ),
            child: LabelText(label: member.name, theme: theme),
          );
        });
  }

  Widget nonAgentPlayers(AppTheme theme) {
    List<ClubMemberModel> players = playersUnderNoAgents;
    if (searchPlayers.length > 0) {
      players = searchPlayers;
    }
    return ListView.builder(
        itemCount: players.length,
        shrinkWrap: false,
        itemBuilder: (context, index) {
          ClubMemberModel member = players[index];
          return Container(
            margin: EdgeInsets.only(
              bottom: 10.ph,
            ),
            child: LabelText(label: member.name, theme: theme),
          );
        });
  }

  Widget playersTab(AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          !playersEditMode ? playerUnderMeList(theme) : Container(),

          // playersEditMode
          //     ? Padding(
          //         padding: EdgeInsets.only(top: 16.ph),
          //         child: TextField(
          //           controller: searchTextController,
          //           style: AppDecorators.getSubtitle1Style(theme: theme),
          //           decoration: InputDecoration(
          //             hintText: 'Search',
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(5.0),
          //                 borderSide: BorderSide(color: theme.accentColor)),
          //             focusedBorder: new OutlineInputBorder(
          //               borderRadius: new BorderRadius.circular(10.0),
          //               borderSide: BorderSide(color: theme.accentColor),
          //             ),
          //             prefixIcon: Icon(Icons.search, color: theme.accentColor),
          //           ),
          //         ),
          //       )
          //     : SizedBox.shrink(),
          // SizedBox(height: 8.ph),
          // playersEditMode ? nonAgentPlayers(theme) : Container(),
          // playersEditMode
          //     ? Column(
          //         children: [
          //           Divider(
          //             color: Colors.white,
          //             height: 30,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               RoundRectButton(
          //                 onTap: () async {
          //                   // selectedPlayers = [];
          //                   // selectedPlayers.addAll(allPlayers
          //                   //     .where((element) => (element.selected)));
          //                   // setState(() {
          //                   //   exitPlayersEditMode();
          //                   // });
          //                 },
          //                 text: 'Apply', //_appScreenText['hostGame'],
          //                 theme: theme,
          //               ),
          //               SizedBox(width: 60.pw),
          //               RoundRectButton(
          //                 onTap: () async {
          //                   setState(() {
          //                     exitPlayersEditMode();
          //                   });
          //                 },
          //                 text: 'Cancel', //_appScreenText['hostGame'],
          //                 theme: theme,
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: 30.ph,
          //           ),
          //         ],
          //       )
          //     : SizedBox.shrink(),
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
