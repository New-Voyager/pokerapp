import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/messages_from_member.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/chat_model.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_list_widget.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
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

class _ChatScreenState extends State<ChatScreen> with RouteAwareAnalytics {
  @override
  String get routeName => Routes.chatScreen;
  TextEditingController _textController = TextEditingController();
  List<MessagesFromMember> messages = [];
  bool isHostView;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("chatScreen");
  }

  @override
  Widget build(BuildContext context) {
    isHostView = widget.player != null;
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              theme: theme,
              context: context,
              titleText: widget.name ?? _appScreenText['Message'],
            ),
            body: _buildBody(),
          )),
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
          appScreenText: _appScreenText,
          onGifSelectTap: _onEmoji,
          textEditingController: _textController,
          onSend: _onSaveClicked,
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

      await ClubsService.markMemberRead(
          player: widget.player, clubCode: widget.clubCode);
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
