import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/chat.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:provider/provider.dart';

class GameContextView extends StatelessWidget {
  final String gameCode;
  final GameChatService chatService;
  final String playerUuid;
  GameContextView(this.gameCode, this.playerUuid, this.chatService);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) =>
                      GameOptionsBottomSheet(this.gameCode, this.playerUuid),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBackgroundColor),
                child: Icon(
                  Icons.more_horiz,
                  color: AppColors.appAccentColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => GameChat(this.chatService),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBackgroundColor),
                child: Icon(
                  Icons.chat_bubble,
                  color: AppColors.appAccentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
