import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/choose_game_new.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget child;
  final List<Widget> children;
  final AppTheme theme;

  DecoratedContainer({this.child, this.children, this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 15.0,
      ),
      decoration: BoxDecoration(
        color: theme.fillInColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: children != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
          : child,
    );
  }
}

class DecoratedContainer2 extends StatelessWidget {
  final Widget child;
  final List<Widget> children;
  final AppTheme theme;

  DecoratedContainer2({this.child, this.children, this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 5.0,
      //   vertical: 5.0,
      // ),
      decoration: BoxDecoration(
        color: theme.fillInColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: children != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
          : child,
    );
  }
}

class AppLabel extends StatelessWidget {
  final String label;
  final AppTheme theme;

  AppLabel(this.label, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        label,
        style: AppDecorators.getHeadLine4Style(theme: theme)
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class GameTypeSelection extends StatefulWidget {
  final List<GameType> selectedGameTypes;
  GameTypeSelection(this.selectedGameTypes);
  @override
  State<GameTypeSelection> createState() =>
      _GameTypeSelectionState(selectedGameTypes);

  // List<GameType> get selectedGames {
  //   List<GameType> ret = [];
  //   ret.addAll(state.list);
  //   log('Selected games: ${ret}');
  //   return ret;
  // }
  // set selectedGames(List<GameType> list) {
  //   state.list.clear();
  //   state.list.addAll(list);
  // }
}

class _GameTypeSelectionState extends State<GameTypeSelection> {
  // List<GameType> list = [];
  final List<GameType> list;

  _GameTypeSelectionState(this.list);

  @override
  void initState() {
    // list = [
    //   GameType.HOLDEM,
    //   GameType.PLO,

    // ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        spacing: 4,
        children: [
          GameTypeChip(
            gameType: GameType.HOLDEM,
            selected: list.contains(GameType.HOLDEM),
            onTapFunc: (val) {
              if (val) {
                list.add(GameType.HOLDEM);
              } else {
                if (list.length <= 1) {
                  return;
                }
                list.remove(GameType.HOLDEM);
              }
              log('selection: ${list}');
              setState(() {});
            },
          ),
          GameTypeChip(
            gameType: GameType.PLO,
            selected: list.contains(GameType.PLO),
            onTapFunc: (val) {
              if (val) {
                list.add(GameType.PLO);
              } else {
                if (list.length <= 1) {
                  return;
                }
                list.remove(GameType.PLO);
              }
              setState(() {});
            },
          ),
          GameTypeChip(
            gameType: GameType.PLO_HILO,
            selected: list.contains(GameType.PLO_HILO),
            onTapFunc: (val) {
              if (val) {
                list.add(GameType.PLO_HILO);
              } else {
                if (list.length <= 1) {
                  return;
                }
                list.remove(GameType.PLO_HILO);
              }
              setState(() {});
            },
          ),
          GameTypeChip(
            gameType: GameType.FIVE_CARD_PLO,
            selected: list.contains(GameType.FIVE_CARD_PLO),
            onTapFunc: (val) {
              if (val) {
                list.add(GameType.FIVE_CARD_PLO);
              } else {
                if (list.length <= 1) {
                  return;
                }
                list.remove(GameType.FIVE_CARD_PLO);
              }
              setState(() {});
            },
          ),
          GameTypeChip(
            gameType: GameType.FIVE_CARD_PLO_HILO,
            selected: list.contains(GameType.FIVE_CARD_PLO_HILO),
            onTapFunc: (val) {
              if (val) {
                list.add(GameType.FIVE_CARD_PLO_HILO);
              } else {
                if (list.length <= 1) {
                  return;
                }
                list.remove(GameType.FIVE_CARD_PLO_HILO);
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
