import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

class GeneralView extends StatelessWidget {
  final List<ClubMembersModel> clubMembers;

  GeneralView({
    @required this.clubMembers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      itemBuilder: (_, int index) {
        ClubMembersModel member = clubMembers[index];

        return ListTile(
          title: Text(
            member.name,
            style: AppStyles.credentialsTextStyle,
          ),
          subtitle: Text(
            member.lastGamePlayedDate == null
                ? 'Never played'
                : 'Last played on ${member.lastGamePlayedDate}',
            style: AppStyles.credentialsTextStyle.copyWith(
              fontSize: 14,
              color: AppColors.contentColor,
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
        color: AppColors.contentColor,
      ),
      itemCount: clubMembers.length,
    );
  }
}
