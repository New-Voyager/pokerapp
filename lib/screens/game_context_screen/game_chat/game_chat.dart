import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_giphys.dart';

import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';
import 'package:provider/provider.dart';

// FIXME: THIS NEEDS TO BE CHANGED AS PER DEVICE CONFIG
const kScrollOffsetPosition = 40.0;

class GameChat extends StatefulWidget {
  final ScrollController scrollController;
  // final BuildContext parentContext;
  final GameMessagingService chatService;
  final Function onChatVisibilityChange;

  GameChat({
    @required this.chatService,
    @required this.onChatVisibilityChange,
    @required this.scrollController,
    // @required this.parentContext,
  });

  @override
  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> {
  GameMessagingService get chatService => widget.chatService;
  ScrollController get _scrollController => widget.scrollController;

  final _textEditingController = TextEditingController();

  int myID = -1;

  // void _onMessage() {
  //   if (mounted) {
  //     // refresh state
  //     setState(() {});

  //     /* if user is scrolled away, we need to notify */
  //     if (_scrollController.offset > kScrollOffsetPosition) {
  //       print('scroll offset: ${_scrollController.offset}');
  //       context.read<GameChatNotifState>().addUnread();
  //     }
  //   } else {
  //     widget.parentContext?.read<GameChatNotifState>()?.addUnread();
  //   }
  // }

  void _init() {
    this.myID = context.read<GameContextObject>().currentPlayer.id;

    // chatService.listen(
    //   onText: (ChatMessage _) => _onMessage(),
    //   onGiphy: (ChatMessage _) => _onMessage(),
    // );

    // _scrollController.addListener(() {
    //   if (_scrollController.offset < kScrollOffsetPosition) {
    //     context.read<GameChatNotifState>().readAll();
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();

    // mark all the messages as read pot frame building
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
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => GameGiphies(chatService),
    );

    _scrollToBottom();
  }

  void _onSendClick() {
    // validates the text message
    final String text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    // send the message
    chatService.sendText(text);

    _textEditingController.clear();

    /* when current user sends any message, scroll to the bottom */
    _scrollToBottom();
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: widget.onChatVisibilityChange,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.arrow_downward_rounded,
            color: AppColors.appAccentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    bool isMe = myID == message.fromPlayer;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          padding: EdgeInsets.all(8),
          decoration: isMe
              ? AppStyles.myMessageDecoration
              : AppStyles.otherMessageDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                message.fromName.toString(),
                style: AppStyles.clubItemInfoTextStyle.copyWith(
                  fontSize: 12,
                ),
                softWrap: true,
              ),
              SizedBox(height: 5),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${AppConstants.CHAT_DATE_TIME_FORMAT.format(message.received.toLocal())}",
                    style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
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
          color: AppColors.chatInputBgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        padding: const EdgeInsets.only(left: 15),
        child: TextField(
          controller: _textEditingController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter text here",
              suffixIcon: GestureDetector(
                onTap: _onEmojiClick,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              )),
        ),
      );

  Widget _buildUserInputWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: AppColors.screenBackgroundColor,
      child: Row(
        children: [
          /* gif drawer button */
          GestureDetector(
            onTap: _onGifClick,
            child: Icon(
              Icons.add_circle_outline,
              size: 25,
              color: Colors.white,
            ),
          ),

          /* main text field */
          Expanded(
            child: Container(
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: _buildTextField(),
            ),
          ),

          /* send button */
          GestureDetector(
            onTap: _onSendClick,
            child: Icon(
              Icons.send_outlined,
              color: Colors.white,
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
      color: AppColors.screenBackgroundColor,
      // padding: EdgeInsets.only(
      //   bottom: MediaQuery.of(context).viewInsets.bottom,
      // ),
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          /* sep */
          const SizedBox(height: 5.0),

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
