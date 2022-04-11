import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/utils.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_user_avatar.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/credits.dart';
import 'package:provider/provider.dart';

import '../chat_model.dart';
import 'chat_date.dart';
import 'chat_time.dart';
import 'triangle_painter.dart';

class ChatListWidget extends StatefulWidget {
  final List<ChatModel> chats;
  final bool isHostView;
  final String name;

  const ChatListWidget({
    Key key,
    this.chats,
    this.isHostView,
    this.name,
  }) : super(key: key);

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  AppTheme theme;
  Color myColor;
  Color othersColor;

  @override
  void initState() {
    super.initState();

    theme = context.read<AppTheme>();

    myColor = theme.fillInColor;
    othersColor = theme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      itemCount: widget.chats.length,
      reverse: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        int day = 0;
        if (i == 0) {
          // _previous = null;
        } else {
          day = _dateDiff(i);
        }
        if (i == widget.chats.length - 1) {
          return Column(
            children: [
              ChatDateTime(date: widget.chats[i].messageTime),
              _buildTile(widget.chats[i]),
            ],
          );
        }
        if (day == 0) {
          return _buildTile(widget.chats[i]);
        } else {
          return Column(
            children: [
              _buildTile(widget.chats[i]),
              ChatDateTime(date: widget.chats[i - 1].messageTime),
            ],
          );
        }
      },
    );
  }

  Widget _buildTile(ChatModel message) {
    if (message.chatAdjustmentModel != null)
      return CreditUpdateChatWidget(
        chatAdjustmentModel: message.chatAdjustmentModel,
        message: message,
      );

    bool isSender = _isSender(message.messageType);

    if (!message.isGroupLatest) {
      return Container(
        margin: EdgeInsets.only(
          left: isSender ? 80 : 10,
          right: isSender ? 10 : 80,
          top: 3,
          bottom: 3,
        ),
        child: _buildTextMessage(message),
      );
    }

    if (!isSender) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(message),
          const SizedBox(width: 5.0),
          _buildChatMessage(message),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildChatMessage(message),
        const SizedBox(width: 5.0),
        _buildAvatar(message),
      ],
    );
  }

  Widget _buildAvatar(ChatModel message) {
    String name = 'HOST';
    if (message.messageType != FROM_HOST) {
      name = message.memberName ?? 'A';
    }

    return ChatUserAvatar(
      userId: message.memberID.toString(),
      name: name,
    );
  }

  Widget _buildChatMessage(ChatModel message) {
    bool isSender = _isSender(message.messageType);
    Widget triangle;

    CustomPaint trianglePainer = CustomPaint(
      painter: Triangle(
        isSender ? myColor : othersColor,
      ),
    );

    if (isSender) {
      triangle = Positioned(right: 0, bottom: 0, child: trianglePainer);
    } else {
      triangle = Positioned(left: 0, bottom: 0, child: trianglePainer);
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 3.0),
          child: Stack(
            children: [
              _buildTextMessage(message),
              triangle,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextMessage(ChatModel message) {
    bool isSender = _isSender(message.messageType);
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.70,
          ),
          padding: EdgeInsets.all(
            message.messageType == MessageType.GIPHY ? 0 : 5.0,
          ),
          decoration: AppDecorators.tileDecorationWithoutBorder(theme).copyWith(
            color: isSender ? myColor : othersColor,
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  message.text,
                  style: AppDecorators.getHeadLine4Style(theme: theme),
                ),
              ),
              ChatTimeWidget(
                isSender: isSender,
                date: message.messageTime,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _dateDiff(int index) {
    var dt1 = widget.chats[index].messageTime;
    var dt2 = widget.chats[index - 1].messageTime;
    if (index > 0) {
      return dt1.difference(dt2).inDays;
    }
    return 0;
  }

  bool _isSender(String type) {
    if (widget.isHostView)
      return type == FROM_HOST;
    else
      return type != FROM_HOST;
  }
}

class CreditUpdateChatWidget extends StatelessWidget {
  final CreditUpdateChatModel chatAdjustmentModel;
  final ChatModel message;
  final bool decorator;
  const CreditUpdateChatWidget(
      {Key key,
      @required this.chatAdjustmentModel,
      @required this.message,
      this.decorator = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<AppTheme>();
    final isNeg = chatAdjustmentModel.amount < 0;
    var chips = DataFormatter.chipsFormat(chatAdjustmentModel.amount);
    if (chatAdjustmentModel.type != CreditUpdateType.set &&
        chatAdjustmentModel.amount > 0) {
      chips = '+$chips';
    }
    Color borderColor = Colors.grey;
    if (chatAdjustmentModel.type == CreditUpdateType.deduct) {
      borderColor = Colors.red;
    } else if (chatAdjustmentModel.type == CreditUpdateType.add) {
      borderColor = Colors.green;
    } else if (chatAdjustmentModel.type == CreditUpdateType.fee_credit) {
      borderColor = Colors.green[300];
    } else if (chatAdjustmentModel.type == CreditUpdateType.set) {
      borderColor = Colors.blue[400];
    }

    String suffix = '';
    if (message.updatedBy != null) {
      suffix = message.updatedBy;
      suffix = suffix + '  ';
    }
    suffix = suffix + DataFormatter.dateTimeFormat(chatAdjustmentModel.date);
    Widget content = // main body
        Row(
      children: [
        // Expanded(
        //   child: Center(child: Text(chatAdjustmentModel.type.value)),
        // ),
        Visibility(
          visible: chatAdjustmentModel.oldCredits != null,
          child: Expanded(
            child: Center(
              child: CreditsWidget(
                oldCredits: true,
                credits: chatAdjustmentModel.oldCredits,
                theme: appTheme,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              chips,
              style: TextStyle(
                fontSize: 16.0,
                color: isNeg ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '\u{27AA}',
              style: TextStyle(
                fontSize: 16.0,
                color: appTheme.supportingColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: CreditsWidget(
              credits: chatAdjustmentModel.credits,
              theme: appTheme,
            ),
          ),
        ),
      ],
    );
    if (!decorator) {
      return content;
    }
    return Container(
      decoration: BoxDecoration(
        color: appTheme.fillInColor,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20.0),
        ),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.only(left: 32.0, right: 8.0, top: 8.0),
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 4.0,
        right: 12.0,
        left: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          Divider(
            color: Colors.white,
          ),
          // text
          Text(
            chatAdjustmentModel.text,
            style: TextStyle(fontSize: 12.0),
          ),

          // time
          Align(
              alignment: Alignment.bottomRight,
              child: Text(
                suffix,
                style: const TextStyle(fontSize: 10.0),
              )),
        ],
      ),
    );
  }
}
