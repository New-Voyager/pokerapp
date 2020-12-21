import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class NewGameSettings extends StatefulWidget {
  @override
  _NewGameSettingsState createState() => _NewGameSettingsState();
}

class _NewGameSettingsState extends State<NewGameSettings> {
  bool straddleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("New Game Settings"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                    text: "Start",
                    onTap: () {},
                  ),
                  Container(
                    width: 120.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextButton(
                          text: "Load",
                          onTap: () {},
                        ),
                        CustomTextButton(
                          text: "Save",
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: firstList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: secondList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: thirdList(),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget thirdList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Location Check",
                style: TextStyle(color: Colors.white),
              ),
              trailing: CupertinoSwitch(
                  value: straddleSwitch,
                  onChanged: (value) {
                    setState(() {
                      straddleSwitch = value;
                    });
                  }),
            ),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "WaitList",
                style: TextStyle(color: Colors.white),
              ),
              trailing: CupertinoSwitch(
                  value: straddleSwitch,
                  onChanged: (value) {
                    setState(() {
                      straddleSwitch = value;
                    });
                  }),
            ),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Don't Show Losing Hand",
                style: TextStyle(color: Colors.white),
              ),
              trailing: CupertinoSwitch(
                  value: straddleSwitch,
                  onChanged: (value) {
                    setState(() {
                      straddleSwitch = value;
                    });
                  }),
            ),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Run it Twice",
                style: TextStyle(color: Colors.white),
              ),
              trailing: CupertinoSwitch(
                  value: straddleSwitch,
                  onChanged: (value) {
                    setState(() {
                      straddleSwitch = value;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget secondList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Game Length",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "4 hours",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Action Time",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "20 seconds",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff313235),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Thursday Night Game",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "No Limit Holdem",
                style: TextStyle(color: Color(0xff848484)),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: null),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Big Blind",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "2.0",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Buy In",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "100/300",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Max Players",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "9",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Club Tips",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "5% or 5 cap",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Straddle(UTG)",
                style: TextStyle(color: Colors.white),
              ),
              trailing: CupertinoSwitch(
                  value: straddleSwitch,
                  onChanged: (value) {
                    setState(() {
                      straddleSwitch = value;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
