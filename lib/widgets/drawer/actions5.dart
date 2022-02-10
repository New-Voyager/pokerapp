import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/menu_list_tile.dart';

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
      children.add(MenuListTile(
        switchable: true,
        title: text['autoUTGStraddle'],
        onSwitchChanged: (val) {},
      ));
    }
    children.addAll([
      MenuListTile(
        title: text['runItTwice'],
        switchable: true,
        switchValue: widget.gameState.playerSettings.runItTwiceEnabled,
        onSwitchChanged: (val) async {
          widget.gameState.playerSettings.runItTwiceEnabled = val;
          // updte the server
          await updateGamePlayerSettings();
          if (closed) return;
          setState(() {});
        },
      ),
      MenuListTile(
        title: text['checkFold'],
        switchValue: widget.gameState.playerLocalConfig.showCheckFold,
        switchable: true,
        onSwitchChanged: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.showCheckFold = val;
          if (closed) return;
          setState(() {});
        },
      ),
      MenuListTile(
        switchable: true,
        title: text['colorCards'],
        switchValue: widget.gameState.playerLocalConfig.colorCards,
        onSwitchChanged: (val) {
          widget.gameState.playerLocalConfig.colorCards = val;
          if (closed) return;
          setState(() {});
          widget.gameState.tableState.notifyAll();
          widget.gameState.tableState.refreshCommunityCards(colorCards: val);
          widget.gameState.redrawFooter();
        },
      ),
      MenuListTile(
        switchable: true,
        title: text['animations'],
        switchValue: widget.gameState.playerLocalConfig.animations,
        onSwitchChanged: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.animations = val;
          if (closed) return;
          setState(() {});
        },
      ),
      MenuListTile(
        switchable: true,
        title: 'Sounds',
        switchValue: widget.gameState.playerLocalConfig.gameSound,
        onSwitchChanged: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.gameSound = val;
          if (closed) return;
          setState(() {});
        },
      ),
      MenuListTile(
        switchable: true,
        title: text['vibration'],
        switchValue: widget.gameState.playerLocalConfig.vibration,
        onSwitchChanged: (val) {
          widget.gameState.playerLocalConfig.vibration = val;
          if (closed) return;
          setState(() {});
          widget.gameState.communicationState.notify();
        },
      ),
      MenuListTile(
        switchable: true,
        title: text['chat'],
        switchValue: widget.gameState.playerLocalConfig.showChat,
        onSwitchChanged: (val) {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.showChat = val;
          if (closed) return;
          setState(() {});
        },
      ),
      MenuListTile(
        switchable: true,
        title: 'Participate in Bomb Pot',
        switchValue: widget.gameState.playerSettings.bombPotEnabled,
        onSwitchChanged: (val) async {
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

    children.add(MenuListTile(
      switchable: true,
      title: 'Muck Losing Hand',
      switchValue: widget.gameState.playerSettings.muckLosingHand,
      onSwitchChanged: (val) async {
        // setting the value saves it to local storage too
        widget.gameState.playerSettings.muckLosingHand = val;
        if (closed) return;
        setState(() {});
        await updateGamePlayerSettings();
        if (closed) return;
        setState(() {});
      },
    ));

    children.add(MenuListTile(
      switchable: true,
      title: 'Show Hand Strength',
      switchValue: widget.gameState.playerLocalConfig.showHandRank,
      onSwitchChanged: (val) {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.showHandRank = val;
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
