import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/services/data/game_log_store.dart';

class DebugLogView extends StatefulWidget {
  final String gameCode;

  DebugLogView({
    this.gameCode,
  });

  @override
  _DebugLogViewState createState() => _DebugLogViewState();
}

class _DebugLogViewState extends State<DebugLogView> {
  bool loading = true;
  GameLog log;
  @override
  void initState() {
    loading = true;
    log = getDebugLogger(widget.gameCode);
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: log.logs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${log.logs[index]}'),
        );
      },
    );
  }
}
