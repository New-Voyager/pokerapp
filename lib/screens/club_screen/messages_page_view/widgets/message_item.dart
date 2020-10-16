import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/resources/app_colors.dart';

class MessageItem extends StatelessWidget {
  final ClubMessageModel messageModel;
  final AuthModel currentUser;
  final Map<String, String> players;

  MessageItem({
    @required this.messageModel,
    @required this.currentUser,
    @required this.players,
  });

  @override
  Widget build(BuildContext context) {
    /* ui */
    final double infoFontSize = 12.0;
    final double extraPadding = 30.0;

    final bool isMe = currentUser.uuid == messageModel.playerTags;
    final separator = SizedBox(height: 10.0);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          right: isMe ? 0.0 : extraPadding,
          left: isMe ? extraPadding : 0.0,
        ),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: isMe ? AppColors.chatMeColor : AppColors.chatOthersColor,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isMe
                  ? 'You'
                  : players[messageModel.playerTags ?? ''] ?? 'Somebody',
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.appAccentColor,
                fontSize: infoFontSize,
              ),
            ),
            separator,

            /* body */

            messageModel.messageType == MessageType.GIPHY
                ? CachedNetworkImage(
                    imageUrl: messageModel.giphyLink,
                    placeholder: (_, __) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Text(
                    messageModel.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),

            /* show the message time */
            separator,
            Text(
              DateFormat('d MMM, h:mm a')
                  .format(DateTime.fromMillisecondsSinceEpoch(
                messageModel.messageTimeInEpoc * 1000,
              )),
              style: TextStyle(
                fontSize: infoFontSize,
                color: Colors.white.withOpacity(0.40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
