import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/bottom_sheet/gif_drawer_sheet.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/widgets/message_item.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/club_message_service.dart';

import '../../chat_screen/utils.dart';
import '../../chat_screen/widgets/chat_text_field.dart';
import 'club_chat_model.dart';

class MessagesPageView extends StatefulWidget {
  MessagesPageView({
    @required this.clubCode,
  });

  final String clubCode;

  @override
  _MessagesPageViewState createState() => _MessagesPageViewState();
}

class _MessagesPageViewState extends State<MessagesPageView> {
  TextEditingController _textController = TextEditingController();

  List<ClubMessageModel> messages = [];

  AuthModel _authModel;
  Map<String, String> _players;

  void _sendMessage() {
    String text = _textController.text.trim();
    _textController.clear();

    if (text.isEmpty) return;

    ClubMessageModel _model = ClubMessageModel(
      clubCode: widget.clubCode,
      messageType: MessageType.TEXT,
      text: text,
    );

    ClubMessageService.sendMessage(_model);
  }

  void _sendGif(String url) {
    ClubMessageModel _model = ClubMessageModel(
      clubCode: widget.clubCode,
      messageType: MessageType.GIPHY,
      giphyLink: url,
    );

    ClubMessageService.sendMessage(_model);
  }

  void _openGifDrawer() async {
    String gifUrl = await showModalBottomSheet<String>(
      context: navigatorKey.currentContext,
      builder: (_) => GifDrawerSheet(),
    );

    if (gifUrl != null) _sendGif(gifUrl);
  }

  _fetchMembers() async {
    List<ClubMemberModel> _clubMembers =
        await ClubInteriorService.getMembers(widget.clubCode);

    _players = Map<String, String>();

    _clubMembers.forEach((member) {
      _players[member.playerId] = member.name;
    });

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    /* this fetches the information regarding the current user */
    AuthService.get().then((value) => _authModel = value);

    /* this function fetches the members of the clubs - to show name corresponding to messages */
    _fetchMembers();
  }

  @override
  void dispose() {
    super.dispose();

    ClubMessageService.closeStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          /* main view to show messages */
          Expanded(
            child: StreamBuilder<List<ClubMessageModel>>(
              stream: ClubMessageService.pollMessages(widget.clubCode),
              builder: (_, snapshot) {

                if (!snapshot.hasData || _players == null)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                if (snapshot.data.isEmpty) return NoMessageWidget();

                messages = snapshot.data;
                var mess = _convert();

                return ListView.separated(
                  reverse: true,
                  padding: const EdgeInsets.all(5),
                  itemBuilder: (_, int index) => MessageItem(
                    messageModel: mess[index],
                    currentUser: _authModel,
                    players: _players,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                  itemCount: snapshot.data.length,
                );
              },
            ),
          ),
          ChatTextField(
            icon: FontAwesomeIcons.icons,
            onEmoji: _openGifDrawer,
            textEditingController: _textController,
            onSave: _sendMessage,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: chatHeaderColor,
      leading: IconButton(
        iconSize: 24,
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.appAccentColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: false,
      title: Text(
        'Club Chat',
        style: AppStyles.titleBarTextStyle.copyWith(fontSize: 16),
      ),
    );
  }

  List<ClubChatModel> _convert() {
    List<ClubChatModel> chats = [];
    for (int i = 0; i < messages.length; i++) {
      var m = messages[i];
      var chat = ClubChatModel(
        id: m.id,
        clubCode: m.clubCode,
        messageType: m.messageType,
        text: m.text,
        gameNum: m.gameNum,
        handNum: m.handNum,
        giphyLink: m.giphyLink,
        playerTags: m.playerTags,
        messageTimeInEpoc: m.messageTimeInEpoc,
      );
      if (i == 0) {
        chat.isGroupLatest = true;
      } else {
        if (messages[i].playerTags == messages[i - 1].playerTags)
          chat.isGroupLatest = false;
        else
          chat.isGroupLatest = true;
      }

      if (i == messages.length - 1) {
        chat.isGroupFirst = true;
      } else {
        if (messages[i].playerTags == messages[i + 1].playerTags)
          chat.isGroupFirst = false;
        else
          chat.isGroupFirst = true;
      }

      chats.add(chat);
    }
    return chats;
  }

  void _onTap() {}
}
