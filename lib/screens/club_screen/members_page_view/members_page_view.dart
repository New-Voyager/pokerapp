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
  bool _isOwner = false;

  bool _showLoading = false;

  List<ClubMemberModel> _clubMembers;

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

  _checkOwner() {
    _isOwner = Provider.of<ClubModel>(
      context,
      listen: false,
    ).isOwner;
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers();
    _checkOwner();
  }

  @override
  Widget build(BuildContext context) {
    return _clubMembers == null
        ? Center(child: CircularProgressIndicator())
        /* owner of the group and the manager of the group will have privileged access */
        : true // FIXME: REVERT BACK TO CHECKING OF IS OWNER
            ? AdminView(clubMembers: _clubMembers)
            : GeneralView(clubMembers: _clubMembers);
  }
}
