import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:provider/provider.dart';

class PlayerChatBubble extends StatefulWidget {
  final GameComService gameComService;
  final Seat seat;
  GameChatNotifState gcns;
  PlayerChatBubble(
    this.gameComService,
    this.seat,
    this.gcns, {
    Key key,
  }) : super(key: key);

  @override
  _PlayerChatBubbleState createState() => _PlayerChatBubbleState();
}

class _PlayerChatBubbleState extends State<PlayerChatBubble> {
  Timer _messagePopupTimer;
  double giphySize = 32.0;
  AppTheme theme;
  BoardAttributesObject bao;
  double gifScale = 1.0;

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

  bool isRightView() {
    return widget.seat.seatPos.toString().toLowerCase().contains('right');
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> messages = widget.gameComService.gameMessaging.messages;

    if (messages.length != 0) {
      Iterable<ChatMessage> reversedMessages = messages.reversed;
      ChatMessage chatMessage = reversedMessages.first;

      if (chatMessage != null &&
          chatMessage.fromPlayer == widget.seat?.player?.playerId) {
        if (_messagePopupTimer == null || !_messagePopupTimer.isActive) {
          _messagePopupTimer = Timer(Duration(seconds: 10), () {
            gifScale = 1.0;
            widget.gcns.hideBubble();
          });
        }

        return InkWell(
          onTap: () {
            print('i am here');
            setState(() {
              gifScale = 4.0;
            });
          },
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: ChatBubble(
                clipper: ChatBubbleClipper1(
                  type: BubbleType.receiverBubble,
                ),
                backGroundColor: theme.fillInColor,
                padding: (chatMessage.text != null)
                    ? null
                    : const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 20,
                        right: 5,
                      ),
                shadowColor: theme.accentColor,
                child: (chatMessage.text != null)
                    ? Text(
                        chatMessage.text,
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
        );
      }
    }

    return const SizedBox.shrink();
  }
}
