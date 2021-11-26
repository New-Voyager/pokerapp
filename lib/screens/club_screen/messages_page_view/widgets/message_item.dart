import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/utils.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_time.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_user_avatar.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view2.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/widgets/attributed_gif_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';

import '../../../chat_screen/widgets/triangle_painter.dart';
import '../club_chat_model.dart';

class MessageItem extends StatelessWidget {
  final ClubChatModel messageModel;
  final AuthModel currentUser;
  final Map<String, String> players;

  bool clubMessage = false;
  String text = '';

  MessageItem({
    @required this.messageModel,
    @required this.currentUser,
    @required this.players,
  });

  // final Color myColor = theme.fillInColor;
  // final Color othersColor = theme.primaryColor;

  final double extraPadding = 80.0;
  @override
  Widget build(BuildContext context) {
    /* ui */

    bool isMinified = false;
    bool isMe = currentUser.uuid == messageModel.sender;

    final theme = AppTheme.getTheme(context);
    text = messageModel.text;

    if (messageModel.messageType == MessageType.JOIN_CLUB ||
        messageModel.messageType == MessageType.KICKED_OUT ||
        messageModel.messageType == MessageType.LEAVE_CLUB) {
      isMe = false;
      clubMessage = true;
      // return _buildClubMessage(context, theme, messageModel);
      if (messageModel.messageType == MessageType.JOIN_CLUB) {
        text = '${messageModel.playerName} joined the club';
        isMinified = true;
      }
      if (messageModel.messageType == MessageType.KICKED_OUT) {
        text = '${messageModel.playerName} is kicked out';
        isMinified = true;
      }
      if (messageModel.messageType == MessageType.LEAVE_CLUB) {
        text = '${messageModel.playerName} left the club';
        isMinified = true;
      }
    }
    if (isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTile(context, isMe, messageModel.isGroupLatest, theme),
          SizedBox(width: 5),
          _buildAvatar(theme),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        clubMessage ? Container() : _buildAvatar(theme),
        SizedBox(width: 5),
        _buildTile(
          context,
          isMe,
          messageModel.isGroupLatest,
          theme,
          isMinified: isMinified,
        ),
      ],
    );
  }

  Widget _buildAvatar(AppTheme theme) {
    if (messageModel.isGroupLatest)
      return ChatUserAvatar(
        name: players[messageModel.sender ?? ''] ?? 'Somebody',
        userId: messageModel.sender ?? '',
      );
    return SizedBox();
  }

  Widget _buildTile(
    BuildContext context,
    bool isMe,
    bool isGroupLatest,
    AppTheme theme, {
    final bool isMinified = false,
  }) {
    Widget triangle;

    CustomPaint trianglePainer = CustomPaint(
      painter: Triangle(
        isMe ? theme.fillInColor : theme.primaryColor,
      ),
    );

    if (isMe) {
      triangle = Positioned(right: 0, bottom: 0, child: trianglePainer);
    } else {
      triangle = Positioned(left: 0, bottom: 0, child: trianglePainer);
    }

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isGroupLatest && !clubMessage) triangle,
          isMinified
              ? IntrinsicWidth(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // main event
                        Text(
                          '$text',
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                          textAlign: TextAlign.center,
                        ),

                        // timestamp
                        Text(
                          '${dateString(messageModel.messageTime)}\n',
                          style: AppDecorators.getSubtitle3Style(theme: theme)
                              .copyWith(
                            fontSize: 6.dp,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    left: !isGroupLatest ? 20 : 0,
                    right: !isGroupLatest ? 20 : 0,
                  ),
                  child: _buildMessage(context, isMe, theme),
                ),
        ],
      ),
    );
  }

  Widget _buildSharedHand(BuildContext context, bool isMe, AppTheme theme) {
    final playerName = players[messageModel.sender ?? ''] ?? 'Somebody';
    log('player: ${messageModel.sender} isMe: $isMe name: $playerName ${messageModel.text}');
    String gameStr = messageModel.sharedHand.gameTypeStr;
    if (gameStr == 'HOLDEM') {
      gameStr = 'No Limit Holdem';
    } else if (gameStr == 'PLO') {
      gameStr = 'PLO';
    } else if (gameStr == 'PLO_HILO') {
      gameStr = 'PLO Hi-Lo';
    } else if (gameStr == 'FIVE_CARD_PLO_HILO') {
      gameStr = '5-Card Hi-Lo PLO';
    } else if (gameStr == 'FIVE_CARD_PLO') {
      gameStr = '5-Card PLO';
    }
    log("DATA:  ${messageModel.sharedHand.data}");

    // id: handLog.myInfo.id,
    // uuid: handLog.myInfo.uuid,
    // name: handLog.myInfo.name,
    final playerInfo = {
      'id': messageModel.sharedHand.sharedByPlayerId,
      'uuid': messageModel.sharedHand.sharedByPlayerUuid,
      'name': messageModel.sharedHand.sharedByPlayerName
    };
    // log("TIME : ${DateTime.fromMillisecondsSinceEpoch(messageModel.messageTimeInEpoc)}");
    // log("TIME : ${DateTime.now().millisecondsSinceEpoch}");

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(
        right: isMe ? 0.0 : extraPadding,
        left: isMe ? extraPadding : 0.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: isMe ? theme.fillInColor : theme.primaryColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: playerName,
                        style: AppDecorators.getAccentTextStyle(theme: theme),
                        children: [
                          TextSpan(
                            text: " shared a hand",
                            style:
                                AppDecorators.getSubtitle2Style(theme: theme),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "($gameStr)",
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CircleImageButton(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(Routes.hand_log_view, arguments: {
                        "gameCode": messageModel.sharedHand.gameCode,
                        "handNum": messageModel.sharedHand.handNum,
                        "clubCode": messageModel.clubCode,
                      });
                    },
                    icon: Icons.format_align_justify_rounded,
                    theme: theme,
                  ),
                  SizedBox(width: 5),
                  CircleImageButton(
                    theme: theme,
                    icon: Icons.replay,
                    onTap: () {
                      ReplayHandDialog.show(
                        context: context,
                        gameCode: messageModel.sharedHand.gameCode,
                        handNumber: messageModel.sharedHand.handNum,
                        playerID: playerInfo['id'],
                      );
                    },
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          PotWinnersView(
            HandResultData.fromJson(
              messageModel.sharedHand.data,
            ),
            0,
            isMessageItem: true,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChatTimeWidget(
                  date: messageModel.messageTime,
                  isSender: isMe,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, bool isMe, AppTheme theme) {
    final playerName = players[messageModel.sender ?? ''] ?? 'Somebody';
    log('player: ${messageModel.sender} isMe: $isMe name: $playerName ${messageModel.text}');
    if (messageModel.messageType == MessageType.HAND) {
      return _buildSharedHand(context, isMe, theme);
    }

    AppTextScreen _appScreenText = getAppTextScreen("global");
    Alignment alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    Color tileColor = isMe ? theme.fillInColor : theme.primaryColor;

    if (clubMessage) {
      tileColor = theme.accentColorWithDark(0.3);
      alignment = Alignment.center;
    }
    return Align(
      alignment: alignment,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.70,
          ),
          padding: EdgeInsets.all(
            messageModel.messageType == MessageType.GIPHY ? 0 : 5.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: tileColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (messageModel.isGroupFirst)
                if (!clubMessage)
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      isMe ? _appScreenText['you'] : playerName,
                      style: AppDecorators.getAccentTextStyle(theme: theme)
                          .copyWith(
                              fontWeight: FontWeight.normal, fontSize: 10.dp),
                    ),
                  ),
              messageModel.messageType == MessageType.GIPHY
                  ? GiphyImageWidget(
                      imgUrl: messageModel.giphyLink,
                      date: messageModel.messageTime,
                      isMe: isMe,
                    )
                  : Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        text,
                        style: AppDecorators.getHeadLine4Style(theme: theme),
                      ),
                    ),

              /* show the message time */
              if (messageModel.messageType != MessageType.GIPHY)
                SizedBox(height: 3),
              if (messageModel.messageType != MessageType.GIPHY)
                ChatTimeWidget(
                  isSender: isMe,
                  date: messageModel.messageTime,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GiphyImageWidget extends StatelessWidget {
  final String imgUrl;
  final DateTime date;
  final bool isMe;

  const GiphyImageWidget({
    Key key,
    this.imgUrl,
    this.date,
    this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          AttributedGifWidget(url: imgUrl),
          Positioned(
            right: 0,
            bottom: 0,
            child: ChatTimeWidget(
              isSender: isMe,
              date: date,
            ),
          ),
        ],
      ),
    );
  }
}
