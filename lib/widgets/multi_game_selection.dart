import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/choose_game_new.dart';

class MultiGameSelection extends StatefulWidget {
  final List<GameType> games;
  final List<GameType> existingChoices;
  final int minimumGames;
  final Function onSelect;
  final Function onRemove;
  MultiGameSelection(this.games,
      {Key key,
      this.minimumGames = 2,
      this.existingChoices,
      this.onSelect,
      this.onRemove})
      : super(key: key);

  @override
  _MultiGameSelectionState createState() => _MultiGameSelectionState();
}

class _MultiGameSelectionState extends State<MultiGameSelection> {
  List<GameType> list = [];
  @override
  void initState() {
    super.initState();
    if (widget.games.length <= widget.minimumGames) {
      list.addAll(widget.games);
      widget.onSelect(widget.games);
    } else if (widget.existingChoices != null) {
      list.addAll(widget.existingChoices);
      widget.onSelect(widget.existingChoices);
    } else {
      list.addAll([widget.games[0], widget.games[1]]);
      widget.onSelect([widget.games[0], widget.games[1]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gameTypeChips = [];
    widget.games.forEach((game) {
      gameTypeChips.add(GameTypeChip(
        gameType: game,
        selected: list.contains(game),
        onTapFunc: (val) {
          if (val) {
            list.add(game);
            widget.onSelect([game]);
          } else {
            if (list.length <= widget.minimumGames) {
              toast("Minimum ${widget.minimumGames} game types required");
              return;
            }
            list.remove(game);
            widget.onRemove(game);
          }
          setState(() {});
        },
      ));
    });
    return Wrap(
      spacing: 4,
      children: gameTypeChips,
    );
  }
}
