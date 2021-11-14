import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/messages_from_member.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/chat_model.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_list_widget.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/text_filtering/text_filtering.dart';
import 'package:pokerapp/utils/gif_widget.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';
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

  final ValueNotifier<bool> _vnShowEmojiPicker = ValueNotifier(false);
  final TextEditingController _textController = TextEditingController();
  List<MessagesFromMember> messages = [];
  AppTextScreen _appScreenText;

  Timer _timer;

  void _fetchAndUpdate() async {
    final messagesFromMembers = await _fetchData();

    // if no new message just return
    if (messagesFromMembers.length == messages.length) return;

    dev.log('chat screen for host-member message: fetching');

    setState(() {
      messages.clear();
      messages.addAll(messagesFromMembers);
    });
  }

  void _startFetching() {
    _timer = Timer.periodic(
      AppConstants.messagePollDuration,
      (_) => _fetchAndUpdate(),
    );
  }

  void _stopFetching() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("chatScreen");
    _startFetching();
  }

  @override
  void dispose() {
    _stopFetching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHostView = widget.player != null;
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: widget.name ?? _appScreenText['MESSAGE'],
          ),
          body: _buildBody(isHostView),
        ),
      ),
    );
  }

  Widget _buildBody(final bool isHostView) {
    return Column(
      children: [
        // chat list
        Expanded(
          child: messages.isEmpty
              ? NoMessageWidget()
              : ChatListWidget(
                  isHostView: isHostView,
                  chats: _convert(),
                  name: widget.name,
                ),
        ),

        // player typing field
        ChatTextField(
          icon: Icons.emoji_emotions_outlined,
          appScreenText: _appScreenText,
          onEmojiSelectTap: _onEmojiTap,
          textEditingController: _textController,
          onSend: _onSendClicked,
        ),

        // emoji picker
        ValueListenableBuilder<bool>(
          valueListenable: _vnShowEmojiPicker,
          builder: (_, showEmojiPicker, __) => showEmojiPicker
              ? EmojiPicker(
                  onEmojiSelected: (String emoji) {
                    _textController.text += emoji;
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<List<MessagesFromMember>> _fetchData() async {
    final m = await ClubsService.memberMessages(
      clubCode: widget.clubCode,
      player: widget.player,
    );

    await ClubsService.markMemberRead(
      player: widget.player,
      clubCode: widget.clubCode,
    );

    return m;
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

  void _onSendClicked() async {
    _vnShowEmojiPicker.value = false;
    final text = _textController.text.trim();
    _textController.clear();

    if (text.isNotEmpty) {
      await ClubsService.sendMessage(
        TextFiltering.mask(text),
        widget.player,
        widget.clubCode,
      );

      // fetch and update after sent the message
      _fetchAndUpdate();
    }
  }

  void _onEmojiTap() async {
    _vnShowEmojiPicker.value = !_vnShowEmojiPicker.value;
  }
}
