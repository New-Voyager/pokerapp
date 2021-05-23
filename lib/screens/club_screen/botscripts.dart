import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main2.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/app_apis.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BotScriptsScreen extends StatefulWidget {
  final ClubHomePageModel clubModel;

  BotScriptsScreen({this.clubModel});
  @override
  _BotScriptsScreenState createState() => _BotScriptsScreenState();
}

class _BotScriptsScreenState extends State<BotScriptsScreen> {
  ScriptsModel scripts;
  List<GameModel> oldLiveGames = [];
  List<GameModel> newLiveGames = [];
  int retryCount = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getBotScripts();
    });
    super.initState();
  }

  getBotScripts() async {
    var result = await http.get("http://143.110.253.94:8081/app-games");
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
          gradient: AppStyles.handlogGreyGradient,
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
            Icons.play_circle,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => _handlePlay(script, context),
        ),
      ),
    );
  }

  _handlePlay(Script script, BuildContext context) async {
    ConnectionDialog.show(context: context, loadingText: "Launching Game..");
    String gameCode = "";
    await launchScript(script);
  }

  launchScript(Script script) async {
    retryCount = 0;
    oldLiveGames.clear();
    ClubHomePageModel model =
        await ClubsService.getClubHomePageData(widget.clubModel.clubCode);
    oldLiveGames.addAll(model.liveGames);
    log("OLD GAMES : LENGTH : ${oldLiveGames.length}");

    log("clubhcode : ${widget.clubModel.clubCode}");
    var result = await http.post(
      "http://143.110.253.94:8081/start-app-game",
      body: jsonEncode(<String, dynamic>{
        "clubCode": widget.clubModel.clubCode,
        "name": script.appGame
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
    ClubHomePageModel model1 =
        await ClubsService.getClubHomePageData(widget.clubModel.clubCode);
    newLiveGames.addAll(model1.liveGames);

    Future.delayed(Duration(seconds: 1), () async {
      log("Retrying in Future : $retryCount : newLength : ${newLiveGames.length}");
      if (retryCount > 30) {
        ConnectionDialog.dismiss(context: context);
        showAlertDialog(context, "Timeout", "Failed to start Game");
      } else if (newLiveGames.length > oldLiveGames.length) {
        ConnectionDialog.dismiss(context: context);
        toast("Botgame success!");
        String gameCode = "";
        for (GameModel game in newLiveGames) {
          final res =
              oldLiveGames.indexWhere((old) => game.gameCode == old.gameCode);
          if (res == -1) {
            log("Newgamecode");
            gameCode = game.gameCode;
            break;
          }
        }
        log("GAMECODE : $gameCode");

        if (gameCode.isNotEmpty) {
          Navigator.pushNamed(
            context,
            Routes.game_play,
            arguments: gameCode,
          );
        }
      } else {
        handleLoop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("Bot scripts", style: AppStyles.titleBarTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: AppColors.appAccentColor,
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
                color: AppColors.veryLightGrayColor,
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
