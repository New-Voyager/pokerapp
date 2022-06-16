import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/tournament/tournament.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

class TournamentsScreen extends StatefulWidget {
  TournamentsScreen({Key key}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  List<Tournament> tournaments = [];

  @override
  void initState() {
    super.initState();
    tournaments.add(
      Tournament(
        name: "Monday Night Brawl",
        gameType: GameType.PLO,
        maxPlayers: 10,
        testWithBots: false,
        status: TournamentStatus.REGISTERING,
      ),
    );
    tournaments.add(
      Tournament(
        name: "Monday Night Brawl",
        gameType: GameType.PLO,
        maxPlayers: 10,
        testWithBots: false,
        status: TournamentStatus.RUNNING,
      ),
    );
    tournaments.add(
      Tournament(
        name: "Monday Night Brawl",
        gameType: GameType.PLO,
        maxPlayers: 10,
        testWithBots: false,
        status: TournamentStatus.RUNNING,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => WillPopScope(
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
            body: ListView.builder(
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                Tournament tournament = tournaments[index];
                return _buildItem(tournament, theme);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Tournament tournament, AppTheme theme) {
    Widget options;
    if (tournament.status == TournamentStatus.REGISTERING) {
      options = _buildRegisteringOptions(theme);
    } else if (tournament.status == TournamentStatus.RUNNING) {
      options = _buildRunningOptions(theme);
    }

    return Container(
      decoration: AppDecorators.getGameItemDecoration(theme: theme),
      margin: EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
      ),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter:
                ColorFilter.mode(theme.gameListShadeColor, BlendMode.srcATop),
            child: Image(
              image: AssetImage(
                AppAssetsNew.pathLiveGameItemBackground,
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tournament.name),
                    Text("Registered " +
                        tournament.registeredPlayers.toString()),
                    Text("Status " + tournament.status.name),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: options,
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildRegisteringOptions(AppTheme theme) {
    return Column(
      children: [
        RoundRectButton(
          onTap: () async {},
          text: 'Register',
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildRunningOptions(AppTheme theme) {
    return Column(
      children: [
        RoundRectButton(
          onTap: () async {},
          text: 'Join',
          theme: theme,
        ),
        SizedBox(
          height: 8.ph,
        ),
        RoundRectButton(
          onTap: () async {},
          text: 'Observe',
          theme: theme,
        ),
      ],
    );
  }
}
