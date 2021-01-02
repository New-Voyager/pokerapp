import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class GameHistoryNew extends StatelessWidget {
  final seprator = SizedBox(
    height: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Game History"),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 7,
                  child: gameTypeTile(),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  flex: 3,
                  child: balanceTile(),
                ),
              ],
            ),
            seprator,
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: stackTile(),
                ),
                Flexible(
                  flex: 3,
                  child: resultTile(),
                ),
                Flexible(
                  flex: 3,
                  child: actionTile(),
                ),
              ],
            ),
            seprator,
            highHandTile(),
            seprator,
            listTile(),
          ],
        ),
      ),
    );
  }

  Widget listTile() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
            ),
            title: Text(
              "Hand History",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
            ),
            title: Text(
              "Table Result",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget highHandTile() {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "High Hand is not tracked",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultTile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 135.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Big Win",
                    style: TextStyle(color: Colors.white),
                  ),
                  seprator,
                  Row(
                    children: [
                      Text(
                        "120",
                        style: TextStyle(color: Colors.amber, fontSize: 18.0),
                      ),
                      Text(
                        "hand#2",
                        style:
                            TextStyle(color: Color(0xff848484), fontSize: 13.0),
                      ),
                    ],
                  ),
                  seprator,
                  Text(
                    "Big Loss",
                    style: TextStyle(color: Colors.white),
                  ),
                  seprator,
                  Row(
                    children: [
                      Text(
                        "85",
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 20.0),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "hand#3",
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionTile() {
    return Container(
      height: 135.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Action Stats",
                  style: TextStyle(color: Colors.white),
                ),
                seprator,
                Row(
                  children: [
                    Text(
                      "Hands",
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "14",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stackTile() {
    return Container(
      height: 135.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Stack",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget balanceTile() {
    return Container(
      height: 135.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Balance",
                  style: TextStyle(color: Colors.white),
                ),
                seprator,
                Text(
                  "28",
                  style: TextStyle(color: Colors.amber, fontSize: 20.0),
                ),
                seprator,
                Text(
                  "BuyIn",
                  style: TextStyle(color: Colors.white),
                ),
                seprator,
                Text(
                  "1300",
                  style: TextStyle(color: Colors.amber, fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gameTypeTile() {
    return Container(
      height: 135.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            // color: Color(0xffef9712),
            decoration: BoxDecoration(
              color: Color(0xffef9712),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Limit Heldom 1/2",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      seprator,
                      Text(
                        "45 Hands dealt in 1 hour 33 minutes",
                        style: TextStyle(
                          color: Color(0xff848484),
                        ),
                      ),
                      seprator,
                      Text(
                        "You played 35 minutes",
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                      seprator
                    ],
                  ),
                  Text(
                    "Ended At 12:00 am",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
