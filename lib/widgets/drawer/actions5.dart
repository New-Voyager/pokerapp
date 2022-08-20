import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/menu_list_tile.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/texts.dart';

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

  Widget straddleWidget(AppTheme theme) {
    if (widget.gameState.gameInfo.utgStraddleAllowed) {
      int straddleChoice = 1;
      if (!widget.gameState.playerSettings.autoStraddle &&
          widget.gameState.playerLocalConfig.straddle) {
        straddleChoice = 1;
      } else if (widget.gameState.playerSettings.autoStraddle &&
          widget.gameState.playerLocalConfig.straddle) {
        straddleChoice = 0;
      } else if (!widget.gameState.playerSettings.autoStraddle &&
          !widget.gameState.playerLocalConfig.straddle) {
        straddleChoice = 2;
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SubTitleText(text: "Straddle Options", theme: theme),
          ),
          Center(
              child: RadioToggleButtonsWidget<String>(
            onSelect: (int index) {
              straddleChoice = index;
              if (straddleChoice == 1) {
                // prompt
                widget.gameState.playerSettings.autoStraddle = false;
                widget.gameState.playerLocalConfig.straddle = true;
              } else if (straddleChoice == 0) {
                // auto straddle
                widget.gameState.playerSettings.autoStraddle = true;
                widget.gameState.playerLocalConfig.straddle = true;
              } else if (straddleChoice == 2) {
                // straddle off
                widget.gameState.playerSettings.autoStraddle = false;
                widget.gameState.playerLocalConfig.straddle = false;
              }
            },
            defaultValue: straddleChoice,
            values: [
              'Auto\nStraddle',
              'Ask\nEverytime',
              'Straddle\nOff',
            ],
          )),
          SizedBox(
            height: 8,
          ),
        ],
      );
      // return MenuListTile(
      //   switchable: true,
      //   title: text['autoUTGStraddle'],
      //   onSwitchChanged: (val) {},
      // );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    AppTheme theme = AppTheme.getTheme(context);

    children.add(straddleWidget(theme));

    final boardAttributes = widget.gameState.getBoardAttributes(context);
    int defaultValue = 0; // horizontal/landscape
    if (!boardAttributes.isOrientationHorizontal) {
      defaultValue = 1; // vertical/portrait
    }
    Widget layout = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SubTitleText(text: "Board Layout", theme: theme),
        ),
        Center(
            child: RadioToggleButtonsWidget<String>(
                defaultValue: defaultValue,
                values: ['Landscape', 'Portrait'],
                onSelect: (int value) async {
                  if (value == 0) {
                    boardAttributes.orientation = BoardOrientation.horizontal;
                  } else if (value == 1) {
                    boardAttributes.orientation = BoardOrientation.vertical;
                  }
                })),
        SizedBox(
          height: 8,
        ),
      ],
    );
    // children.add(layout);

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
          // widget.gameState.tableState.refreshCommunityCards(colorCards: val);
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
