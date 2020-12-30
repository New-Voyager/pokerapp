import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/game_timing_settings/action_time_select.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/game_timing_settings/game_length_select.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/ingame_settings/blinds_select.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/ingame_settings/buyin_ranges_select.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/ingame_settings/club_tips_select.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/ingame_settings/game_type_select.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/ingame_settings/max_player_select.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class NewGameSettings extends StatelessWidget {
  final String clubCode;
  NewGameSettings({
    @required this.clubCode,
  }) : assert(clubCode != null);

  void _joinGame(BuildContext context, String gameCode) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GamePlayScreen(
            gameCode: gameCode,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewGameModelProvider>(
      create: (_) => NewGameModelProvider(clubCode),
      builder: (BuildContext context, _) => Consumer<NewGameModelProvider>(
        builder: (_, NewGameModelProvider data, __) => Scaffold(
          backgroundColor: AppColors.screenBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.screenBackgroundColor,
            title: Text("New Game Settings"),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Consumer<NewGameModelProvider>(
              builder: (context, data, child) => Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextButton(
                          text: "Start",
                          onTap: () async {
                            String gameCode =
                                await GameService.configureClubGame(
                                    data.settings.clubCode, data.settings);
                            print('Configured game: $gameCode');

                            // join the game
                            _joinGame(context, gameCode);
                          },
                        ),
                        Container(
                          width: 120.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextButton(
                                text: "Load",
                                onTap: () {},
                              ),
                              CustomTextButton(
                                text: "Save",
                                onTap: () {},
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: firstList(context),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: secondList(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: thirdList(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget thirdList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Consumer<NewGameModelProvider>(
          builder: (context, data, child) => Column(
            children: [
              ListTile(
                title: Text(
                  "BOT players",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CupertinoSwitch(
                    value: data.botGame,
                    onChanged: (value) {
                      data.botGame = value;
                    }),
              ),
              Divider(
                color: Color(0xff707070),
              ),
              ListTile(
                title: Text(
                  "Location Check",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CupertinoSwitch(
                    value: data.locationCheck,
                    onChanged: (value) {
                      data.locationCheck = value;
                    }),
              ),
              Divider(
                color: Color(0xff707070),
              ),
              ListTile(
                title: Text(
                  "WaitList",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CupertinoSwitch(
                    value: data.waitList,
                    onChanged: (value) {
                      data.waitList = value;
                    }),
              ),
              Divider(
                color: Color(0xff707070),
              ),
              ListTile(
                title: Text(
                  "Don't Show Losing Hand",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CupertinoSwitch(
                    value: data.dontShowLosingHand,
                    onChanged: (value) {
                      data.dontShowLosingHand = value;
                    }),
              ),
              Divider(
                color: Color(0xff707070),
              ),
              ListTile(
                title: Text(
                  "Run it Twice",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CupertinoSwitch(
                    value: data.runItTwice,
                    onChanged: (value) {
                      data.runItTwice = value;
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget secondList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Consumer<NewGameModelProvider>(
          builder: (context, data, child) => Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                      'assets/images/gamesettings/clock.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xffef9712),
                ),
                title: Text(
                  "Game Length",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.selectedGameLengthText,
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: data,
                                  child: GameLengthSelect(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  color: Color(0xff707070),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset('assets/images/gamesettings/card.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xff319ffe),
                ),
                title: Text(
                  "Action Time",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.selectedActionTimeText,
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: data,
                                  child: ActionTimeSelect(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstList(context) {
    NewGameModelProvider data = Provider.of<NewGameModelProvider>(context);
    print(data);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Consumer<NewGameModelProvider>(
          builder: (context, data, child) => Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                      'assets/images/gamesettings/casino.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xff319ffe),
                ),
                title: Text(
                  data.selectedGameTypeText,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: data,
                              child: GameTypeSelect(),
                            ),
                          ));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  color: Color(0xff707070),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                      'assets/images/gamesettings/bigblind.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xffef9712),
                ),
                title: Text(
                  "Blinds",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "(SB: " +
                      data.blinds.smallBlind.toString() +
                      ", BB: " +
                      data.blinds.bigBlind.toString() +
                      ", Straddle: " +
                      data.blinds.straddle.toString() +
                      ", Ante: " +
                      data.blinds.ante.toString() +
                      ")",
                  style: TextStyle(color: Color(0xff848484), fontSize: 13.0),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.blinds.bigBlind.toString(),
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: data,
                                  child: BlindsSelect(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  color: Color(0xff707070),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                      'assets/images/gamesettings/gambling.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xfff27865),
                ),
                title: Text(
                  "Buy In",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.buyInMin.toString() + "/" + data.buyInMax.toString(),
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: data,
                                  child: BuyInRangesSelect(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  color: Color(0xff707070),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                      'assets/images/gamesettings/group.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xff3ec506),
                ),
                title: Text(
                  "Max Players",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.maxPlayers.toString(),
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: data,
                                  child: MaxPlayerSelect(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  color: Color(0xff707070),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                    'assets/images/gamesettings/coin-stack.svg',
                    color: Colors.white,
                    height: 25.0,
                    width: 25.0,
                  ),
                  backgroundColor: Color(0xff15dcc1),
                ),
                title: Text(
                  "Club Tips",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.rakePercentage.toString() +
                          "% or " +
                          data.rakeCap.toString() +
                          " cap",
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: data,
                                  child: ClubTipsSelect(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  color: Color(0xff707070),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset('assets/images/gamesettings/coin.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xffef1212),
                ),
                title: Text(
                  "Straddle(UTG)",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CupertinoSwitch(
                    value: data.straddleAllowed,
                    onChanged: (value) {
                      data.straddleAllowed = value;
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
