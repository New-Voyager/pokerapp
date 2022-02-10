import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/member_activity_model.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';

class CachedObject {
  String key;
  dynamic value;
  DateTime lastUpdated;
  int cacheTime; // in seconds
}

class CacheService {
  Map<String, List<ClubMemberModel>> clubMembersMap =
      Map<String, List<ClubMemberModel>>();
  List<ClubModel> myClubs;
  Map<String, ClubHomePageModel> clubDetailsMap =
      Map<String, ClubHomePageModel>();

  Map<String, CachedObject> cachedObjects = Map<String, CachedObject>();
  String refreshClub = '';
  String refreshClubMembers = '';

  /** 
   * Return club members from the cache. If update is set to true, fetch from server, cache it.
   */
  Future<List<ClubMemberModel>> getMembers(String clubCode,
      {bool update = false}) async {
    if (clubMembersMap[clubCode] == null || clubCode == refreshClubMembers) {
      update = true;
    }
    if (clubCode == refreshClubMembers) {
      refreshClubMembers = '';
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
    if (clubDetailsMap[clubCode] == null || clubCode == refreshClub) {
      update = true;
    }
    if (clubCode == refreshClub) {
      refreshClubMembers = '';
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

  dynamic getFromCache(String cacheId) {
    if (cachedObjects[cacheId] != null) {
      CachedObject cachedObject = cachedObjects[cacheId];
      if (cachedObject.lastUpdated.isBefore(
          DateTime.now().subtract(Duration(seconds: cachedObject.cacheTime)))) {
        return null;
      }
      return cachedObject.value;
    }
    return null;
  }

  void cacheObject(String cacheId, dynamic value, {int cacheTime = 180}) {
    final cachedObject = CachedObject();
    cachedObject.lastUpdated = DateTime.now();
    cachedObject.key = cacheId;
    cachedObject.value = value;
    cachedObject.cacheTime = cacheTime;
    cachedObjects[cacheId] = cachedObject;
  }

  Future<List<MemberActivity>> getAgentPlayerActivities(
      String clubCode, String agentId, DateTime start, DateTime end) async {
    String cacheId =
        '$clubCode-$agentId-${start.toIso8601String()}-${end.toIso8601String()}';
    final cachedObject = getFromCache(cacheId);
    if (cachedObject != null) {
      return cachedObject;
    }
    final activities = await ClubInteriorService.getAgentPlayerActivities(
        clubCode, agentId, start, end);
    cacheObject(cacheId, activities);
    return activities;
  }
}
