import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/widgets/switch_widget.dart';

class Actions5Widget extends StatefulWidget {
  const Actions5Widget({Key key}) : super(key: key);

  @override
  _Actions5WidgetState createState() => _Actions5WidgetState();
}

class _Actions5WidgetState extends State<Actions5Widget> {
  AppTextScreen text;

  @override
  void initState() {
    text = getAppTextScreen("drawerMenu");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SwitchWidget(
            label: text['autoButtonStraddle'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['autoUTGStraddle'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['runItTwice'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['checkFold'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['colorCards'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['rearrangeOption'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['animations'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['vibration'],
            onChange: (val) {},
          ),
          SwitchWidget(
            label: text['chat'],
            onChange: (val) {},
          ),
        ],
      ),
    );
  }
}
