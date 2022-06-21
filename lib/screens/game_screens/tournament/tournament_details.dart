import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/tournament/tournament.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/tournament_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
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
    _controller = new TabController(length: 2, vsync: this);
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
                titleText: "Tournaments",
              ),
              body: loading
                  ? CircularProgressWidget(text: 'Loading...')
                  : Column(children: [
                      Text('Registered Players: ' +
                          tournamentData.registeredPlayers.length.toString()),
                      startButton,
                      TabBar(controller: _controller, tabs: [
                        Tab(
                          text: 'Players',
                        ),
                        Tab(
                          text: 'Tables',
                        ),
                      ]),
                      Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          controller: _controller,
                          children: tabViews,
                        ),
                      ),
                    ])),
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
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.data.registeredPlayers.length,
      itemBuilder: (context, index) {
        final player = widget.data.registeredPlayers[index];
        return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(player.playerName), Text(player.status.toJson())],
            ));
      },
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
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.data.tables.length,
      itemBuilder: (context, index) {
        final table = widget.data.tables[index];
        final playersCount = table.players.length;
        return InkWell(
          onTap: () {
            String gameCode = 't-${widget.tournamentId}-${table.tableNo}';
            // go to game screen from here
            Navigator.of(context).pushNamed(
              Routes.game_play,
              arguments: {
                'gameCode': gameCode,
              },
            );
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
    );
  }
}
