import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_giphys.dart';

import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/widgets/attributed_gif_widget.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';
import 'package:provider/provider.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class GameChat extends StatefulWidget {
  final ScrollController scrollController;
  final GameMessagingService chatService;
  final Function onChatVisibilityChange;

  GameChat({
    @required this.chatService,
    @required this.onChatVisibilityChange,
    @required this.scrollController,
  });

  @override
  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> {
  GameMessagingService get chatService => widget.chatService;
  ScrollController get _scrollController => widget.scrollController;

  final ValueNotifier<bool> _vnShowEmojiPicker = ValueNotifier(false);
  final _textEditingController = TextEditingController();

  int myID = -1;

  void _init() {
    this.myID = context.read<GameContextObject>().currentPlayer.id;
  }

  @override
  void initState() {
    super.initState();

    // mark all the messages as read post frame building
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GameChatNotifState>().readAll();
    });

    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onEmojiClick() {
    // open emoji picker
    _vnShowEmojiPicker.value = !_vnShowEmojiPicker.value;

    // close keyboard
    if (_vnShowEmojiPicker.value) {
      FocusScope.of(context).unfocus();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients)
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
  }

  void _onGifClick() async {
    /* when current user sends any message, scroll to the bottom */
    _scrollToBottom();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => GameChatBottomSheet(chatService),
    );
  }

  void _onSendClick() {
    // close emoji picker
    _vnShowEmojiPicker.value = false;

    /* when current user sends any message, scroll to the bottom */
    _scrollToBottom();

    // validates the text message
    final String text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    // send the message
    chatService.sendText(text);

    _textEditingController.clear();
  }

  Widget _buildCloseButton(AppTheme theme) => Align(
        alignment: Alignment.topRight,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Transform.rotate(
              angle: -pi / 2,
              child: SvgPicture.asset(
                'assets/images/backarrow.svg',
                color: theme.accentColor,
                width: 20.pw,
                height: 20.ph,
                fit: BoxFit.cover,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(24.pw),
          onTap: widget.onChatVisibilityChange,
        ),
      );

  Widget _buildChatBubble(ChatMessage message, AppTheme theme) {
    bool isMe = myID == message.fromPlayer;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
            minWidth: MediaQuery.of(context).size.width * 0.3,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: isMe
              ? AppDecorators.getChatMyMessageDecoration(theme)
              : AppDecorators.getChatOtherMessageDecoration(theme),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* name of player & time */
              Row(
                children: [
                  // name
                  Text(
                    message.fromName.toString(),
                    style: AppDecorators.getSubtitle2Style(theme: theme)
                        .copyWith(color: theme.accentColor),
                    softWrap: true,
                  ),

                  // sep
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    //color: const Color(0xff848484),
                    height: 10.0,
                    width: 1.0,
                  ),
                ],
              ),

              // sep
              SizedBox(height: 2),

              // message / gif
              message.text != null
                  ? Text(
                      message.text,
                      style: AppDecorators.getHeadLine4Style(theme: theme),
                    )
                  : AttributedGifWidget(url: message.giphyLink),

              AppDimensionsNew.getVerticalSizedBox(4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // time
                  Text(
                    "${AppConstants.CHAT_DATE_TIME_FORMAT.format(message.received.toLocal())}",
                    style: AppDecorators.getSubtitle3Style(theme: theme),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageArea(AppTheme theme) => Expanded(
        child: Consumer<GameChatNotifState>(
          builder: (_, gcns, __) => ListView(
            shrinkWrap: true,
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            reverse: true,
            children: widget.chatService.messages.reversed
                .map((c) => _buildChatBubble(c, theme))
                .toList(),
          ),
        ),
      );

  Widget _buildTextField(AppTheme theme) => Container(
        decoration: AppDecorators.tileDecorationWithoutBorder(theme),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            // text field
            Expanded(
              child: TextField(
                onTap: () {
                  _vnShowEmojiPicker.value = false;
                },
                controller: _textEditingController,
                style: AppDecorators.getSubtitle2Style(theme: theme),
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  border: InputBorder.none,
                  hintText: AppStringsNew.chatHintText,
                ),
              ),
            ),

            // emoji button
            GestureDetector(
              onTap: _onEmojiClick,
              child: Icon(
                Icons.emoji_emotions_outlined,
                size: 25,
                color: theme.accentColor,
              ),
            ),
          ],
        ),
      );

  Widget _buildUserInputWidget(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          /* gif drawer button */
          GestureDetector(
            onTap: _onGifClick,
            child: Icon(
              Icons.add_circle_outline,
              size: 25,
              color: theme.accentColor,
            ),
          ),

          /* main text field */
          Expanded(
            child: _buildTextField(theme),
          ),

          /* send button */
          GestureDetector(
            onTap: _onSendClick,
            child: Icon(
              Icons.send_outlined,
              color: theme.accentColor,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewMessageNotifier(AppTheme theme) =>
      Consumer<GameChatNotifState>(
        builder: (_, gcns, __) => gcns.hasUnreadMessages
            ? InkWell(
                onTap: _scrollToBottom,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: theme.primaryColorWithDark(),
                        size: 20.0,
                      ),

                      // sep
                      const SizedBox(width: 5.0),

                      Text(
                        '${gcns.count} new message',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      );

  Widget _buildMainBody(AppTheme theme) {
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      // padding: EdgeInsets.only(
      //   bottom: MediaQuery.of(context).viewInsets.bottom,
      // ),
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          /* top widgets, new message notifier & close button */
          Stack(
            children: [
              /* new message notifier */
              _buildNewMessageNotifier(theme),

              /* close button */
              _buildCloseButton(theme),
            ],
          ),

          /* main message area */
          _buildMessageArea(theme),

          /* user input widget */
          _buildUserInputWidget(theme),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* main bottom sheet, that has all the chat functionality */
        _buildMainBody(theme),

        /* emoji picker widget */
        ValueListenableBuilder<bool>(
          valueListenable: _vnShowEmojiPicker,
          builder: (_, bool showPicker, __) => showPicker
              ? EmojiPicker(
                  onEmojiSelected: (String emoji) {
                    _textEditingController.text += emoji;
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
