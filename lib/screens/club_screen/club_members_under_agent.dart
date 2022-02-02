import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
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
    return Expanded(
      child: ListView.builder(
          itemCount: players.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            ClubMemberModel member = players[index];
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
                            // selectedPlayers = [];
                            // selectedPlayers.addAll(allPlayers
                            //     .where((element) => (element.selected)));

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
