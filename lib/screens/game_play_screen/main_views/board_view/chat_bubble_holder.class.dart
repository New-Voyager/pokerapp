import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';

class ChatBubbleHolder {
  final ValueNotifier<ChatMessage> chatMessageHolder;
  OverlayEntry overlayEntry;
  Offset offset;
  final SeatPos seatPos;
  Timer timer;

  ChatBubbleHolder({
    @required this.chatMessageHolder,
    @required this.overlayEntry,
    @required this.offset,
    @required this.seatPos,
  });
}
