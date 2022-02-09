import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';

class CacheService {
  Map<String, List<ClubMemberModel>> clubMembersMap =
      Map<String, List<ClubMemberModel>>();
  List<ClubModel> myClubs;
  Map<String, ClubHomePageModel> clubDetailsMap =
      Map<String, ClubHomePageModel>();
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
    // List<ClubModel> clubs = [];
    // for (final club in myClubs) {
    //   if (club.clubName == 'Common Interests') {
    //     clubs.add(club);
    //     break;
    //   }
    // }
    // myClubs = clubs;
    return myClubs;
  }
}
