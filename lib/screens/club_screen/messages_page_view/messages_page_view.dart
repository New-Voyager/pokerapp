import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/app/club_message_service.dart';

class MessagesPageView extends StatefulWidget {
  MessagesPageView({
    @required this.clubCode,
  });

  final String clubCode;

  @override
  _MessagesPageViewState createState() => _MessagesPageViewState();
}

class _MessagesPageViewState extends State<MessagesPageView> {
  final ClubMessageModel _model = ClubMessageModel();

  final TextEditingController _textInputController = TextEditingController();

  _sendMessage() {
    String text = _textInputController.text.trim();
    _textInputController.clear();

    if (text.isEmpty) return;

    _model.clubCode = widget.clubCode;
    _model.messageType = MessageType.TEXT;
    _model.text = text;

    ClubMessageService.sendMessage(_model);
  }

  @override
  void dispose() {
    super.dispose();

    ClubMessageService.closeStream();
  }

  @override
  Widget build(BuildContext context) {
    final separator = const SizedBox(width: 20.0);

    return Column(
      children: [
        /* main view to show messages */
        Expanded(
          child: StreamBuilder<List<ClubMessageModel>>(
            stream: ClubMessageService.pollMessages(widget.clubCode),
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              final List<ClubMessageModel> messages = snapshot.data;

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemBuilder: (_, int index) => Container(
                  child: Text(
                    messages[index].text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                itemCount: messages.length,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.icons,
                color: AppColors.appAccentColor,
                size: 20.0,
              ),
              separator,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: AppColors.cardBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _textInputController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          color: AppColors.contentColor,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              separator,
              GestureDetector(
                onTap: _sendMessage,
                child: Icon(
                  FontAwesomeIcons.play,
                  color: AppColors.appAccentColor,
                  size: 20.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
