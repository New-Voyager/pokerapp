import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/enums/game_type.dart' as enums;
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class PotWinnersView extends StatelessWidget {
  final HandResultData handResult;
  final int potNo;
  final bool isMessageItem;

  PotWinnersView(
    this.handResult,
    this.potNo, {
    this.isMessageItem = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    final Widget bw = boardWinners(potNo, theme);

    // players in the pot
    List<int> seatsInPots = [];
    for (final pot in handResult.result.potWinners) {
      if (pot.potNo == potNo) {
        seatsInPots = pot.seatsInPots;
        break;
      }
    }
    if (seatsInPots == null) {
      seatsInPots = [];
    }
    List<String> playerNames = [];
    for (final seatNo in seatsInPots) {
      final player = this.handResult.getPlayerBySeatNo(seatNo);
      playerNames.add(player.name);
    }
    String players = playerNames.join(',');
    bool isOnlyOnePot = handResult.result.potWinners.length == 1;

    return Container(
      decoration: AppDecorators.tileDecoration(theme),
      padding: EdgeInsets.only(bottom: 16.pw, top: 8.pw, left: 4.pw),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          potTitle(theme),
          isOnlyOnePot
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerRight,
                  child: Text(
                    players,
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),
          bw,
        ],
      ),
    );
  }

  Widget boardWinners(int potNo, AppTheme theme) {
    bool hiLoGame = false;
    final gameType = gameTypeFromStr(handResult.gameType);
    if (gameType == enums.GameType.FIVE_CARD_PLO_HILO ||
        gameType == enums.GameType.PLO_HILO) {
      hiLoGame = true;
    }
    bool multipleBoards = handResult.result.boards.length > 1;
    List<Widget> winners = [];
    for (final board in handResult.result.potWinners[potNo].boardWinners) {
      final bw = boardWinner(hiLoGame, multipleBoards, board, theme);
      winners.add(bw);
      //winners.add(SizedBox(height: 5.dp));
    }
    return Column(
      children: winners,
    );
  }

  List<Widget> hiWinnerTile(
    final int boardNo,
    final bool firstWinner,
    final ResultWinner winner,
    final bool hi,
    final bool multipleBoards,
  ) {
    final board = this.handResult.result.boards[boardNo - 1];
    final playerRank = this.handResult.getPlayerRank(boardNo, winner.seatNo);
    final player = this.handResult.getPlayerBySeatNo(winner.seatNo);
    List<Widget> children = [];
    bool showDown = this.handResult.wonAt() == GameStages.SHOWDOWN;
    List<int> playerCards = player.cards;
    if (!showDown) {
      playerCards = [];
    }
    List<int> winningCards;
    if (hi) {
      winningCards = playerRank.hiCards;
    } else {
      winningCards = playerRank.loCards;
    }
    List<int> playerCardsToHighLight = [];
    List<int> boardCardsToHighLight = [];
    if (this.handResult.wonAt() == GameStages.SHOWDOWN) {
      for (int i = 0; i < playerCards.length; i++) {
        int index = winningCards.indexOf(playerCards[i]);
        if (index != -1) {
          playerCardsToHighLight.add(playerCards[i]);
        }
      }
      final board = this.handResult.getBoard(boardNo);
      for (int i = 0; i < board.cards.length; i++) {
        int index = winningCards.indexOf(board.cards[i]);
        if (index != -1) {
          boardCardsToHighLight.add(board.cards[i]);
        }
      }
    }
    Widget playerView = showDown
        ? StackCardView01(
            totalCards: playerCards,
            show: true,
            needToShowEmptyCards: !showDown,
            cardsToHighlight: playerCardsToHighLight,
          )
        : StackCardView00(
            cards: playerCards,
            show: true,
            needToShowEmptyCards: !showDown,
            maxCards: this.handResult.noCards,
          );

    Widget boardView = showDown
        ? StackCardView01(
            totalCards: board.cards,
            show: true,
            needToShowEmptyCards: !showDown,
            cardsToHighlight: boardCardsToHighLight,
          )
        : StackCardView00(
            cards: board.cards,
            show: true,
            needToShowEmptyCards: !showDown,
          );
    if (!multipleBoards) {
      boardView = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Board'), boardView],
      );
    } else {
      if (firstWinner) {
        boardView = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Board ${board.boardNo}'), boardView],
        );
      }
    }
    playerView = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(player.name), playerView],
    );

    final bool needToShrink = isMessageItem && (playerCards.length != 2);

    final Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // display player cards
        playerView,

        needToShrink ? const SizedBox(width: 20.0) : const SizedBox.shrink(),

        // display hi cards
        boardView
      ],
    );

    final w = needToShrink ? FittedBox(child: row) : row;

    children.add(w);

    return children;
  }

  Widget boardWinner(
    bool hiLoGame,
    bool multipleBoards,
    ResultBoardWinner boardWinner,
    AppTheme theme,
  ) {
    String hiWinnersText = '';
    if (multipleBoards) {
      if (hiLoGame) {
        hiWinnersText = 'Board ${boardWinner.boardNo} High Winners';
      }
    } else {
      if (hiLoGame && boardWinner.lowWinners.length > 0) {
        hiWinnersText = 'High Winners';
      }
    }
    // get board cards
    final hiWinners = Column(
      children: [],
    );
    final lowWinners = Column(
      children: [],
    );
    String lowWinnersText = '';
    if (boardWinner.lowWinners.length > 0) {
      if (multipleBoards) {
        lowWinnersText = 'Board ${boardWinner.boardNo} Low Winners';
      } else {
        lowWinnersText = 'Low Winners';
      }
    }

    //List<Widget> children = [];
    if (boardWinner.hiWinners.length > 0) {
      hiWinners.children.add(Text(hiWinnersText));
      //children.add(SizedBox(height: 5.dp));
      bool firstWinner = true;
      for (final winner in boardWinner.hiWinners.values) {
        hiWinners.children.addAll(
          hiWinnerTile(
            boardWinner.boardNo,
            firstWinner,
            winner,
            true,
            multipleBoards,
          ),
        );
        firstWinner = false;
      }
    }

    if (boardWinner.lowWinners.length > 0) {
      lowWinners.children.add(Text(lowWinnersText));
      //children.add(SizedBox(height: 5.dp));
      bool firstWinner = true;
      for (final winner in boardWinner.lowWinners.values) {
        lowWinners.children.addAll(
          hiWinnerTile(
            boardWinner.boardNo,
            firstWinner,
            winner,
            false,
            multipleBoards,
          ),
        );
        firstWinner = false;
      }
    }

    List<Widget> allWidgets = [];

    allWidgets.addAll(hiWinners.children);
    allWidgets.add(SizedBox(height: 5.dp));
    allWidgets.addAll(lowWinners.children);

    final winners = Column(children: allWidgets);
    return winners;
  }

  Widget potTitle(AppTheme theme) {
    String potStr = "Main Pot";
    if (potNo != 0) {
      potStr = 'Side Pot $potNo';
    }
    final potCount = handResult.result.potWinners.length;
    if (potCount == 1) {
      potStr = "Pot";
    }
    final pot = handResult.result.potWinners[potNo];

    return Container(
      // decoration: AppDecorators.tileDecoration(theme),
      // padding: EdgeInsets.only(bottom: 16.pw, top: 8.pw, left: 4.pw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerRight,
            child: Text(
              potStr,
              style: AppDecorators.getHeadLine4Style(theme: theme),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerRight,
            child: Text(
              DataFormatter.chipsFormat(pot.amount),
              style: AppDecorators.getHeadLine4Style(theme: theme),
            ),
          ),
        ],
      ),
    );
  }
}

