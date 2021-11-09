import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/data/game_log_store.dart';

class DebugLogView extends StatefulWidget {
  final String gameCode;
  final bool isBottomSheet;
  DebugLogView({
    this.gameCode,
    this.isBottomSheet,
  });

  @override
  _DebugLogViewState createState() => _DebugLogViewState();
}

class _DebugLogViewState extends State<DebugLogView> {
  bool loading = true;
  ScrollController _scrollController = new ScrollController();

  GameLog debugLog;
  @override
  void initState() {
    loading = true;
    debugLog = getDebugLogger(widget.gameCode);
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: debugLog.logs.length,
      controller: _scrollController,
      //reverse: true,
      //shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${debugLog.logs[index]}'),
          onTap: () {
            showAlertDialog(context, 'log', debugLog.logs[index]);
            //log('Show ${debugLog.logs[index]}');
          },
        );
      },
    );
  }
}
