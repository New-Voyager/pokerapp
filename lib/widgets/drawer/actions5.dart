import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/drawer/widgets.dart';
import 'package:pokerapp/widgets/switch_widget.dart';

class Actions5Widget extends StatefulWidget {
  final GameState gameState;
  const Actions5Widget({Key key, @required this.gameState}) : super(key: key);

  @override
  _Actions5WidgetState createState() => _Actions5WidgetState();
}

class _Actions5WidgetState extends State<Actions5Widget> {
  AppTextScreen text;
  bool closed = false;

  @override
  void initState() {
    text = getAppTextScreen("drawerMenu");
    super.initState();
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (widget.gameState.gameInfo.utgStraddleAllowed) {
      children.add(SwitchWidget2(
        label: text['autoUTGStraddle'],
        onChange: (val) {},
      ));
    }
    children.addAll([
      SwitchWidget2(
        label: text['runItTwice'],
        value: widget.gameState.playerSettings.runItTwiceEnabled,
        onChange: (val) async {
          widget.gameState.playerSettings.runItTwiceEnabled = val;
          // updte the server
          await updateGamePlayerSettings();
          if (closed) return;
          setState(() {});
        },
      ),
      SwitchWidget2(
        label: text['checkFold'],
        value: widget.gameState.playerLocalConfig.showCheckFold,
        onChange: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.showCheckFold = val;
          if (closed) return;
          setState(() {});
        },
      ),
      SwitchWidget2(
        label: text['colorCards'],
        value: widget.gameState.playerLocalConfig.colorCards,
        onChange: (val) {
          widget.gameState.playerLocalConfig.colorCards = val;
          if (closed) return;
          setState(() {});
          widget.gameState.tableState.notifyAll();
          widget.gameState.tableState.refreshCommunityCards(colorCards: val);
          widget.gameState.redrawFooter();
        },
      ),
      SwitchWidget2(
        label: text['animations'],
        value: widget.gameState.playerLocalConfig.animations,
        onChange: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.animations = val;
          if (closed) return;
          setState(() {});
        },
      ),
      SwitchWidget2(
        label: text['vibration'],
        value: widget.gameState.playerLocalConfig.vibration,
        onChange: (val) {
          widget.gameState.playerLocalConfig.vibration = val;
          if (closed) return;
          setState(() {});
          widget.gameState.communicationState.notify();
        },
      ),
      SwitchWidget2(
        label: text['chat'],
        value: widget.gameState.playerLocalConfig.showChat,
        onChange: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.showChat = val;
          if (closed) return;
          setState(() {});
        },
      ),
      SwitchWidget2(
        label: 'Participate in Bomb Pot',
        value: widget.gameState.playerSettings.bombPotEnabled,
        onChange: (val) async {
          // setting the value saves it to local storage too
          widget.gameState.playerSettings.bombPotEnabled = val;
          if (closed) return;
          setState(() {});
          await updateGamePlayerSettings();
          if (closed) return;
          setState(() {});
        },
      ),
    ]);

    children.add(SwitchWidget2(
      label: text['rearrangeOption'],
      onChange: (val) {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.showRearrange = val;
        setState(() {});
      },
    ));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [...children],
      ),
    );
  }

  Future<void> updateGamePlayerSettings() async {
    final res = await GameSettingsService.updateGamePlayerSettings(
        widget.gameState.gameCode, widget.gameState.playerSettings);
    if (res) {
      Alerts.showNotification(titleText: "Settings updated!");
    }
  }
}
