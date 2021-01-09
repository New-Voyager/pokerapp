import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/hand_history/hand_history_widget.dart';

class HandHistoryListView extends StatefulWidget {
  final HandHistoryListModel data;
  HandHistoryListView(this.data);

  @override
  _HandHistoryState createState() => _HandHistoryState();
}

class _HandHistoryState extends State<HandHistoryListView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("High History"),
        bottom: PreferredSize(
          child: Column(
            children: [
              Text(
                "Game Code:" + "ABCDE",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              TabBar(
                unselectedLabelColor: Color(0xff319ffe),
                labelColor: Colors.white,
                tabs: [
                  new Tab(
                    icon: SvgPicture.asset(
                      'assets/images/casino.svg',
                      color: Colors.white,
                    ),
                    text: "All Hands",
                  ),
                  new Tab(
                    icon: SvgPicture.asset(
                      'assets/images/casino.svg',
                      color: Colors.white,
                    ),
                    text: "Winning Hands",
                  ),
                  new Tab(
                    icon: SvgPicture.asset(
                      'assets/images/casino.svg',
                      color: Colors.white,
                    ),
                    text: "Hands",
                  ),
                ],
                controller: _tabController,
              ),
            ],
          ),
          preferredSize: Size(100.0, 80.0),
        ),
        backgroundColor: AppColors.screenBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: TabBarView(
        children: [
          getList(),
          getList(),
          getList(),
        ],
        controller: _tabController,
      ),
    );
  }

  getList() {
    return Column(
      children: [
        HandHistoryWidget(),
        HandHistoryWidget(
          number: "124",
          name: "Aditya",
          ended: "Flop",
          showCards: false,
        ),
      ],
    );
  }
}
