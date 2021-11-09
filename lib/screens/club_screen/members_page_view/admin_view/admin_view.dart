import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/members_page_view/admin_view/widget/member_item.dart';

enum MemberStatus {
  AllMembers,
  InActiveMembers,
}

class AdminView extends StatelessWidget {
  final List<ClubMemberModel> clubMembers;

  AdminView({
    @required this.clubMembers,
  });

  Widget _buildWidgetList(List<ClubMemberModel> members) {
    if (members.isEmpty)
      return Center(
        child: const Text(
          'No Members',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      );

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      itemBuilder: (_, int index) => MemberItem(
        member: members[index],
      ),
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* tab bar */
          TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            indicatorPadding: EdgeInsets.zero,
            indicatorColor: Colors.transparent,
            labelStyle: AppStylesNew.itemInfoSecondaryTextStyle.copyWith(
              fontSize: 19.0,
            ),
            labelColor: AppColorsNew.appAccentColor,
            labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Inactive'),
            ],
          ),

          /* main view */
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                /* show all members */
                _buildWidgetList(clubMembers),

                /* show only In active members */
                _buildWidgetList(
                  clubMembers
                      .where(
                          (member) => member.status != ClubMemberStatus.ACTIVE)
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
