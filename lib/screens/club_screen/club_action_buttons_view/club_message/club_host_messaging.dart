import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/messages_from_member.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/services/app/clubs_service.dart';

import '../../../../routes.dart';

class ClubHostMessaging extends StatefulWidget {
  ClubHostMessaging({@required this.clubCode, this.player, this.name});

  final String clubCode;
  final String player;
  final String name;

  @override
  _ClubChatState createState() => _ClubChatState();
}

class _ClubChatState extends State<ClubHostMessaging> with RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_host_messagng;
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
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        bool isHost =
                            snapshot.data[index].messageType == "FROM_HOST";
                        bool isHostView = widget.player != null;
                        return Align(
                          alignment: isHostView
                              ? isHost
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft
                              : isHost
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: isHostView
                                  ? isHost
                                      ? AppColorsNew.chatMeColor
                                      : AppColorsNew.chatOthersColor
                                  : isHost
                                      ? AppColorsNew.chatOthersColor
                                      : AppColorsNew.chatMeColor,
                            ),
                            margin: EdgeInsets.only(
                                left: isHostView
                                    ? isHost
                                        ? 80
                                        : 20
                                    : isHost
                                        ? 20
                                        : 80,
                                right: isHostView
                                    ? isHost
                                        ? 20
                                        : 80
                                    : isHost
                                        ? 80
                                        : 20,
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
                            widget.name != null
                                ? widget.name[0].toLowerCase()
                                : 'H',
                            style: AppStylesNew.optionTitleText,
                          ),
                        ),
                        Text(
                          widget.name ?? 'Host',
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
