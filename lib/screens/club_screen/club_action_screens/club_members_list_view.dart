import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';

class ClubMembersListView extends StatelessWidget {
  final ClubMemberStatus _membersStatus;
  List<ClubMembersModel> _membersList = new List<ClubMembersModel>();

  ClubMembersListView(this._membersStatus);

  @override
  Widget build(BuildContext context) {
    //_membersList.add(new ClubMembersModel.fromJson(""));
    return Container(
      child: ListView.builder(
        itemCount: _membersList.length,
        itemBuilder: (context, index) {
          return Text(_membersList[index].name);
        },
      ),
    );
  }
}
