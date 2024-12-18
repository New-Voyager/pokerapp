import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
// import 'package:pokerapp/screens/club_screen/messages_page_view/bottom_sheet/gif_drawer_sheet.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/widgets/message_item.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/club_message_service.dart';
import 'package:pokerapp/services/text_filtering/text_filtering.dart';
import 'package:pokerapp/utils/favourite_texts_widget.dart';
import 'package:pokerapp/utils/new_gif_widget.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';
import 'package:pokerapp/widgets/user_input_widget.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import 'club_chat_model.dart';

class MessagesPageView extends StatefulWidget {
  MessagesPageView({
    @required this.clubCode,
    @required this.isSharedHandsOnly,
  });

  final bool isSharedHandsOnly;
  final String clubCode;

  @override
  _MessagesPageViewState createState() => _MessagesPageViewState();
}

class _MessagesPageViewState extends State<MessagesPageView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.message_page;

  final ValueNotifier<bool> _vnShowEmojiPicker = ValueNotifier(false);
  final ValueNotifier<bool> _vnShowFavouriteMessages = ValueNotifier(false);
  final TextEditingController _textController = TextEditingController();
  List<ClubMessageModel> messages = [];
  AppTextScreen _appScreenText;

  AuthModel _authModel;
  Map<String, String> _players;

  void _onEmojiSelectTap() {
    _vnShowEmojiPicker.value = !_vnShowEmojiPicker.value;
    _vnShowFavouriteMessages.value = false;

    // close keyboard
    if (_vnShowEmojiPicker.value) {
      FocusScope.of(context).unfocus();
    }
  }

  void _onPresetMessageClick() async {
    _vnShowFavouriteMessages.value = !_vnShowFavouriteMessages.value;
    _vnShowEmojiPicker.value = false;

    // close keyboard
    if (_vnShowEmojiPicker.value) {
      FocusScope.of(context).unfocus();
    }
  }

  void _sendPreset(String text) {
    _textController.text = text;
    _sendMessage();
  }

  void _sendMessage() {
    _vnShowEmojiPicker.value = false;
    String text = _textController.text.trim();
    _textController.clear();

    if (text.isEmpty) return;

    ClubMessageModel _model = ClubMessageModel(
      clubCode: widget.clubCode,
      messageType: MessageType.TEXT,
      text: TextFiltering.mask(text),
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

  void _sendSticker(String stickerAsset) {
    ClubMessageModel _model = ClubMessageModel(
      clubCode: widget.clubCode,
      messageType: MessageType.STICKER,
      text: stickerAsset,
    );

    ClubMessageService.sendMessage(_model);
  }

  void _openGifDrawer() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => NewGifWidget(
        gifSuggestions: AppConstants.GIF_CATEGORIES,
        onGifSelect: (String gifUrl) => _sendGif(gifUrl),
      ),
    );
  }

  _fetchMembers() async {
    List<ClubMemberModel> _clubMembers =
        await appState.cacheService.getMembers(widget.clubCode);
    _players = Map<String, String>();

    _clubMembers.forEach((member) {
      _players[member.playerId] = member.name;
    });

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("chatScreen");

    /* this fetches the information regarding the current user */
    _authModel = AuthService.get();

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
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['clubChat'],
            subTitleText: "${widget.clubCode}",
            onBackHandle: () {
              appState.cacheService.refreshClub = widget.clubCode;
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /* main view to show messages */
                Expanded(
                  child: StreamBuilder<List<ClubMessageModel>>(
                    stream: ClubMessageService.pollMessages(
                      widget.clubCode,
                      isSharedHandsOnly: widget.isSharedHandsOnly,
                    ),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressWidget(
                          text: _appScreenText['loadingMessages'],
                        );

                      if (snapshot.data?.isEmpty ?? true)
                        return NoMessageWidget(
                          isHandOnly: widget.isSharedHandsOnly,
                        );

                      messages = snapshot.data;
                      var mess = _convert();

                      return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        padding: const EdgeInsets.all(3),
                        itemBuilder: (_, int index) {
                          return MessageItem(
                            messageModel: mess[index],
                            currentUser: _authModel,
                            players: _players,
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 3.0,
                        ),
                        itemCount: mess.length,
                      );
                    },
                  ),
                ),

                // chat text field
                widget.isSharedHandsOnly
                    ? const SizedBox.shrink()
                    : UserInputWidget(
                        onGifClick: _openGifDrawer,
                        onMessagesClick: _onPresetMessageClick,
                        onSendClick: _sendMessage,
                        onEmojiClick: _onEmojiSelectTap,
                        editingController: _textController,
                      ),

                // emoji picker
                ValueListenableBuilder<bool>(
                  valueListenable: _vnShowEmojiPicker,
                  builder: (_, showEmojiPicker, __) => showEmojiPicker
                      ? EmojiStickerPicker(
                          onEmojiSelected: (String emoji) {
                            _textController.text += emoji;
                          },
                          onStickerSelected: (String sticker) {
                            _sendSticker(sticker);
                            log('messages_page_view :: onStickerSelected');
                          },
                        )
                      : const SizedBox.shrink(),
                ),

                // fav texts
                ValueListenableBuilder<bool>(
                  valueListenable: _vnShowFavouriteMessages,
                  builder: (_, bool showFavouriteMessages, __) =>
                      showFavouriteMessages
                          ? FavouriteTextWidget(
                              onPresetTextSelect: _sendPreset,
                            )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
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
        messageTime: m.messageTime,
        //messageTimeInEpoc: m.messageTimeInEpoc,
        sender: m.sender,
        sharedHand: m.sharedHand,
        playerName: m.playerName,
      );
      if (i == 0) {
        chat.isGroupLatest = true;
      } else {
        if (messages[i].sender == messages[i - 1].sender)
          chat.isGroupLatest = false;
        else
          chat.isGroupLatest = true;
      }

      if (i == messages.length - 1) {
        chat.isGroupFirst = true;
      } else {
        if (messages[i].sender == messages[i + 1].sender)
          chat.isGroupFirst = false;
        else
          chat.isGroupFirst = true;
      }

      chats.add(chat);
    }
    return chats;
  }

  void _onTap() {
    // close emoji picker
    _vnShowEmojiPicker.value = false;
  }
}
