import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' as rootBundle;
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';

class MockData {
  MockData._();

  static Future<List<GameModelNew>> getLiveGames() async {
    final List<GameModelNew> liveGames = [];

    try {
      final jsondata =
          await rootBundle.rootBundle.loadString("assets/json/mockdata.json");
      final List liveGames = json.decode(jsondata)["liveGames"] as List;
      return liveGames.map((e) => GameModelNew.fromJson(e)).toList();
    } catch (e) {
      log("Exception in converting to model: $e");
      return liveGames;
    }
  }

  static Future<List<ClubModel>> getClubs() async {
    final List<ClubModel> clubs = [];

    try {
      final jsondata =
          await rootBundle.rootBundle.loadString("assets/json/mockdata.json");
      final List clubs = json.decode(jsondata)["clubs"] as List;
      return clubs.map((e) => ClubModel.fromJson(e)).toList();
    } catch (e) {
      log("Exception in converting to model: $e");
      return clubs;
    }
  }

  static Future<ClubHomePageModel> getClubHomePageData(String clubCode) async {
    final jsondata =
        await rootBundle.rootBundle.loadString("assets/json/mockdata.json");
    final List clubHomePage = json.decode(jsondata)["clubHomePage"] as List;

    String weeklyData = await rootBundle.rootBundle
        .loadString("assets/sample-data/weekly-data.json");
    ClubWeeklyActivityModel weeklyActivity =
        ClubWeeklyActivityModel.fromJson(json.decode(weeklyData));

    return ClubHomePageModel.fromGQLResponse(
        clubCode, clubHomePage[0], weeklyActivity);
  }

  static Future<List<GameHistoryModel>> getGameHistory(String clubCode) async {
    final jsondata =
        await rootBundle.rootBundle.loadString("assets/json/mockdata.json");
    final List gameHistory = json.decode(jsondata)["gameHistory"] as List;

    return gameHistory
        .map<GameHistoryModel>((var item) => GameHistoryModel.fromJson(item))
        .toList();
  }

  static Future<GameHistoryDetailModel> getGameHistoryDetail(
      GameHistoryDetailModel model) async {
    final jsondata =
        await rootBundle.rootBundle.loadString("assets/json/mockdata.json");
    print("hehe");
    // instantiate game history detail object
    model.jsonData = json.decode(jsondata)["gameDetails"];
    model.load();
    return model;
  }
}
