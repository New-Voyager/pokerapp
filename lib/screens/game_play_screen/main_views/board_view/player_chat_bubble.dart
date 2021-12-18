import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:provider/provider.dart';

class PlayerChatBubble extends StatefulWidget {
  final GameContextObject gameContextObject;
  final int playerId;
  PlayerChatBubble(this.gameContextObject, this.playerId, {Key key})
      : super(key: key);

  @override
  _PlayerChatBubbleState createState() => _PlayerChatBubbleState();
}

class _PlayerChatBubbleState extends State<PlayerChatBubble> {
  Timer _messagePopupTimer;
  double giphySize = 32.0;
  AppTheme theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
  }

  @override
  void dispose() {
    super.dispose();
    _messagePopupTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameChatNotifState>(
      builder: (_, gcns, __) {
        if (gcns.showBubble) {
          List<ChatMessage> messages =
              widget.gameContextObject.gameComService.gameMessaging.messages;

          if (messages.length != 0) {
            Iterable<ChatMessage> reversedMessages = messages.reversed;

            ChatMessage chatMessage = reversedMessages.first;

            if (chatMessage != null &&
                chatMessage.fromPlayer == widget.playerId) {
              if (_messagePopupTimer == null || !_messagePopupTimer.isActive) {
                _messagePopupTimer = Timer(Duration(seconds: 10), () {
                  gcns.hideBubble();
                });
              }

              return GestureDetector(
                onTap: () {
                  print("dskfjb");
                  // setState(() {
                  //   giphySize = 64;
                  // });
                },
                child: ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  alignment: Alignment.centerLeft,

                  // margin: EdgeInsets.only(top: 20),
                  backGroundColor: theme.fillInColor,
                  padding: (chatMessage.text != null)
                      ? null
                      : EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 5),
                  shadowColor: theme.accentColor,
                  child: (chatMessage.text != null)
                      ? Text(
                          chatMessage.text,
                          style: TextStyle(color: Colors.white),
                        )
                      : Container(
                          height: giphySize,
                          width: giphySize,
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
              );
            }
          }
        }
        return Text("");
      },
    );
  }
}
