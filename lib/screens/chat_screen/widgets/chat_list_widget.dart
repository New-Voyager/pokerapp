import 'package:flutter/material.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_user_avatar.dart';

import '../chat_model.dart';
import '../utils.dart';
import 'chat_date.dart';
import 'chat_time.dart';
import 'triangle_painter.dart';

class ChatListWidget extends StatefulWidget {
  final List<ChatModel> chats;
  final bool isHostView;
  final String name;

  const ChatListWidget({
    Key key,
    this.chats,
    this.isHostView,
    this.name,
  }) : super(key: key);

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        padding: EdgeInsets.only(
            top: height * 0.01, left: width * 0.01, right: width * 0.01),
        itemCount: widget.chats.length,
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          int day = 0;
          if (i == 0) {
            // _previous = null;
          } else {
            day = _dateDiff(i);
          }
          if (i == widget.chats.length - 1) {
            return Column(children: [
              ChatDateTime(date: widget.chats[i].messageTime),
              _buildTile(widget.chats[i]),
            ]);
          }
          if (day == 0) {
            return _buildTile(widget.chats[i]);
          } else {
            return Column(children: [
              _buildTile(widget.chats[i]),
              ChatDateTime(date: widget.chats[i - 1].messageTime),
            ]);
          }
        });
  }

  Widget _buildTile(ChatModel message) {
    bool isSender = _isSender(message.messageType);

    if (!message.isGroupLatest) {
      return Container(
        margin: EdgeInsets.only(
          left: isSender ? 80 : 10,
          right: isSender ? 10 : 80,
          top: 3,
          bottom: 3,
        ),
        child: _buildTextMessage(message, context),
      );
    }

    if (!isSender) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(message),
          _buildChatMessage(message),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildChatMessage(message),
        _buildAvatar(message),
      ],
    );
  }

  Widget _buildAvatar(ChatModel message) {
    String name = 'HOST';
    if (message.messageType != FROM_HOST) {
      name = message.memberName ?? 'A';
    }

    return ChatUserAvatar(
      userId: message.memberID.toString(),
      name: name,
    );
  }

  Widget _buildChatMessage(ChatModel message) {
    bool isSender = _isSender(message.messageType);
    Widget triangle;
    CustomPaint trianglePainer =
        CustomPaint(painter: Triangle(isSender ? senderColor : receiverColor));
    if (isSender) {
      triangle = Positioned(right: 0, bottom: 0, child: trianglePainer);
    } else {
      triangle = Positioned(left: 0, bottom: 0, child: trianglePainer);
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
          margin: EdgeInsets.only(
              left: isSender ? 80 : 10,
              right: isSender ? 10 : 80,
              top: 3,
              bottom: 3),
          child: Stack(
            children: [_buildTextMessage(message, context), triangle],
          ),
        ),
      ),
    );
  }

  Widget _buildTextMessage(ChatModel message, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isSender = _isSender(message.messageType);
    return Container(
      decoration:
          decoration.copyWith(color: isSender ? senderColor : receiverColor),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(
                message.text,
                style: TextStyle(color: Colors.white, fontSize: height * 0.025),
              ),
            ),
            ChatTimeWidget(
              isSender: isSender,
              date: message.messageTime,
            ),
          ],
        ),
      ),
    );
  }

  int _dateDiff(int index) {
    var dt1 = widget.chats[index].messageTime;
    var dt2 = widget.chats[index - 1].messageTime;
    if (index > 0) {
      return dt1.difference(dt2).inDays;
    }
    return 0;
  }

  bool _isSender(String type) {
    if (widget.isHostView)
      return type == FROM_HOST;
    else
      return type != FROM_HOST;
  }
}
