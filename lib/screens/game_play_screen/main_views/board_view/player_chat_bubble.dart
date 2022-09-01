import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/utils/utils.dart';

import 'chat_bubble_holder.class.dart';

const kTextLengthLimit = 30;

class PlayerChatBubble extends StatefulWidget {
  final GameComService gameComService;
  final GameState gameState;
  final Seat seat;
  final ValueNotifier<ChatMessage> chatMessageHolder;
  final ChatBubbleHolder chatBubbleHolder;

  PlayerChatBubble({
    @required this.gameState,
    @required this.gameComService,
    @required this.seat,
    @required this.chatMessageHolder,
    @required this.chatBubbleHolder,
    Key key,
  }) : super(key: key);

  @override
  _PlayerChatBubbleState createState() => _PlayerChatBubbleState();
}

class _PlayerChatBubbleState extends State<PlayerChatBubble> {
  double giphySize = 32.0;
  double lottieSize = 24.0;
  AppTheme theme;
  double gifScale = 1.0;
  _PlayerChatBubbleState();

  @override
  void initState() {
    super.initState();
    widget.chatBubbleHolder.overlayRemoved = false;
    theme = AppTheme.getTheme(context);
  }

  // void show(bool showBubble, Offset offset, ChatMessage message) {
  //   _messagePopupTimer?.cancel();
  //   this.offset = offset;
  //   this.chatMessage = message;
  //   gifScale = 1.0;
  //   if (showBubble) {
  //     zoomed = false;
  //     showing = true;
  //
  //     // start timer
  //     _messagePopupTimer = Timer(Duration(seconds: 3), () {
  //       showing = false;
  //       setState(() {});
  //     });
  //   } else {
  //     showing = false;
  //   }
  //   setState(() {});
  // }

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
    log('player_chat_bubble :: InkWell');
    bool closeBubble = false;

    if (widget.chatBubbleHolder.chatMessageHolder != null &&
        widget.chatBubbleHolder.chatMessageHolder.value.text != null &&
        widget.chatBubbleHolder.chatMessageHolder.value.text.length > 0) {
      closeBubble = true;
    }
    if (gifScale == 1.0) {
      setState(() => gifScale = 4.0);
      // todo: increment the time
    } else {
      // todo: cancel
      closeBubble = true;
    }

    if (closeBubble) {
      if (widget.chatBubbleHolder.overlayEntry != null) {
        widget.chatBubbleHolder.overlayEntry.remove();
        widget.chatBubbleHolder.overlayRemoved = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.chatMessageHolder,
      builder: (_, ChatMessage chatMessage, __) {
        if (chatMessage == null) return const SizedBox.shrink();

        log('In chat widget chat visible: ${widget.gameState.chatScreenVisible}');
        // if (widget.gameState.chatScreenVisible) {
        //   return const SizedBox.shrink();
        // }

        // return Container(
        //   width: 100,
        //   height: 100,
        //   color: Colors.red,
        // );

        return Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: GestureDetector(
            onTap: _onTap,
            child: IntrinsicHeight(
              child: IntrinsicWidth(
                child: ChatBubble(
                  clipper: ChatBubbleClipper1(
                    type: BubbleType.receiverBubble,
                  ),
                  backGroundColor: theme.secondaryColorWithDark(0.40),
                  padding: (chatMessage.text != null)
                      ? null
                      : const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 5,
                          right: 5,
                        ),
                  shadowColor: theme.secondaryColorWithDark(0.80),
                  child: chatMessage.type == kStickerMessageType
                      ? Lottie.asset(chatMessage.text, height: lottieSize)
                      : chatMessage.text != null
                          ? Text(
                              _getModifiedText(chatMessage.text),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
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
            ),
          ),
        );
      },
    );
  }
}
