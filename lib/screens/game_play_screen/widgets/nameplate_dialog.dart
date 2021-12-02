import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class NamePlateDailog extends StatefulWidget {
  final GameState gameState;
  final GameContextObject gameContextObject;
  final BuildContext gameContext;
  final Seat seat;
  final seatKey;
  const NamePlateDailog(
      {Key key,
      this.gameState,
      this.gameContextObject,
      this.gameContext,
      this.seatKey,
      this.seat})
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
    bool playerMuted = false;
    if (widget.gameContextObject.ionAudioConferenceService != null) {
      playerMuted = widget.gameContextObject.ionAudioConferenceService
          .isPlayerMuted(widget.seat.player.streamId);
    }
    bool showCreditLimit = false;
    final gameState = widget.gameState;
    if (gameState.clubInfo != null) {
      if (gameState.clubInfo.trackMemberCredit &&
          (gameState.clubInfo.canUpdateCredits || gameState.clubInfo.isOwner)) {
        showCreditLimit = true;
      }
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${widget.seat.player.name}",
                        style: AppDecorators.getHeadLine1Style(theme: theme),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: NumDiamondWidget(widget.gameState.gameHiveStore),
                  )
                ],
              ),
            ],
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
                        child: CircleImageButton(
                            theme: theme,
                            icon: Icons.remove,
                            caption: "Kick\n",
                            split: true,
                            onTap: () async {
                              final result = await showPrompt(context, "Kick",
                                  "Do you want to remove '${widget.gameState.currentPlayer.name}' from the game?",
                                  positiveButtonText: "Yes",
                                  negativeButtonText: "No");
                              if (result != null) {
                                if (result == true) {
                                  await PlayerService.kickPlayer(
                                      widget.gameState.gameCode,
                                      widget.seat.player.playerUuid);
                                  if (widget.gameState.gameInfo.status ==
                                      AppConstants.GAME_PAUSED) {
                                    // player is removed from the game
                                  } else {
                                    Alerts.showNotification(
                                        titleText: _appText[
                                            'playerWillBeRemovedAfterThisHand'],
                                        duration: Duration(seconds: 5));
                                  }
                                  Navigator.of(context).pop();
                                }
                              }
                            })),
                    SizedBox(width: 16.pw),
                    Visibility(
                        visible: widget.gameState.currentPlayer.isHost(),
                        child: CircleImageButton(
                            theme: theme,
                            icon: Icons.verified_user,
                            caption: 'Assign\nHost',
                            split: true,
                            onTap: () {
                              Navigator.of(context).pop({"type": "host"});
                            })),
                    SizedBox(width: 16.pw),
                    Visibility(
                        visible: widget.gameState.gameInfo
                            .audioConfEnabled, // widget.gameState.currentPlayer.isAdmin(),
                        child: CircleImageButton(
                          onTap: () {
                            widget.gameContextObject.ionAudioConferenceService
                                .muteUnmutePlayer(widget.seat.player.streamId);
                            setState(() {});
                          },
                          icon: playerMuted
                              ? Icons.volume_off
                              : Icons.volume_mute,
                          theme: theme,
                          caption: playerMuted ? 'Unmute\n' : 'Mute\n',
                          split: true,
                        )),
                    SizedBox(width: 16.pw),
                    // Visibility(
                    //   visible: widget.gameState.currentPlayer.isAdmin(),
                    //   child: CircleImageButton(
                    //       theme: theme,
                    //       icon: Icons.home_repair_service_outlined,
                    //       caption: "Buyin\nLimit",
                    //       split: true,
                    //       onTap: () {
                    //         Navigator.of(context).pop({"type": "buyin"});
                    //         //  _handleLimitButtonClick(context);
                    //       }),
                    // ),
                    Visibility(
                      visible: showCreditLimit,
                      child: CircleImageButton(
                          theme: theme,
                          icon: Icons.home_repair_service_outlined,
                          caption: "Change\nCredits",
                          split: true,
                          onTap: () {
                            Navigator.of(context).pop({"type": "credits"});
                            //  _handleLimitButtonClick(context);
                          }),
                    ),
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
