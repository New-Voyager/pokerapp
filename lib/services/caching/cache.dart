import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';

class CacheService {
  Map<String, List<ClubMemberModel>> clubMembersMap =
      Map<String, List<ClubMemberModel>>();
  List<ClubModel> myClubs;
  List<GameModelNew> liveGames;
  Map<String, ClubHomePageModel> clubDetailsMap =
      Map<String, ClubHomePageModel>();
  /** 
   * Return club members from the cache. If update is set to true, fetch from server, cache it.
   */
  Future<List<ClubMemberModel>> getMembers(String clubCode,
      {bool update = false}) async {
    if (clubMembersMap[clubCode] == null) {
      update = true;
    }
    if (update) {
      final clubMembers = await ClubInteriorService.getClubMembers(
          clubCode, MemberListOptions.ALL);
      clubMembersMap[clubCode] = clubMembers;
    }
    return clubMembersMap[clubCode];
  }

  /** 
   * Return club home page data
   */
  Future<ClubHomePageModel> getClubHomePageData(String clubCode,
      {bool update = false}) async {
    if (clubDetailsMap[clubCode] == null) {
      update = true;
    }
    if (update) {
      final clubHomePage = await ClubsService.getClubHomePageData(clubCode);
      clubDetailsMap[clubCode] = clubHomePage;
    }
    return clubDetailsMap[clubCode];
  }

  Future<List<ClubModel>> getMyClubs({bool update = false}) async {
    if (myClubs == null) {
      update = true;
    }
    if (update) {
      myClubs = await ClubsService.getMyClubs();
    }
    return myClubs;
  }

  Future<List<GameModelNew>> getPlayerLiveGames({bool update = false}) async {
    if (liveGames == null) {
      update = true;
    }
    if (update) {
      liveGames = await GameService.getLiveGamesNew();
    }
    return liveGames;
  }
}
