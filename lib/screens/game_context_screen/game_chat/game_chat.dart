import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_giphys.dart';

import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/widgets/chat_text_field.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';

class GameChat extends StatefulWidget {
  final GameMessagingService chatService;
  final Function chatVisibilityChange;

  GameChat({
    @required this.chatService,
    @required this.chatVisibilityChange,
  });

  @override
  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  void _onGifClick() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => GameGiphies(widget.chatService),
    );
  }

  void _onSendClick() {
    // validates the text message
    final String text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    // send the message
    widget.chatService.sendText(text);

    _textEditingController.clear();
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: widget.chatVisibilityChange,
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
    return Container(
      // TODO: FIX THIS MARGIN
      margin: EdgeInsets.only(
        bottom: 4,
        right: 96,
        left: 8,
      ),
      padding: EdgeInsets.all(8),
      decoration: AppStyles.othersMessageDecoration,
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
                      height: 150,
                      width: 150,
                      placeholder: (_, __) => Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
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
    );
  }

  Widget _buildMessageArea() => Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          reverse: true,
          children: widget.chatService.messages.reversed
              .map((c) => _buildChatBubble(c))
              .toList(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.screenBackgroundColor,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          /* sep */
          const SizedBox(height: 5.0),

          /* close button */
          _buildCloseButton(),

          /* main message area */
          _buildMessageArea(),

          /* user input widget */
          _buildUserInputWidget(),
        ],
      ),
    );
  }
}
