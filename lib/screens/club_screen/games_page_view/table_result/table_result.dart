import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/app_colors.dart';

class TableResultScreen extends StatelessWidget {
  final SizedBox seprator = SizedBox(
    height: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("Table Result"),
        bottom: PreferredSize(
          child: Text(
            "Game Code:" + "ABCDE",
            style: TextStyle(color: Colors.white),
          ),
          preferredSize: Size(100.0, 10.0),
        ),
        backgroundColor: AppColors.screenBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          seprator,
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                      "565",
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
          seprator,
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    height: 70.0,
                    color: Color(0xff313235),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Player",
                          style: TextStyle(color: Color(0xffef9712)),
                        ),
                        Text(
                          "Session",
                          style: TextStyle(color: Color(0xffef9712)),
                        ),
                        Text(
                          "#Hands",
                          style: TextStyle(color: Color(0xffef9712)),
                        ),
                        Text(
                          "Buyin",
                          style: TextStyle(color: Color(0xffef9712)),
                        ),
                        Text(
                          "Profit",
                          style: TextStyle(color: Color(0xffef9712)),
                        ),
                        Text(
                          "Rake",
                          style: TextStyle(color: Color(0xffef9712)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Al pacino",
                          style: TextStyle(color: Color(0xffa09f9e)),
                        ),
                        Text(
                          "12:45",
                          style: TextStyle(color: Color(0xffa09f9e)),
                        ),
                        Text(
                          "225",
                          style: TextStyle(color: Color(0xffa09f9e)),
                        ),
                        Text(
                          "300",
                          style: TextStyle(color: Color(0xffa09f9e)),
                        ),
                        Text(
                          "1375",
                          style: TextStyle(color: Color(0xff1aff22)),
                        ),
                        Text(
                          "45",
                          style: TextStyle(color: Color(0xffef9712)),
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
        ],
      ),
    );
  }
}
