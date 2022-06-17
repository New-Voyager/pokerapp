import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/tournament/tournament.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/tournament_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';

class TournamentsScreen extends StatefulWidget {
  TournamentsScreen({Key key}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  List<TournamentListItem> tournaments = [];
  bool loading = true;
  TextEditingController _tableNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    TournamentService.getTournamentList().then((value) {
      tournaments = value;
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(builder: (_, theme, __) {
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
                : ListView.builder(
                    itemCount: tournaments.length,
                    itemBuilder: (context, index) {
                      TournamentListItem tournament = tournaments[index];
                      return _buildItem(tournament, theme);
                    },
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildItem(TournamentListItem tournament, AppTheme theme) {
    List<Widget> options = [];
    if (tournament.status == TournamentStatus.SCHEDULED) {
      options.add(_buildRegisteringOptions(theme, tournament));
      options.add(SizedBox(height: 5));
      if (tournament.fillWithBots) {
        options.add(_buildFillBotsOption(theme, tournament));
        options.add(SizedBox(height: 5));
      }
    } else if (tournament.status == TournamentStatus.RUNNING) {
      options.add(_buildRunningOptions(theme, tournament));
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
                        tournament.registeredPlayersCount.toString()),
                    Text("Status " + tournament.status.name),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: options,
                  ))
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildRegisteringOptions(
      AppTheme theme, TournamentListItem tournament) {
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

  Widget _buildFillBotsOption(AppTheme theme, TournamentListItem tournament) {
    return Column(
      children: [
        RoundRectButton(
          onTap: () async {},
          text: 'Register Bots',
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildRunningOptions(AppTheme theme, TournamentListItem tournament) {
    return Column(children: [
      RoundRectButton(
        onTap: () async {},
        text: 'Join',
        theme: theme,
      ),
      SizedBox(
        height: 8.ph,
      ),
      SizedBox(height: 8),
      RoundRectButton(
        onTap: () async {
          int tableNo = await TournamentTableNoView.show(
            context,
          );
          if (tableNo != null) {
            // get game info for the tournament and join the game
            final gameInfo = await TournamentService.getTournamentTableInfo(
                tournament.tournamentId, tableNo);

            // get game code and naviagte to game screen
            Navigator.of(context)
                .pushNamed(Routes.game_play, arguments: gameInfo.gameCode);
          }
        },
        text: 'Observe',
        theme: theme,
      )
    ]);
  }
}

class TableNoInput extends StatefulWidget {
  @override
  State<TableNoInput> createState() => _TableNoInputState();
}

class _TableNoInputState extends State<TableNoInput> {
  TextEditingController _tableNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _tableNoController,
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class TournamentTableNoView extends StatefulWidget {
  static Future<int> show(
    BuildContext context,
  ) async {
    int tournamentId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: TournamentTableNoView(),
      ),
    );
    return tournamentId;
  }

  TournamentTableNoView();

  static const sepV20 = const SizedBox(height: 20.0);
  static const sepV8 = const SizedBox(height: 8.0);
  static const sep12 = const SizedBox(height: 12.0);

  static const sepH10 = const SizedBox(width: 10.0);

  @override
  State<TournamentTableNoView> createState() => _TournamentTableNoViewState();
}

class _TournamentTableNoViewState extends State<TournamentTableNoView> {
  bool loading = false;

  TextEditingController _tecTableNo = TextEditingController();
  @override
  void initState() {
    loading = true;
    _tecTableNo.text = "1";
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    if (loading) {
      return Container();
    }

    return Container(
      // decoration: AppDecorators.bgRadialGradient(theme).copyWith(
      //   border: Border.all(
      //     color: theme.secondaryColorWithDark(),
      //     width: 2,
      //   ),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      constraints: BoxConstraints(maxWidth: AppDimensionsNew.maxWidth),
      decoration: BoxDecoration(color: theme.secondaryColorWithDark(0.40)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              HeadingWidget(
                heading: "Tournament Table No",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleImageButton(
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                  theme: theme,
                  icon: Icons.close,
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: Scrollbar(
                thickness: PlatformUtils.isWeb ? 5 : 1,
                thumbVisibility: true,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(right: 10),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Name', theme: theme),
                        SizedBox(height: 8),
                        CardFormTextField(
                          hintText: "",
                          controller: _tecTableNo,
                          maxLines: 1,
                          theme: theme,
                        ),
                      ],
                    ),
                    ButtonWidget(
                      text: "Go",
                      onTap: () async {
                        int tableNo = int.tryParse(_tecTableNo.text);
                        Navigator.pop(context, tableNo);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeperator(AppTheme theme) => Container(
        color: theme.fillInColor,
        width: double.infinity,
        height: 1.0,
      );
}
