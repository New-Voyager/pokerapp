import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/keyboard_visibility_builder.dart';

import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/text_filtering/text_filtering.dart';
import 'package:pokerapp/utils/gif_widget.dart';
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
  AppTextScreen _appScreenText;
  bool expanded = false;

  int myID = -1;

  void _init() {
    this.myID = context.read<GameContextObject>().currentPlayer.id;
  }

  @override
  void initState() {
    _appScreenText = getAppTextScreen("gameChat");

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
      builder: (_) => GifWidget(
        showPresets: true,
        gifSuggestions: AppConstants.GIF_CATEGORIES,
        onPresetTextSelect: (String pText) => chatService.sendText(pText),
        onGifSelect: (String gifUrl) => chatService.sendGiphy(gifUrl),
      ),
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
    chatService.sendText(TextFiltering.mask(text));

    _textEditingController.clear();
  }

  Widget _buildCloseButton(AppTheme theme) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Transform.rotate(
            angle: -pi / 2,
            child: SvgPicture.asset(
              'assets/images/backarrow.svg',
              color: theme.accentColor,
              width: 32.pw,
              height: 32.ph,
              fit: BoxFit.cover,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(24.pw),
        onTap: widget.onChatVisibilityChange,
      ),
    );
  }

  Widget _buildExpandButton(AppTheme theme) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Transform.rotate(
            angle: pi / 2,
            child: SvgPicture.asset(
              'assets/images/backarrow.svg',
              color: theme.accentColor,
              width: 32.pw,
              height: 32.ph,
              fit: BoxFit.cover,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(24.pw),
        onTap: () {
          expanded = true;
          setState(() {});
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, AppTheme theme) {
    bool isMe = myID == message.fromPlayer;
    String text = message.text;
    if (text != null) {
      text = text.replaceFirst('LOCAL:', '');
    }

    List<Widget> bubble = [];

    if (isMe) {
      if (text != null) {
        bubble.add(Text(
          text,
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ));
        bubble.add(SizedBox(width: 10));
        bubble.add(Text(
          message.fromName.toString(),
          style: AppDecorators.getSubtitle2Style(theme: theme)
              .copyWith(color: theme.accentColor),
          softWrap: true,
        ));
      }
    } else {
      if (text != null) {
        bubble.add(Text(
          message.fromName.toString(),
          style: AppDecorators.getSubtitle2Style(theme: theme)
              .copyWith(color: theme.accentColor),
          softWrap: true,
        ));
        bubble.add(SizedBox(width: 10));
        bubble.add(Text(
          text,
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ));
      }
    }

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
              Row(children: bubble),

              // sep
              SizedBox(height: 2),

              // message / gif
              message.text != null
                  ? Container()
                  : AttributedGifWidget(url: message.giphyLink),
              // AppDimensionsNew.getVerticalSizedBox(4),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     // time
              //     Text(
              //       "${AppConstants.CHAT_DATE_TIME_FORMAT.format(message.received.toLocal())}",
              //       style: AppDecorators.getSubtitle3Style(theme: theme),
              //     ),
              //   ],
              // )
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
                  hintText: _appScreenText['typeAMessage'],
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

  double _getGameChatHeight(bool isKeyboardVisible) {
    final height = MediaQuery.of(context).size.height;

    if (isKeyboardVisible) {
      return height * 0.25;
    } else {
      return expanded ? height * 0.75 : height * 0.50;
    }
  }

  Widget _buildMainBody(AppTheme theme) {
    return KeyboardVisibilityBuilder(
      builder: (_, __, bool isKeyboardVisible) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: AppDecorators.bgRadialGradient(theme),
          height: _getGameChatHeight(isKeyboardVisible),
          child: Column(
            children: [
              /* top widgets, new message notifier & close button */
              Stack(
                children: [
                  /* new message notifier */
                  _buildNewMessageNotifier(theme),

                  /* close button */
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      expanded || isKeyboardVisible
                          ? const SizedBox.shrink()
                          : _buildExpandButton(theme),
                      SizedBox(width: 2.pw),
                      _buildCloseButton(theme)
                    ],
                  ),
                ],
              ),

              /* main message area */
              _buildMessageArea(theme),

              /* user input widget */
              _buildUserInputWidget(theme),
            ],
          ),
        );
      },
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
