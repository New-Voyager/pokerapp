import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/screens/club_screen/members_page_view/admin_view/admin_view.dart';
import 'package:pokerapp/screens/club_screen/members_page_view/general_view/general_view.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:provider/provider.dart';

class MembersPageView extends StatefulWidget {
  @override
  _MembersPageViewState createState() => _MembersPageViewState();
}

class _MembersPageViewState extends State<MembersPageView> {
  // TODO: CHECK IF USER IS ADMIN OF THIS GROUP
  // TODO: for now this is the flag to toggle views
  bool _isOwner = false;

  bool _showLoading = false;

  List<ClubMembersModel> _clubMembers;

  _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  _fetchMembers() async {
    _toggleLoading();

    String clubCode = Provider.of<ClubModel>(
      context,
      listen: false,
    ).clubCode;

    _clubMembers = await ClubInteriorService.getMembers(clubCode);

    _toggleLoading();
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return _clubMembers == null
        ? Center(child: CircularProgressIndicator())
        /* owner of the group and the manager of the group will have privileged access */
        : _isOwner
            ? AdminView(clubMembers: _clubMembers)
            : GeneralView(clubMembers: _clubMembers);
  }
}
