import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_screens/game_info_screen.dart';
import 'package:pokerapp/screens/game_screens/hand_history/hand_history.dart';

class GameInfoBottomSheet extends StatefulWidget {
  final GameState gameState;

  const GameInfoBottomSheet({Key key, this.gameState}) : super(key: key);

  @override
  _GameInfoBottomSheetState createState() => _GameInfoBottomSheetState();
}

class _GameInfoBottomSheetState extends State<GameInfoBottomSheet> {
  double height;

  double ratio = 2;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    height = MediaQuery.of(context).size.height;
    return Container(
      height: height / ratio,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 13,
              ),
              Expanded(
                child: GameInfoScreen(
                  gameState: widget.gameState,
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (ratio == 2) {
                      ratio = 1.5;
                    } else {
                      ratio = 2;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    ratio == 2 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: theme.primaryColorWithDark(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: theme.accentColor),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: theme.primaryColorWithDark(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}