class HandWinnersView2 extends StatelessWidget {
  final HandResultData handResult;
  final bool chatWidget;

  HandWinnersView2({this.handResult, this.chatWidget});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    if (handResult.result.potWinners == null ||
        handResult.result.potWinners.length == 0) {
      return Center(
        child: Text(
          "No winner details found",
          style: AppDecorators.getSubtitle2Style(theme: theme),
        ),
      );
    } else {
      // String winnersTitle = 'Winners';
      // for (final potWinner in handResult.result.potWinners) {
      //   for (final boardWinner in potWinner.boardWinners) {
      //     if (boardWinner.lowWinners.length > 0) {
      //       winnersTitle = 'Hi-Winners';
      //       break;
      //     }
      //   }
      // }

      // int subCards = 0;
      // GameStages stageAtWon = handResult.wonAt();

      // if (stageAtWon == GameStages.PREFLOP) {
      //   subCards = 0;
      // } else if (stageAtWon == GameStages.FLOP) {
      //   subCards = 3;
      // } else if (stageAtWon == GameStages.TURN) {
      //   subCards = 4;
      // } else if (stageAtWon == GameStages.RIVER) {
      //   subCards = 5;
      // } else if (stageAtWon == GameStages.SHOWDOWN) {
      //   subCards = 5;
      // }

      return Container(
        margin: EdgeInsets.only(bottom: 4, left: 8, right: 8),
        child: Container(
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: 8,
            ),
            itemCount: handResult.result.potWinners.length,
            itemBuilder: (context, index) {
              return PotWinnersView(
                handResult,
                handResult.result.potWinners[index].potNo,
              );
            },
          ),
        ),
      );
    }
  }
}
