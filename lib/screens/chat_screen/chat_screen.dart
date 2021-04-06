import 'package:flutter/material.dart';
import 'package:pokerapp/models/messages_from_member.dart';
import 'package:pokerapp/screens/chat_screen/chat_model.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_list_widget.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/color_generator.dart';

import 'utils.dart';
import 'widgets/chat_text_field.dart';
import 'widgets/no_message.dart';

class ChatScreen extends StatefulWidget {
  final String clubCode;
  final String player;
  final String name;

  const ChatScreen({
    Key key,
    @required this.clubCode,
    this.player,
    this.name,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<MessagesFromMember> messages = [];
  bool isHostView;

  @override
  Widget build(BuildContext context) {
    isHostView = widget.player != null;
    return Scaffold(
      backgroundColor: chatBg,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: chatHeaderColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                generateColorFor(widget.name != null ? widget.name : 'HOST'),
            child: Text(
              widget.name != null ? widget.name[0].toLowerCase() : 'H',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 5),
          Text(
            widget.name ?? 'Host',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<MessagesFromMember>>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data.length == 0) {
                  return NoMessageWidget();
                }
                return ChatListWidget(
                  isHostView: isHostView,
                  chats: _convert(),
                  name: widget.name,
                );
              }),
        ),
        ChatTextField(
          icon: Icons.emoji_emotions_outlined,
          onEmoji: _onEmoji,
          textEditingController: _textController,
          onSave: _onSaveClicked,
          onTap: _onTap,
        ),
      ],
    );
  }

  Future<List<MessagesFromMember>> _fetchData() async {
    if (messages.length == 0) {
      messages = await ClubsService.memberMessages(
        clubCode: widget.clubCode,
        player: widget.player,
      );
    }
    return messages;
  }

  List<ChatModel> _convert() {
    messages.sort(
      (a, b) => toDateTime(b.messageTime)
          .millisecondsSinceEpoch
          .compareTo(toDateTime(a.messageTime).millisecondsSinceEpoch),
    );
    List<ChatModel> chats = [];
    for (int i = 0; i < messages.length; i++) {
      var m = messages[i];
      var chat = ChatModel(
          id: m.id,
          memberID: m.memberID,
          messageType: m.messageType,
          text: m.text,
          messageTime: toDateTime(m.messageTime),
          memberName: m.memberName);
      if (i == 0) {
        chat.isGroupLatest = true;
      } else {
        if (messages[i].messageType == messages[i - 1].messageType)
          chat.isGroupLatest = false;
        else
          chat.isGroupLatest = true;
      }
      chats.add(chat);
    }
    return chats;
  }

  void _onSaveClicked() {
    if (_textController.text.trim().isNotEmpty) {
      ClubsService.sendMessage(
          _textController.text.trim(), widget.player, widget.clubCode);
      setState(() {
        messages.add(
          MessagesFromMember(
            messageType: widget.player != null ? FROM_HOST : TO_HOST,
            text: _textController.text,
            messageTime: DateTime.now().toString(),
          ),
        );
        _textController.clear();
      });
    }
  }

  void _onTap() {}

  void _onEmoji() {}
}
