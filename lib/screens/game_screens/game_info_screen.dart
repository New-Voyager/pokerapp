import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/single_child_widget.dart';

class GameInfoScreen extends StatefulWidget {
  final GameState gameState;
  GameInfoScreen({Key key, this.gameState}) : super(key: key);

  @override
  _GameInfoScreenState createState() => _GameInfoScreenState();
}

class _GameInfoScreenState extends State<GameInfoScreen> {
  AppTheme theme;
  bool loading = true;
  GameSettings gameSettings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchGameSettings();
    });
  }

  void _fetchGameSettings() async {
    final GameSettings res =
        await GameService.getGameSettings(widget.gameState.gameInfo.gameCode);
    if (res != null) {
      gameSettings = res;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = AppTheme.getTheme(context);
    final gameInfo = widget.gameState.gameInfo;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: AppDecorators.bgRadialGradient(theme),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text(
            "${gameTypeStr(gameTypeFromStr(gameInfo.gameType))} ${gameInfo.smallBlind}/${gameInfo.bigBlind}",
            style: AppDecorators.getHeadLine3Style(theme: theme),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "code: ",
                style: AppDecorators.getSubtitle1Style(theme: theme),
              ),
              Text(
                "${gameInfo.gameCode}",
                style: AppDecorators.getAccentTextStyle(theme: theme)
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          ),
          AppDimensionsNew.getVerticalSizedBox(8),
          Container(
            decoration: AppDecorators.tileDecorationWithoutBorder(theme),
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Running time",
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                    Text(
                      "${DataFormatter.getTimeInHHMMFormat(gameInfo.runningTime)}",
                      style: AppDecorators.getAccentTextStyle(theme: theme)
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Hands Dealt",
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                    Text(
                      "${gameInfo.noHandsPlayed}",
                      style: AppDecorators.getAccentTextStyle(theme: theme)
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDimensionsNew.getVerticalSizedBox(8),
          Expanded(
            child: SingleChildScrollView(
              child: (gameSettings == null || loading)
                  ? Center(child: CircularProgressWidget())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          border: TableBorder.all(
                            color: theme.fillInColor.withOpacity(0.5),
                          ),
                          columnWidths: {
                            0: FixedColumnWidth(
                                MediaQuery.of(context).size.width * 0.6),
                            1: FixedColumnWidth(
                                MediaQuery.of(context).size.width * 0.3),
                          },
                          children: [
                            _buildOneRow(
                                col1: "Buyin",
                                col2:
                                    "${gameInfo.buyInMin}/${gameInfo.buyInMax}"),
                            _buildOneRow(
                                col1: "Run it twice Allowed",
                                col2:
                                    _getYesNo(gameSettings?.runItTwiceAllowed)),
                            _buildOneRow(
                                col1: "Bomb Pot enabled",
                                col2: _getYesNo(gameSettings?.bombPotEnabled)),
                            _buildOneRow(
                                col1: "Bomb Pot Interval",
                                col2:
                                    gameSettings?.bombPotInterval?.toString()),
                            _buildOneRow(
                                col1: "Dual Board Bomb Pot",
                                col2: _getYesNo(
                                    gameSettings?.doubleBoardBombPot)),
                            _buildOneRow(
                                col1: "UTG Straddle Allowed",
                                col2: _getYesNo(gameInfo.utgStraddleAllowed)),
                            _buildOneRow(
                                col1: "Animations",
                                col2: _getYesNo(gameSettings?.funAnimations)),
                            _buildOneRow(
                                col1: "Chat Allowed",
                                col2: _getYesNo(gameSettings?.chat)),
                            _buildOneRow(
                                col1: "Show result",
                                col2: _getYesNo(gameSettings?.showResult)),
                          ],
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Visibility(
                          visible: gameTypeFromStr(gameInfo.gameType) ==
                              GameType.ROE,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ROE Games",
                                style: AppDecorators.getHeadLine4Style(
                                    theme: theme),
                              ),
                              Text(
                                "${HelperUtils.buildGameTypeStrFromListDynamic(gameSettings.roeGames)}",
                                style: AppDecorators.getHeadLine4Style(
                                        theme: theme)
                                    .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: gameTypeFromStr(gameInfo.gameType) ==
                              GameType.DEALER_CHOICE,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dealer Choice Games",
                                style: AppDecorators.getHeadLine4Style(
                                    theme: theme),
                              ),
                              Text(
                                "${HelperUtils.buildGameTypeStrFromListDynamic(gameSettings.dealerChoiceGames)}",
                                style: AppDecorators.getHeadLine4Style(
                                        theme: theme)
                                    .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOneRow({String col1, String col2}) {
    return TableRow(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          col1,
          textAlign: TextAlign.start,
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          col2,
          textAlign: TextAlign.end,
          style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]);
  }

  _getYesNo(bool val) {
    if (val ?? false) {
      return "No";
    }
    return "Yes";
  }
}
