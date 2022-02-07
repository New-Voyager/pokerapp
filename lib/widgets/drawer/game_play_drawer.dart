import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/store_dialog.dart';
import 'package:pokerapp/widgets/drawer/actions1.dart';
import 'package:pokerapp/widgets/drawer/actions2.dart';
import 'package:pokerapp/widgets/drawer/actions3.dart';
import 'package:pokerapp/widgets/drawer/actions4.dart';
import 'package:pokerapp/widgets/drawer/actions5.dart';
import 'package:pokerapp/widgets/list_tile.dart';

class GamePlayScreenDrawer extends StatefulWidget {
  final GameState gameState;
  const GamePlayScreenDrawer({Key key, this.gameState}) : super(key: key);

  @override
  _GamePlayScreenDrawerState createState() => _GamePlayScreenDrawerState();
}

class _GamePlayScreenDrawerState extends State<GamePlayScreenDrawer> {
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("drawerMenu");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.getTheme(context);

    List<Widget> children = [];

    children.add(
      IconWidgetTile(
        icon: Icons.shopping_cart,
        title: 'Store',
        onPressed: () async {
          Navigator.of(context).pop();
          StoreDialog.show(context, theme);
        },
      ),
    );
    if (widget.gameState.isPlaying) {
      children.addAll([
        // playing
        DividerWidget(theme: theme),
        Actions1Widget(
          text: _appScreenText,
          gameState: widget.gameState,
        )
      ]);
    }

    if (widget.gameState.currentPlayer.isAdmin()) {
      children.addAll([
        // host/manager
        DividerWidget(theme: theme),
        Actions2Widget(
          text: _appScreenText,
          gameState: widget.gameState,
        ),
        Actions3Widget(
          text: _appScreenText,
          gameState: widget.gameState,
        ),
      ]);
    }
    Widget contents;

    if (widget.gameState.gameInfo.status == AppConstants.GAME_ENDED) {
      contents = Center(child: Text('Game Ended'));
    } else {
      contents = ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  _appScreenText['gameCode'],
                  style: AppDecorators.getSubtitle3Style(theme: theme),
                ),
                Text(
                  "${widget.gameState.gameCode}",
                  style: AppDecorators.getHeadLine4Style(theme: theme)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          ...children,

          // if playihg show the seat change
          DividerWidget(theme: theme),
          Actions4Widget(
            text: _appScreenText,
            gameState: widget.gameState,
          ),

          DividerWidget(theme: theme),
          Actions5Widget(
            gameState: widget.gameState,
          ),
        ],
      );
    }

    return Container(
        padding: EdgeInsets.all(10),
        decoration: AppDecorators.bgRadialGradient(theme),
        child: contents);
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key key,
    @required this.theme,
  }) : super(key: key);

  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: theme.accentColor,
      indent: 16,
      endIndent: 16,
    );
  }
}
