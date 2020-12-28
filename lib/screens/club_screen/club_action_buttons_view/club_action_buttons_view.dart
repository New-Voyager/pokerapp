import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_action_buttons_view/club_action_button.dart';

class ClubActionButtonsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.GAME_HISTORY,
                  "Game History",
                  Icon(
                    Icons.history,
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.MEMBERS,
                  "Members",
                  Icon(
                    Icons.card_membership,
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.CHAT,
                  "Chat",
                  Icon(
                    Icons.access_alarm,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.BOOKMARKED_HANDS,
                  "Bookmarked Hands",
                  Icon(
                    Icons.bookmark,
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.ANALYSIS,
                  "Analysis",
                  Icon(
                    Icons.pie_chart,
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.ANNOUNCEMETS,
                  "Announcements",
                  Icon(
                    Icons.speaker,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.MESSAGE_HOST,
                  "Message Host",
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClubActionButton(
                  ClubActions.MANAGE_CHIPS,
                  "Manage Chips",
                  Icon(
                    Icons.ac_unit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
