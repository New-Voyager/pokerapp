import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/texts.dart';

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
  GameInfoModel gameInfo;
  AppTextScreen appScreenText;

  @override
  void initState() {
    appScreenText = getAppTextScreen("gameInfoScreen");

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchGameSettings();
    });
  }

  void _fetchGameSettings() async {
    final GameSettings res = await GameSettingsService.getGameSettings(
        widget.gameState.gameInfo.gameCode);
    final GameInfoModel gameInfo =
        await GameService.getGameInfo(widget.gameState.gameInfo.gameCode);
    if (res != null) {
      gameSettings = res;
      if (gameInfo != null) {
        this.gameInfo = gameInfo;
      } else {
        this.gameInfo = widget.gameState.gameInfo;
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.gameInfo == null || loading) {
      return CircularProgressWidget();
    }
    theme = AppTheme.getTheme(context);
    final gameInfo = this.gameInfo;

    List<TableRow> tableItems = [];
    tableItems.add(_buildOneRow(
        col1: appScreenText["buyIn"],
        col2:
            "${DataFormatter.chipsFormat(gameInfo.buyInMin)}/${DataFormatter.chipsFormat(gameInfo.buyInMax)}"));

    if (gameInfo.tipsPercentage != null && gameInfo.tipsPercentage > 0) {
      if (gameInfo.tipsCap != null) {
        tableItems.add(_buildOneRow(
            col1: 'Tips',
            col2:
                "${DataFormatter.chipsFormat(gameInfo.tipsPercentage)}% Cap: ${gameInfo.tipsCap}"));
      } else {
        tableItems.add(_buildOneRow(
            col1: 'Tips',
            col2: "${DataFormatter.chipsFormat(gameInfo.tipsPercentage)}%"));
      }
    }

    tableItems.add(_buildOneRow(
        col1: appScreenText["highHandTracked"],
        col2: _getYesNo(gameInfo?.highHandTracked)));
    tableItems.add(_buildOneRow(
        col1: appScreenText["runitTwiceAllowed"],
        col2: _getYesNo(gameSettings?.runItTwiceAllowed)));
    tableItems.add(_buildOneRow(
        col1: appScreenText["bombPotEnabled"],
        col2: _getYesNo(gameSettings?.bombPotEnabled)));
    if (gameSettings != null && gameSettings.bombPotEnabled) {
      tableItems.add(_buildOneRow(
          col1: appScreenText["bombPotInterval"],
          col2: gameSettings?.bombPotInterval?.toString()));
      tableItems.add(_buildOneRow(
          col1: appScreenText["doubleBoardBombPot"],
          col2: _getYesNo(gameSettings?.doubleBoardBombPot)));
    }
    tableItems.add(_buildOneRow(
        col1: appScreenText["utgStraddleAllowed"],
        col2: _getYesNo(gameInfo.utgStraddleAllowed)));
    tableItems.add(_buildOneRow(
        col1: appScreenText["animations"],
        col2: _getYesNo(gameSettings?.funAnimations)));
    tableItems.add(_buildOneRow(
        col1: appScreenText["chatEnabled"],
        col2: _getYesNo(gameSettings?.chat)));
    tableItems.add(_buildOneRow(
        col1: appScreenText["showResult"],
        col2: _getYesNo(gameSettings?.showResult)));
    String gameType = '${gameTypeStr2(gameTypeFromStr(gameInfo.gameType))}';
    GameType gameTypeE = gameTypeFromStr(gameInfo.gameType);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: AppDecorators.bgImageGradient(theme),
      width: MediaQuery.of(context).size.width,
      child: (gameInfo == null || loading)
          ? Center(child: CircularProgressWidget())
          : Column(
              children: [
                Text(
                  "$gameType ${DataFormatter.chipsFormat(gameInfo.smallBlind)}/${DataFormatter.chipsFormat(gameInfo.bigBlind)}",
                  style: AppDecorators.getHeadLine3Style(theme: theme),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appScreenText["code"] + ': ',
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
                getSessionInfo(theme),
                AppDimensionsNew.getVerticalSizedBox(8),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
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
                                children: tableItems,
                              ),
                              AppDimensionsNew.getVerticalSizedBox(8),
                              Visibility(
                                visible: gameTypeE == GameType.ROE,
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
                                visible: gameTypeE == GameType.DEALER_CHOICE,
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

  Widget getSessionInfo(AppTheme theme) {
    List<Column> children = [];
    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WrapText(
          appScreenText["runningTime"],
          theme,
          style: AppDecorators.getSubtitle1Style(theme: theme),
        ),
        Text(
          "${DataFormatter.getTimeInHHMMFormat(gameInfo.runningTime)}",
          style: AppDecorators.getAccentTextStyle(theme: theme)
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    ));
    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        WrapText(
          appScreenText["handsDealt"],
          theme,
          style: AppDecorators.getSubtitle1Style(theme: theme),
        ),
        WrapText(
          "${gameInfo.handNum}",
          theme,
          style: AppDecorators.getAccentTextStyle(theme: theme)
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    ));

    if ((gameInfo.noHandsPlayed ?? 0) != 0) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          WrapText(
            'Hands Played',
            theme,
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
          Text(
            "${gameInfo.noHandsPlayed}",
            style: AppDecorators.getAccentTextStyle(theme: theme)
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ));
    }

    if ((gameInfo.buyin ?? 0) != 0) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Buyin',
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
          Text(
            "${DataFormatter.chipsFormat(gameInfo.buyin)}",
            style: AppDecorators.getAccentTextStyle(theme: theme)
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ));
    }

    if ((gameInfo.stack ?? 0) != 0) {
      double profit = gameInfo.stack - gameInfo.buyin;
      Color color = Colors.green;
      if (profit < 0) {
        color = Colors.red;
      }
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Profit',
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
          Text(
            "${DataFormatter.chipsFormat(profit)}",
            style: AppDecorators.getAccentTextStyle(theme: theme)
                .copyWith(fontWeight: FontWeight.normal, color: color),
          ),
        ],
      ));
    }

    return Container(
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
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
        child: FittedBox(
          alignment: Alignment.centerRight,
          fit: BoxFit.scaleDown,
          child: Text(
            col2,
            textAlign: TextAlign.end,
            style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ]);
  }

  _getYesNo(bool val) {
    if (val ?? false) {
      return "Yes";
    }
    return "No";
  }
}
