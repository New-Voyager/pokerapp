import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/time_bank.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget_new.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/color_generator.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/listenable.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

const shrinkedBox = const SizedBox.shrink(
  key: ValueKey('none'),
);

class FooterGameActionView extends StatefulWidget {
  final GameState gameState;
  FooterGameActionView({
    this.gameState,
  });

  @override
  _FooterGameActionViewState createState() => _FooterGameActionViewState();
}

class _FooterGameActionViewState extends State<FooterGameActionView> {
  final vnGameStatus = ValueNotifier<String>(null);
  final vnTableStatus = ValueNotifier<String>(null);
  TableState get tableState => widget.gameState.tableState;
  AppTextScreen _appScreenText;

  void tableStateListener() {
    vnGameStatus.value = widget.gameState.tableState.gameStatus;
    vnTableStatus.value = widget.gameState.tableState.tableStatus;
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("centerView");
    tableState.addListener(tableStateListener);
  }

  @override
  void dispose() {
    tableState.removeListener(tableStateListener);
    super.dispose();
  }

  startGame(BuildContext context) async {
    try {
      ConnectionDialog.show(context: context, loadingText: "Starting...");
      await GamePlayScreenUtilMethods.startGame(widget.gameState.gameCode);
      await widget.gameState.refresh();
      ConnectionDialog.dismiss(context: context);
    } catch (err) {
      ConnectionDialog.dismiss(context: context);
      showErrorDialog(context, 'Error',
          'Failed to start the game. Error: ${err.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableState>(
        builder: (_, TableState tableState, __) =>
            ValueListenableBuilder2<String, String>(vnGameStatus, vnTableStatus,
                builder: (_, gameStatus, tableStatus, __) {
              // if table is running, don't show the buttons
              if (widget.gameState.tableState.gameStatus !=
                  AppConstants.GAME_CONFIGURED) {
                return SizedBox.shrink();
              }
              AppTheme appTheme = AppTheme.getTheme(context);
              List<Widget> actionButtons = [];
              actionButtons.add(GameActionButton(
                  theme: appTheme,
                  onTap: () async {
                    await startGame(context);
                  },
                  text: ' Start ',
                  btnColor: Colors.green,
                  icon: Icons.play_arrow));
              actionButtons.add(GameActionButton(
                  theme: appTheme,
                  onTap: () {},
                  text: ' End ',
                  btnColor: Color.fromARGB(255, 208, 91, 83),
                  icon: Icons.close));
              // actionButtons.add(GameActionButton(
              //     theme: appTheme,
              //     onTap: () {},
              //     text: ' Shuffle ',
              //     btnColor: Colors.blueGrey,
              //     icon: Icons.shuffle));
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: actionButtons,
                  ),
                ],
              );
              //return Container(child: Text(tableState.gameStatus.toString()));
            }));

    //return Container(child: Text(tableState.gameStatus.toString()));
  }
}
