import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/club_action_screens/club_member_detailed_view/club_member_detailed_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';

class NamePlateDailog extends StatefulWidget {
  final GameState gameState;
  final BuildContext gameContext;
  final Seat seat;
  final seatKey;
  const NamePlateDailog(
      {Key key, this.gameState, this.gameContext, this.seatKey, this.seat})
      : super(key: key);

  @override
  _NamePlateDailogState createState() => _NamePlateDailogState();
}

class _NamePlateDailogState extends State<NamePlateDailog> {
  AppTextScreen _appText;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _appText = getAppTextScreen("showPlayerPopup");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchSavedNotes();
    });
    super.initState();
  }

  _fetchSavedNotes() async {
    final savedNotes =
        await GameService.getNotesForUser(widget.seat.player.playerUuid);
    if (savedNotes != null) {
      _controller.text = savedNotes;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.seat.player.name}",
              style: AppDecorators.getHeadLine3Style(theme: theme),
            ),
          ),

          // Buttons Section
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: AppDecorators.tileDecorationWithoutBorder(theme),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.gameState.currentPlayer.isAdmin(),
                      child: IconAndTitleWidget(
                        icon: Icons.ac_unit,
                        text: "Kick",
                        onTap: () async {
                          await PlayerService.kickPlayer(
                              widget.gameState.gameCode,
                              widget.seat.player.playerUuid);
                          Alerts.showNotification(
                              titleText:
                                  _appText['playerWillBeRemovedAfterThisHand'],
                              duration: Duration(seconds: 5));
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.exit_to_app,
                            color: theme.primaryColorWithDark(),
                          ),
                          backgroundColor: theme.accentColor,
                        ),
                      ),
                    ),
                    AppDimensionsNew.getHorizontalSpace(16),
                    IconAndTitleWidget(
                      icon: Icons.ac_unit,
                      text: "Host",
                      onTap: () {
                        Navigator.of(context).pop({"type": "host"});
                        //  _handleLimitButtonClick(context);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.horizontal_split_outlined,
                          color: theme.primaryColorWithDark(),
                        ),
                        backgroundColor: theme.accentColor,
                      ),
                    ),
                    AppDimensionsNew.getHorizontalSpace(16),
                    Visibility(
                      visible: widget.gameState.currentPlayer.isAdmin(),
                      child: IconAndTitleWidget(
                        icon: Icons.ac_unit,
                        text: "Mute",
                        onTap: () {},
                        child: CircleAvatar(
                          child: Icon(
                            Icons.volume_mute,
                            color: theme.primaryColorWithDark(),
                          ),
                          backgroundColor: theme.accentColor,
                        ),
                      ),
                    ),
                    AppDimensionsNew.getHorizontalSpace(16),
                    Visibility(
                      visible: widget.gameState.currentPlayer.isAdmin(),
                      child: IconAndTitleWidget(
                        icon: Icons.home_repair_service_outlined,
                        text: "Limit",
                        onTap: () {
                          Navigator.of(context).pop({"type": "buyin"});
                          //  _handleLimitButtonClick(context);
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.account_balance_rounded,
                            color: theme.primaryColorWithDark(),
                          ),
                          backgroundColor: theme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Avaialable: "),
                    NumDiamondWidget(widget.gameState.gameHiveStore)
                  ],
                ),
              ],
            ),
          ),

          // Animation section
          Visibility(
            visible: widget.gameState.gameSettings.funAnimations ?? true,
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: ProfilePopup(),
            ),
          ),

          // Notes Section
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: AppDecorators.tileDecorationWithoutBorder(theme),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note,
                          color: AppColorsNew.labelColor,
                        ),
                        AppDimensionsNew.getHorizontalSpace(8),
                        Text(
                          _appText['notes'],
                          style: AppStylesNew.labelTextStyle,
                        ),
                      ],
                    ),
                    RoundRectButton(
                      text: _appText['save'],
                      theme: theme,
                      onTap: () async {
                        final res = await GameService.setNotesForUser(
                            widget.seat.player.playerUuid,
                            _controller.text.trim());
                        if (res) {
                          Alerts.showNotification(
                            titleText: _appText['notesSaved'],
                          );
                        }
                        Navigator.of(context).pop(_controller.text);
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: _appText['enterTextHere'],
                        fillColor: AppColorsNew.actionRowBgColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      minLines: 4,
                      maxLines: 6,
                    ),
                    AppDimensionsNew.getVerticalSizedBox(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // RoundedColorButton(
                        //   text: _appText['cancel'],
                        //   textColor: theme.secondaryColorWithLight(),
                        //   backgroundColor: Colors.transparent,
                        //   borderColor: theme.secondaryColor,
                        //   onTapFunction: () => Navigator.of(context).pop(),
                        // ),
                      ],
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
