import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_giphys.dart';

import 'package:pokerapp/services/game_play/game_messaging_service.dart';
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

  void _onEmojiClick() async {
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => IntrinsicHeight(
        child: EmojiPickerWidget(
          onEmojiSelected: (String emoji) {
            _textEditingController.text = _textEditingController.text + emoji;
          },
        ),
      ),
    );
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
    /* when current user sends any message, scroll to the bottom */
    _scrollToBottom();

    // validates the text message
    final String text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    // send the message
    chatService.sendText(text);

    _textEditingController.clear();
  }

  Widget _buildCloseButton() => Align(
        alignment: Alignment.topRight,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Transform.rotate(
              angle: -pi / 2,
              child: SvgPicture.asset(
                'assets/images/backarrow.svg',
                color: AppColorsNew.newGreenButtonColor,
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

  Widget _buildChatBubble(ChatMessage message) {
    bool isMe = myID == message.fromPlayer;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: isMe
              ? AppStyles.myMessageDecoration
              : AppStyles.otherMessageDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* name of player & time */
              Row(
                children: [
                  // name
                  Text(
                    message.fromName.toString(),
                    style: AppStyles.clubItemInfoTextStyle.copyWith(
                      fontSize: 12,
                      color: AppColorsNew.newGreenButtonColor,
                    ),
                    softWrap: true,
                  ),

                  // sep
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    color: const Color(0xff848484),
                    height: 10.0,
                    width: 1.0,
                  ),

                  // time
                  Text(
                    "${AppConstants.CHAT_DATE_TIME_FORMAT.format(message.received.toLocal())}",
                    style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

              // sep
              SizedBox(height: 2),

              // message / gif
              message.text != null
                  ? Text(
                      message.text,
                      style: AppStyles.clubCodeStyle,
                    )
                  : message.giphyLink != null
                      ? CachedNetworkImage(
                          imageUrl: message.giphyLink,
                          placeholder: (_, __) => Center(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          fit: BoxFit.cover,
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageArea() => Expanded(
        child: Consumer<GameChatNotifState>(
          builder: (_, gcns, __) => ListView(
            shrinkWrap: true,
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            reverse: true,
            children: widget.chatService.messages.reversed
                .map((c) => _buildChatBubble(c))
                .toList(),
          ),
        ),
      );

  Widget _buildTextField() => Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: EdgeInsets.only(left: 15),
        child: TextField(
          controller: _textEditingController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            hintText: 'Enter text here...',
            suffixIcon: GestureDetector(
              onTap: _onEmojiClick,
              child: Icon(
                Icons.emoji_emotions_outlined,
                size: 25,
                color: AppColorsNew.yellowAccentColor,
              ),
            ),
          ),
        ),
      );

  Widget _buildUserInputWidget() {
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
              color: AppColorsNew.yellowAccentColor,
            ),
          ),

          /* main text field */
          Expanded(
            child: _buildTextField(),
          ),

          /* send button */
          GestureDetector(
            onTap: _onSendClick,
            child: Icon(
              Icons.send_outlined,
              color: AppColorsNew.yellowAccentColor,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewMessageNotifier() => Consumer<GameChatNotifState>(
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
                        color: Colors.red,
                        size: 20.0,
                      ),

                      // sep
                      const SizedBox(width: 5.0),

                      Text(
                        '${gcns.count} new message',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsNew.darkGreenShadeColor,
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
              _buildNewMessageNotifier(),

              /* close button */
              _buildCloseButton(),
            ],
          ),

          /* main message area */
          _buildMessageArea(),

          /* user input widget */
          _buildUserInputWidget(),
        ],
      ),
    );
  }
}
