import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_time.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_user_avatar.dart';

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

    final bool isMe = currentUser.uuid == messageModel.playerTags;

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
        name: players[messageModel.playerTags ?? ''] ?? 'Somebody',
        userId: messageModel.playerTags ?? '',
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
          Padding(
            padding: EdgeInsets.only(
              left: !isGroupLatest ? 20 : 0,
              right: !isGroupLatest ? 20 : 0,
            ),
            child: _buildMessage(isMe),
          ),
          if (isGroupLatest) triangle,
        ],
      ),
    );
  }

  Widget _buildMessage(bool isMe) {
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
          color: isMe ? senderColor : receiverColor,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            messageModel.messageType == MessageType.GIPHY
                ? GiphyImageWidget(
                    imgUrl: messageModel.giphyLink,
                  )
                : Text(
                    messageModel.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),

            /* show the message time */

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

  const GiphyImageWidget({Key key, this.imgUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      placeholder: (_, __) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
