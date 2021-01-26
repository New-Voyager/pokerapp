import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/hand_table_bar_chart_balance.dart';
import 'package:pokerapp/utils/hand_table_bar_chart_profit.dart';

class TableResultScreen extends StatefulWidget {
  final String gameCode;
  final int playerWidth = 15;
  final int sessionWidth = 20;
  final int numHandsWidth = 15;
  final int buyInWidth = 15;
  final int profitWidth = 15;
  final int rakeWidth = 15;
  TableResultScreen(this.gameCode);

  @override
  State<StatefulWidget> createState() {
    return _TableResultScreenState();
  }
}

class _TableResultScreenState extends State<TableResultScreen> {
  TableRecord data;

  final SizedBox seprator = SizedBox(
    height: 20.0,
  );

  Map<int, Widget> tableWidgets;
  int _selectedTableWidget = 0;

  _TableResultScreenState();

  void _fetchData() async {
    this.data = await GameService.getGameTableRecord(widget.gameCode);
    print(this.data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  double getTotalRake() {
    if (this.data == null || this.data.rows == null) {
      return 0.0;
    }
    return this.data.rows.fold(
        0.0, (previousValue, element) => previousValue + element.rakePaid);
  }

  initializeTableWidgets() {
    tableWidgets = const <int, Widget>{
      0: Text("Table"),
      1: Text("Graph"),
    };
  }

  Widget getTableOrGraphView(context, int index) {
    Map<int, Widget> segmentedViews = <int, Widget>{
      0: Expanded(
        child: this.data == null
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: this.data.rows.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 70.0,
                      margin: EdgeInsets.all(10),
                      color: Color(0xff313235),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              flex: widget.playerWidth,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Player",
                                    style: TextStyle(color: Color(0xffef9712)),
                                  ))),
                          Expanded(
                              flex: widget.sessionWidth,
                              child: Center(
                                  child: Text(
                                "Session",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.numHandsWidth,
                              child: Center(
                                  child: Text(
                                "#Hands",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.buyInWidth,
                              child: Center(
                                  child: Text(
                                "Buyin",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.profitWidth,
                              child: Center(
                                  child: Text(
                                "Profit",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.rakeWidth,
                              child: Center(
                                  child: Text(
                                "Rake",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                        ],
                      ),
                    );
                  } else {
                    int dataIdx = index - 1;
                    return Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: widget.playerWidth,
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  this.data.rows[dataIdx].playerName,
                                  style: TextStyle(color: Color(0xffa09f9e)),
                                )),
                          ),
                          Expanded(
                            flex: widget.sessionWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].sessionTimeStr,
                              style: TextStyle(color: Color(0xffa09f9e)),
                            )),
                          ),
                          Expanded(
                            flex: widget.numHandsWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].handsPlayed.toString(),
                              style: TextStyle(color: Color(0xffa09f9e)),
                            )),
                          ),
                          Expanded(
                            flex: widget.buyInWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].buyIn.toString(),
                              style: TextStyle(color: Color(0xffa09f9e)),
                            )),
                          ),
                          Expanded(
                            flex: widget.profitWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].profit.toString(),
                              style: TextStyle(color: Color(0xff1aff22)),
                            )),
                          ),
                          Expanded(
                            flex: widget.rakeWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].rakePaid.toString(),
                              style: TextStyle(color: Color(0xffef9712)),
                            )),
                          ),
                        ],
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  if (index == 0) {
                    return Container();
                  } else {
                    return Divider(
                      color: Color(0xff707070),
                    );
                  }
                },
              ),
      ),
      1: Expanded(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: HandTableBarChartProfit(this.data),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: HandTableBarChartBalance(this.data),
              ),
            ],
          ),
        ),
      ),
    };

    return segmentedViews[index];
  }

  @override
  Widget build(BuildContext context) {
    initializeTableWidgets();
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 14,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text(
          "Game Details",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.appAccentColor,
            fontSize: 14.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Table Record",
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 5, right: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Game Code: " + widget.gameCode,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: AppColors.lightGrayTextColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 15.0, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Rake",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            getTotalRake().toString(),
                            style: TextStyle(color: Color(0xff1aff22)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/gamesettings/gambling.svg',
                            color: Color(0xffef9712),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "5",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Download",
                            style: TextStyle(color: Color(0xff319ffe)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoSegmentedControl<int>(
                        unselectedColor: AppColors.screenBackgroundColor,
                        selectedColor: AppColors.appAccentColor,
                        children: tableWidgets,
                        borderColor: AppColors.appAccentColor,
                        onValueChanged: (int val) {
                          setState(() {
                            _selectedTableWidget = val;
                          });
                        },
                        groupValue: _selectedTableWidget,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: getTableOrGraphView(context, _selectedTableWidget),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
