import 'dart:convert';

class ManagerRole {
  bool _memberDetailsPage;
  bool _tips;
  bool _announcement;
  bool _hostGames;
  bool _approveBuyin;
  bool _viewMemberActivities;
  bool _updateCredits;

  ManagerRole({
    bool memberDetailsPage,
    bool tips,
    bool announcement,
    bool hostGames,
    bool approveBuyin,
    bool viewMemberActivities,
    bool updateCredits,
  }) {
    this._memberDetailsPage = memberDetailsPage;
    this._tips = tips;
    this._announcement = announcement;
    this._hostGames = hostGames;
    this._approveBuyin = approveBuyin;
    this._viewMemberActivities = viewMemberActivities;
    this._updateCredits = updateCredits;
  }

  bool get canSeeMemberDetailsPage {
    return _memberDetailsPage;
  }

  set canSeeMemberDetailsPage(bool memberDetailsPage) {
    _memberDetailsPage = memberDetailsPage;
  }

  bool get canSeeTips {
    return _tips;
  }

  set canSeeTips(bool tips) {
    _tips = tips;
  }

  bool get canMakeAnnouncement {
    return _announcement;
  }

  set canMakeAnnouncement(bool announcement) {
    _announcement = announcement;
  }

  bool get canHostGames {
    return _hostGames;
  }

  set canHostGames(bool hostGames) {
    _hostGames = hostGames;
  }

  bool get canApproveBuyin {
    return _approveBuyin;
  }

  set canApproveBuyin(bool approveBuyin) {
    _approveBuyin = approveBuyin;
  }

  bool get canViewMemberActivities {
    return _viewMemberActivities;
  }

  set canViewMemberActivities(bool viewMemberActivities) {
    _viewMemberActivities = viewMemberActivities;
  }

  bool get canUpdateCredits {
    return _updateCredits;
  }

  set canUpdateCredits(bool updateCredits) {
    _updateCredits = updateCredits;
  }
}
