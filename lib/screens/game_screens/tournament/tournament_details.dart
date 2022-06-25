import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/tournament/tournament.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/tournament_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/web-routes.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

class TournamentsDetailsScreen extends StatefulWidget {
  final int tournamentId;
  TournamentsDetailsScreen({Key key, this.tournamentId}) : super(key: key);

  @override
  State<TournamentsDetailsScreen> createState() =>
      _TournamentsDetailsScreenState();
}

class _TournamentsDetailsScreenState extends State<TournamentsDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<TournamentListItem> tournaments = [];
  bool loading = true;
  Tournament tournamentData;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getTournmentInfo();
    });
  }

  _getTournmentInfo() {
    TournamentService.getTournamentInfo(widget.tournamentId).then((value) {
      loading = false;
      tournamentData = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(builder: (_, theme, __) {
      if (loading) {
        return CircularProgressWidget(text: 'Loading...');
      }
      List<Widget> tabViews = [];
      final playersView = TournamentPlayersView(
          tournamentId: widget.tournamentId, data: this.tournamentData);
      final tablesView = TournamentTablesView(
          tournamentId: widget.tournamentId, data: this.tournamentData);
      tabViews.add(playersView);
      tabViews.add(tablesView);
      Widget startButton = Container();
      if (tournamentData.status == TournamentStatus.SCHEDULED) {
        startButton = RoundRectButton(
          onTap: () async {
            final loadingDialog = LoadingDialog();
            loadingDialog.show(
                context: context, loadingText: 'Starting tournament');
            await TournamentService.triggerAboutToStartTournament(
                widget.tournamentId);
            await TournamentService.kickoffTournament(widget.tournamentId);
            loadingDialog.dismiss(context: context);
            _getTournmentInfo();
          },
          text: 'Start',
          theme: theme,
        );
      }

      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              theme: theme,
              context: context,
              titleText:
                  tournamentData == null ? "Tournament" : tournamentData.name,
              showBackButton: !PlatformUtils.isWeb,
            ),
            body: loading
                ? CircularProgressWidget(text: 'Loading...')
                : Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: AppDecorators.tileDecoration(theme),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Registered',
                                      style: AppDecorators.getSubtitle1Style(
                                        theme: theme,
                                      ),
                                    ),
                                    Text(
                                      tournamentData.registeredPlayers.length
                                          .toString(),
                                      style: AppDecorators.getSubtitle2Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Tournment Players',
                                      style: AppDecorators.getSubtitle1Style(
                                        theme: theme,
                                      ),
                                    ),
                                    Text(
                                      "${tournamentData.tournamentPlayers?.length ?? 0}",
                                      style: AppDecorators.getSubtitle2Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Players (Min - Max)',
                                      style: AppDecorators.getSubtitle1Style(
                                        theme: theme,
                                      ),
                                    ),
                                    Text(
                                      "${tournamentData.minPlayers ?? 0} - ${tournamentData.maxPlayers ?? 0}",
                                      style: AppDecorators.getSubtitle2Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Max players / Table',
                                      style: AppDecorators.getSubtitle1Style(
                                        theme: theme,
                                      ),
                                    ),
                                    Text(
                                      "${tournamentData.maxPlayersInTable}",
                                      style: AppDecorators.getSubtitle2Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status'),
                                    Text(
                                      "${tournamentData.status}",
                                      style: AppDecorators.getSubtitle2Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            startButton,
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.transparent,
                      ),
                      TabBar(
                        controller: _controller,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: AppColorsNew.yellowAccentColor,
                        labelColor: AppColorsNew.newActiveBoxColor,
                        unselectedLabelColor: AppColorsNew.labelColor,
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Players")
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.table_bar),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Tables")
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TabBarView(
                            physics: BouncingScrollPhysics(),
                            controller: _controller,
                            children: tabViews,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}

class TournamentPlayersView extends StatefulWidget {
  final int tournamentId;
  final Tournament data;
  TournamentPlayersView({Key key, this.tournamentId, this.data})
      : super(key: key);

  @override
  State<TournamentPlayersView> createState() => _TournamentPlayersViewState();
}

class _TournamentPlayersViewState extends State<TournamentPlayersView> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return widget.data.registeredPlayers.isNotEmpty
        ? ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 4,
              );
            },
            physics: BouncingScrollPhysics(),
            itemCount: widget.data.registeredPlayers.length,
            itemBuilder: (context, index) {
              final player = widget.data.registeredPlayers[index];
              return Container(
                  padding: EdgeInsets.all(10),
                  decoration: AppDecorators.tileDecorationWithoutBorder(theme),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(player.playerName),
                      Text(player.status.toJson())
                    ],
                  ));
            },
          )
        : Center(
            child: Center(
              child: Text("No Players"),
            ),
          );
  }
}

class TournamentTablesView extends StatefulWidget {
  final int tournamentId;
  final Tournament data;
  TournamentTablesView({Key key, this.tournamentId, this.data})
      : super(key: key);

  @override
  State<TournamentTablesView> createState() => _TournamentTablesViewState();
}

class _TournamentTablesViewState extends State<TournamentTablesView> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return widget.data.tables.isNotEmpty
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.data.tables.length,
            itemBuilder: (context, index) {
              final table = widget.data.tables[index];
              final playersCount = table.players.length;
              return InkWell(
                onTap: () {
                  String gameCode = 't-${widget.tournamentId}-${table.tableNo}';
                  log('gameCode: $gameCode');

                  if (PlatformUtils.isWeb) {
                    // go to game screen from here
                    Navigator.of(context).pushNamed(
                      WebRoutes.game_play,
                      arguments: {
                        'gameCode': gameCode,
                      },
                    );
                  } else {
                    // go to game screen from here
                    Navigator.of(context).pushNamed(
                      Routes.game_play,
                      arguments: {
                        'gameCode': gameCode,
                      },
                    );
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Table ${table.tableNo}'),
                        Text(playersCount.toString())
                      ],
                    )),
              );
            },
          )
        : Center(
            child: Text(
              "No Tables!",
              style: AppDecorators.getLabelTextStyle(theme),
            ),
          );
  }
}
