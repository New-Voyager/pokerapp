import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/models/rewards_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen.dart';
import 'package:pokerapp/services/app/rewards_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

import 'game_timing_settings/action_time_select.dart';
import 'game_timing_settings/game_length_select.dart';
import 'ingame_settings/blinds_select.dart';
import 'ingame_settings/buyin_ranges_select.dart';
import 'ingame_settings/club_tips_select.dart';
import 'ingame_settings/game_type_select.dart';
import 'ingame_settings/max_player_select.dart';
import 'ingame_settings/rewards_list.dart';

class NewGameSettings extends StatefulWidget {
  final String clubCode;
  NewGameSettings(this.clubCode);

  @override
  _NewGameSettingsState createState() =>
      _NewGameSettingsState(clubCode: clubCode);
}

class _NewGameSettingsState extends State<NewGameSettings> {
  final String clubCode;
  List<Rewards> rewards = new List<Rewards>();
  _NewGameSettingsState({
    @required this.clubCode,
  }) : assert(clubCode != null);

  bool loadingDone = false;

  _fetchData() async {
    this.rewards = await RewardService.getRewards(this.clubCode);
    if (this.rewards != null && this.rewards.length > 0) {
      this.rewards.insert(0, Rewards(id: 0, name: 'None'));
    }
    loadingDone = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _showError(
      BuildContext context, String title, String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            CustomTextButton(
              text: 'OK',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _joinGame(BuildContext context, String gameCode) =>
      navigatorKey.currentState.push(
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
          body: !loadingDone
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Consumer<NewGameModelProvider>(
                      builder: (context, data, child) {
                    data.rewards = this.rewards;
                    return Column(
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
                                          data.settings.clubCode,
                                          data.settings);
                                  print('Configured game: $gameCode');
                                  if (gameCode != null) {
                                    // join the game
                                    _joinGame(context, gameCode);
                                  } else {
                                    _showError(context, 'Error',
                                        'Creating game failed');
                                  }
                                },
                              ),
                              Container(
                                width: 120.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: firstList(context),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        (this.rewards != null && this.rewards.length > 0)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: rewardTile(),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: secondList(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: thirdList(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    );
                  }),
                ),
        ),
      ),
    );
  }

  Widget rewardTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Consumer<NewGameModelProvider>(
        builder: (context, data, child) => ListTile(
          leading: CircleAvatar(
            child: SvgPicture.asset('assets/images/gamesettings/clock.svg',
                color: Colors.white),
            backgroundColor: Color(0xffef9712),
          ),
          title: Text(
            "Rewards",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            data.selectedReward == -1
                ? 'None'
                : data.rewards[data.selectedReward].name,
            style: TextStyle(color: Color(0xff848484)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "",
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
                        MaterialPageRoute(
                            builder: (context) => data.rewards == null
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : ChangeNotifierProvider.value(
                                    value: data, child: RewardsList())));
                  }),
            ],
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
