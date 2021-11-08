import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

class GeneralView extends StatelessWidget {
  final List<ClubMemberModel> clubMembers;

  GeneralView({
    @required this.clubMembers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      itemBuilder: (_, int index) {
        ClubMemberModel member = clubMembers[index];

        return ListTile(
          title: Text(
            member.name,
            style: AppStylesNew.credentialsTextStyle,
          ),
          subtitle: Text(
            member.lastPlayedDate == null
                ? 'Never played'
                : 'Last played on ${member.lastPlayedDate}',
            style: AppStylesNew.credentialsTextStyle.copyWith(
              fontSize: 14,
              color: AppColorsNew.contentColor,
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: member.imageId == null || member.imageId.isEmpty
                ? AssetImage('assets/images/${1 + Random().nextInt(3)}.png')
                : NetworkImage(member.imageId),
          ),
        );
      },
      separatorBuilder: (_, __) => Divider(
        color: AppColorsNew.contentColor,
      ),
      itemCount: clubMembers.length,
    );
  }
}
