import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

const kTextLengthLimit = 30;

class PlayerChatBubble extends StatefulWidget {
  final GameComService gameComService;
  final Seat seat;
  _PlayerChatBubbleState state;

  PlayerChatBubble(this.gameComService, this.seat, {Key key}) : super(key: key);

  void show(bool showBubble, {Offset offset, ChatMessage message}) {
    state.show(showBubble, offset, message);
  }

  SeatPos get seatPos {
    return seat.seatPos;
  }

  @override
  _PlayerChatBubbleState createState() {
    state = _PlayerChatBubbleState();
    return state;
  }
}

class _PlayerChatBubbleState extends State<PlayerChatBubble> {
  Timer _messagePopupTimer;
  double giphySize = 32.0;
  AppTheme theme;
  BoardAttributesObject bao;
  double gifScale = 1.0;
  bool showing = false;
  Offset offset;
  ChatMessage chatMessage;
  bool zoomed = false;
  _PlayerChatBubbleState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    bao = context.read<BoardAttributesObject>();
  }

  @override
  void dispose() {
    super.dispose();
    _messagePopupTimer?.cancel();
  }

  void close() {
    _messagePopupTimer?.cancel();
  }

  void show(bool showBubble, Offset offset, ChatMessage message) {
    _messagePopupTimer?.cancel();
    this.offset = offset;
    this.chatMessage = message;
    gifScale = 1.0;
    if (showBubble) {
      zoomed = false;
      showing = true;

      // start timer
      _messagePopupTimer = Timer(Duration(seconds: 3), () {
        showing = false;
        setState(() {});
      });
    } else {
      showing = false;
    }
    setState(() {});
  }

  bool isRightView() {
    return widget.seat.seatPos.toString().toLowerCase().contains('right');
  }

  String _getModifiedText(String text) {
    if (text.length > kTextLengthLimit) {
      return '${text.substring(0, kTextLengthLimit - 3)}...';
    }
    return text;
  }

  void _onTap() {
    if (zoomed) {
      showing = false;
      setState(() {});
      return;
    }
    // extend time
    _messagePopupTimer.cancel();
    _messagePopupTimer = Timer(Duration(seconds: 8), () {
      showing = false;
      setState(() {});
    });
    zoomed = true;
    setState(() {
      gifScale = 4.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showing || chatMessage == null || offset == null) {
      return const SizedBox.shrink();
    }

    Widget widget = IntrinsicHeight(
      child: IntrinsicWidth(
        child: ChatBubble(
          clipper: ChatBubbleClipper1(
            type: BubbleType.receiverBubble,
          ),
          backGroundColor: theme.secondaryColorWithDark(0.60),
          padding: (chatMessage.text != null)
              ? null
              : const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 20,
                  right: 5,
                ),
          shadowColor: theme.secondaryColorWithDark(0.80),
          child: chatMessage.text != null
              ? Text(
                  _getModifiedText(chatMessage.text),
                  style: TextStyle(color: Colors.white),
                )
              : AnimatedScale(
                  scale: gifScale,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    height: giphySize,
                    child: CachedNetworkImage(
                      imageUrl: chatMessage.giphyLink,
                      cacheManager: ImageCacheManager.instance,
                      placeholder: (_, __) => Center(
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ),
    );

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: InkWell(onTap: _onTap, child: widget),
    );
  }
}
