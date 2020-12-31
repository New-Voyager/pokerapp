import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/bottom_sheet/gif_drawer_sheet.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/widgets/message_item.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/club_message_service.dart';
import 'package:provider/provider.dart';

class MessagesPageView extends StatefulWidget {
  MessagesPageView({
    @required this.clubCode,
  });

  final String clubCode;

  @override
  _MessagesPageViewState createState() => _MessagesPageViewState();
}

class _MessagesPageViewState extends State<MessagesPageView> {
  final TextEditingController _textInputController = TextEditingController();

  AuthModel _authModel;
  Map<String, String> _players;

  void _sendMessage() {
    String text = _textInputController.text.trim();
    _textInputController.clear();

    if (text.isEmpty) return;

    ClubMessageModel _model = ClubMessageModel(
      clubCode: widget.clubCode,
      messageType: MessageType.TEXT,
      text: text,
    );

    ClubMessageService.sendMessage(_model);
  }

  void _sendGif(String url) {
    ClubMessageModel _model = ClubMessageModel(
      clubCode: widget.clubCode,
      messageType: MessageType.GIPHY,
      giphyLink: url,
    );

    ClubMessageService.sendMessage(_model);
  }

  void _openGifDrawer() async {
    String gifUrl = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GifDrawerSheet(),
    );

    if (gifUrl != null) _sendGif(gifUrl);
  }

  _fetchMembers() async {
    List<ClubMemberModel> _clubMembers =
        await ClubInteriorService.getMembers(widget.clubCode);

    _players = Map<String, String>();

    _clubMembers.forEach((member) {
      _players[member.playerId] = member.name;
    });

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    /* this fetches the information regarding the current user */
    AuthService.get().then((value) => _authModel = value);

    /* this function fetches the members of the clubs - to show name corresponding to messages */
    _fetchMembers();
  }

  @override
  void dispose() {
    super.dispose();

    ClubMessageService.closeStream();
  }

  @override
  Widget build(BuildContext context) {
    final separator = const SizedBox(width: 20.0);

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Column(
        children: [
          /* main view to show messages */
          Expanded(
            child: StreamBuilder<List<ClubMessageModel>>(
              stream: ClubMessageService.pollMessages(widget.clubCode),
              builder: (_, snapshot) {
                if (!snapshot.hasData || _players == null)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                if (snapshot.data.isEmpty)
                  return Center(
                    child: Text(
                      'No Messages',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  );

                return ListView.separated(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemBuilder: (_, int index) => MessageItem(
                    messageModel: snapshot.data[index],
                    currentUser: _authModel,
                    players: _players,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 20.0),
                  itemCount: snapshot.data.length,
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
                /* app drawer open icon */
                GestureDetector(
                  onTap: _openGifDrawer,
                  child: Icon(
                    FontAwesomeIcons.icons,
                    color: AppColors.appAccentColor,
                    size: 20.0,
                  ),
                ),

                /* text area - write message here */

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

                /* send message button */
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
      ),
    );
  }
}
