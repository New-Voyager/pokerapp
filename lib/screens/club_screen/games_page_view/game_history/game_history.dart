import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class GameHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Game History"),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          getUpperData(),
        ],
      ),
    );
  }

  final seprator = SizedBox(
    height: 10.0,
  );

  Widget getUpperData() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 250.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.0,
              decoration: BoxDecoration(
                color: Color(0xffef9712),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppDimensions.cardRadius),
                ),
              ),
            ),
            Flexible(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NLH 1 / 2",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    seprator,
                    Text(
                      "Ended at 12/10 12:30 PM  ${'\t' * 9} Started by Al Pacino",
                      style: TextStyle(
                        color: Color(0xff848484),
                        // fontWeight: FontWeight.bold,
                        // fontSize: 20.0,
                      ),
                    ),
                    seprator,
                    Text("Run Time: 12:30",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("Session Time: 5:34",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("#Hands: 223",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("#Hands Played: 124",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("#Hands Won: 13",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("Big Win: 125 ",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
