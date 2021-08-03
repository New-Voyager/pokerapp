import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BotScriptsScreen extends StatefulWidget {
  final ClubHomePageModel clubModel;

  BotScriptsScreen({this.clubModel});
  @override
  _BotScriptsScreenState createState() => _BotScriptsScreenState();
}

class _BotScriptsScreenState extends State<BotScriptsScreen>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.bot_scripts;
  ScriptsModel scripts;
  List<String> oldLiveGames = [];
  List<String> newLiveGames = [];
  int retryCount = 0;
  String botRunnerHost;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getBotScripts();
    });

    super.initState();
  }

  getBotScripts() async {
    final prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString(AppConstants.API_SERVER_URL);
    final url = Uri.parse(apiUrl);
    botRunnerHost = url.host;
    var result = await http.get("http://$botRunnerHost:8081/app-games");
    log("URL : ${result.request.url}");
    if (result.statusCode != 200) {
      toast("Failed to get Results : ${result.reasonPhrase}");
    } else {
      log("RESULTS : ${jsonDecode(result.body)}");
      scripts = ScriptsModel.fromJson(jsonDecode(result.body));
      setState(() {});
    }
  }

  Widget getScript(Script script, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          gradient: AppStylesNew.handlogGreyGradient,
          borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          "${script.appGame}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "${script.scriptFile}",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.play_circle_fill,
            color: AppColorsNew.appAccentColor,
          ),
          onPressed: () => _handlePlay(script, context),
        ),
      ),
    );
  }

  _handlePlay(Script script, BuildContext context) async {
    ConnectionDialog.show(context: context, loadingText: "Launching Game..");
    await launchScript(script);
  }

  launchScript(Script script) async {
    retryCount = 0;
    oldLiveGames.clear();
    ClubHomePageModel model =
        await ClubsService.getClubHomePageData(widget.clubModel.clubCode);
    for (final game in model.liveGames) {
      oldLiveGames.add(game.gameCode);
    }
    var result = await http.post(
      "http://$botRunnerHost:8081/start-app-game",
      body: jsonEncode(<String, dynamic>{
        "clubCode": widget.clubModel.clubCode,
        "name": script.appGame,
        //"moveHandConfirm": true,
      }),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    );
    if (result.statusCode != 200) {
      toast("Failed to start");
    } else if (jsonDecode(result.body)['status'] == "Accepted") {
      await handleLoop(context);
    }
  }

  handleLoop(BuildContext context) async {
    int retryCount = 60;

    String newGameCode = "";
    while (retryCount > 0) {
      ClubHomePageModel model1 =
          await ClubsService.getClubHomePageData(widget.clubModel.clubCode);
      newLiveGames.clear();
      for (final game in model1.liveGames) {
        newLiveGames.add(game.gameCode);
      }

      for (final gameCode in newLiveGames) {
        int index = oldLiveGames.indexOf(gameCode);
        if (index == -1) {
          // new game
          newGameCode = gameCode;
          break;
        }
      }
      if (newGameCode.isNotEmpty) {
        break;
      }
      await Future.delayed(Duration(seconds: 1));
      retryCount--;
    }
    // dismiss launch dialog
    Navigator.pop(context);

    if (newGameCode.isNotEmpty) {
      log('New gamecode: $newGameCode');
      Navigator.pushNamed(
        context,
        Routes.game_play,
        arguments: newGameCode,
      );
    } else {
      showAlertDialog(context, "Timeout", "Failed to start Game");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColorsNew.screenBackgroundColor,
      appBar: AppBar(
        title: Text("Bot scripts", style: AppStylesNew.titleBarTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: AppColorsNew.appAccentColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: scripts == null
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemBuilder: (context, index) {
                return getScript(scripts.scripts[index], context);
              },
              separatorBuilder: (context, index) => Divider(
                color: AppColorsNew.veryLightGrayColor,
                indent: 32,
                endIndent: 32,
              ),
              itemCount: scripts.scripts.length,
            ),
    ));
  }
}

// Model code

ScriptsModel scriptsModelFromJson(String str) =>
    ScriptsModel.fromJson(json.decode(str));

String scriptsModelToJson(ScriptsModel data) => json.encode(data.toJson());

class ScriptsModel {
  ScriptsModel({
    this.scripts,
  });

  List<Script> scripts;

  factory ScriptsModel.fromJson(Map<String, dynamic> json) => ScriptsModel(
        scripts:
            List<Script>.from(json["scripts"].map((x) => Script.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scripts": List<dynamic>.from(scripts.map((x) => x.toJson())),
      };
}

class Script {
  Script({
    this.appGame,
    this.scriptFile,
  });

  String appGame;
  String scriptFile;

  factory Script.fromJson(Map<String, dynamic> json) => Script(
        appGame: json["AppGame"],
        scriptFile: json["ScriptFile"],
      );

  Map<String, dynamic> toJson() => {
        "AppGame": appGame,
        "ScriptFile": scriptFile,
      };
}
