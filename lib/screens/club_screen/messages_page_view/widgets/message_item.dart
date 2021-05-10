import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_time.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_user_avatar.dart';

import '../../../../resources/app_colors.dart';
import '../../../chat_screen/utils.dart';
import '../../../chat_screen/widgets/triangle_painter.dart';
import '../club_chat_model.dart';

class MessageItem extends StatelessWidget {
  final ClubChatModel messageModel;
  final AuthModel currentUser;
  final Map<String, String> players;

  MessageItem({
    @required this.messageModel,
    @required this.currentUser,
    @required this.players,
  });

  final double extraPadding = 80.0;
  @override
  Widget build(BuildContext context) {
    /* ui */

    final bool isMe = currentUser.uuid == messageModel.sender;

    if (isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTile(isMe, messageModel.isGroupLatest),
          SizedBox(width: 5),
          _buildAvatar(),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildAvatar(),
        SizedBox(width: 5),
        _buildTile(isMe, messageModel.isGroupLatest),
      ],
    );
  }

  Widget _buildAvatar() {
    if (messageModel.isGroupLatest)
      return ChatUserAvatar(
        name: players[messageModel.sender ?? ''] ?? 'Somebody',
        userId: messageModel.sender ?? '',
      );
    return SizedBox();
  }

  Widget _buildTile(bool isMe, bool isGroupLatest) {
    Widget triangle;
    CustomPaint trianglePainer =
        CustomPaint(painter: Triangle(isMe ? senderColor : receiverColor));
    if (isMe) {
      triangle = Positioned(right: 0, bottom: 0, child: trianglePainer);
    } else {
      triangle = Positioned(left: 0, bottom: 0, child: trianglePainer);
    }

    return Expanded(
      child: Stack(
        children: [
          if (isGroupLatest) triangle,
          Padding(
            padding: EdgeInsets.only(
              left: !isGroupLatest ? 20 : 0,
              right: !isGroupLatest ? 20 : 0,
            ),
            child: _buildMessage(isMe),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(bool isMe) {
    final playerName = players[messageModel.sender ?? ''] ?? 'Somebody';
    log('player: ${messageModel.sender} isMe: $isMe name: $playerName ${messageModel.text}');

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          right: isMe ? 0.0 : extraPadding,
          left: isMe ? extraPadding : 0.0,
        ),
        padding: EdgeInsets.all(
            messageModel.messageType == MessageType.GIPHY ? 0 : 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: isMe ? senderColor : receiverColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (messageModel.isGroupFirst)
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  isMe ? 'You' : playerName,
                  style: TextStyle(
                    color: AppColors.appAccentColor,
                  ),
                ),
              ),
            messageModel.messageType == MessageType.GIPHY
                ? GiphyImageWidget(
                    imgUrl: messageModel.giphyLink,
                    date: DateTime.fromMillisecondsSinceEpoch(
                      messageModel.messageTimeInEpoc,
                    ),
                    isMe: isMe,
                  )
                : Container(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      messageModel.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),

            /* show the message time */
            if (messageModel.messageType != MessageType.GIPHY)
              SizedBox(height: 3),
            if (messageModel.messageType != MessageType.GIPHY)
              ChatTimeWidget(
                isSender: isMe,
                date: DateTime.fromMillisecondsSinceEpoch(
                  messageModel.messageTimeInEpoc,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GiphyImageWidget extends StatelessWidget {
  final String imgUrl;
  final DateTime date;
  final bool isMe;

  const GiphyImageWidget({
    Key key,
    this.imgUrl,
    this.date,
    this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imgUrl,
            placeholder: (_, __) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: ChatTimeWidget(
              isSender: isMe,
              date: date,
            ),
          ),
        ],
      ),
    );
  }
}
