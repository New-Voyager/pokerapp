import 'package:flutter/material.dart';
import 'package:pokerapp/models/messages_from_member.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/services/app/clubs_service.dart';

class ClubChat extends StatefulWidget {
  ClubChat({@required this.clubCode, this.player});
  final String clubCode;
  final String player;
  @override
  _ClubChatState createState() => _ClubChatState();
}

class _ClubChatState extends State<ClubChat> {
  TextEditingController controller = TextEditingController();
  double width, height;
  List<String> messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ClubsService.markMemberRead(
        clubCode: widget.clubCode, player: widget.player);
  }

  scrollToBottomOfChat({int waitTime = 1, int scrollTime = 1}) {
    Future.delayed(Duration(milliseconds: waitTime), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: scrollTime),
          curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColorsNew.screenBackgroundColor,
      appBar: getappBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<MessagesFromMember>>(
                  future: ClubsService.memberMessages(
                      clubCode: widget.clubCode, player: widget.player),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    scrollToBottomOfChat(scrollTime: 1, waitTime: 10);
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        bool isHost =
                            snapshot.data[index].messageType == "FROM_HOST";
                        return Align(
                          alignment:
                              snapshot.data[index].messageType == "FROM_HOST"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: isHost
                                  ? AppColorsNew.chatMeColor
                                  : AppColorsNew.chatOthersColor,
                            ),
                            margin: EdgeInsets.only(
                                left: isHost ? 80 : 20,
                                right: isHost ? 20 : 80,
                                top: 5,
                                bottom: 5),
                            child: Text(snapshot.data[index].text),
                          ),
                        );
                      },
                    );
                  }),
            ),
            inputBox(),
          ],
        ),
      ),
    );
  }

  inputBox() {
    return Container(
      color: AppColorsNew.screenBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorsNew.chatInputBgColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      20.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (controller.text.trim() != '') {
                setState(() {
                  ClubsService.sendMessage(
                      controller.text.trim(), widget.player, widget.clubCode);
                  messages.add(controller.text.trim());

                  controller.clear();
                });
                scrollToBottomOfChat();
              }
            },
            child: Icon(
              Icons.send_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  getappBar() {
    return PreferredSize(
      preferredSize: Size(width, 80),
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          elevation: 5,
          child: Container(
            color: AppColorsNew.screenBackgroundColor,
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColorsNew.appAccentColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: Text(
                            "A",
                            style: AppStylesNew.optionTitleText,
                          ),
                        ),
                        Text(
                          "Messages",
                          style: AppStylesNew.credentialsTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
