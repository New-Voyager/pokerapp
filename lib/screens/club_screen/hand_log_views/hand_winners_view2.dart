import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/enums/game_type.dart' as enums;
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class PotWinnersView extends StatelessWidget {
  final HandResultData handResult;
  final int potNo;
  PotWinnersView(this.handResult, this.potNo);
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    int noOfBoards = handResult.result.boards.length;
    Widget bw = boardWinners(potNo, theme);
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

    return Container(
        decoration: AppDecorators.tileDecoration(theme),
        padding: EdgeInsets.only(bottom: 16.pw, top: 8.pw, left: 4.pw),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              potTitle(theme),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerRight,
                child: Text(
                  players,
                  style: AppDecorators.getHeadLine4Style(theme: theme),
                ),
              ),
              bw
            ]));
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
      int boardNo, bool firstWinner, ResultWinner winner, bool hi) {
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
    if (firstWinner) {
      boardView = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Board ${board.boardNo}'), boardView],
      );
    }
    playerView = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(player.name), playerView],
    );
    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // display player cards
        playerView,
        // display hi cards
        boardView
      ],
    );
    children.add(row);
    return children;
  }

  Widget boardWinner(bool hiLoGame, bool multipleBoards,
      ResultBoardWinner boardWinner, AppTheme theme) {
    String hiWinnersText = '';
    if (multipleBoards) {
      if (hiLoGame) {
        hiWinnersText = 'Board ${boardWinner.boardNo} High Winners';
      }
    } else {
      if (hiLoGame) {
        hiWinnersText = 'High Winners';
      }
    }
    // get board cards
    final hiWinners = Column(
      children: [
        Text(hiWinnersText),
      ],
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

    List<Widget> children = [];
    if (boardWinner.hiWinners.length > 0) {
      children.add(Text(hiWinnersText));
      //children.add(SizedBox(height: 5.dp));
      bool firstWinner = true;
      for (final winner in boardWinner.hiWinners.values) {
        children.addAll(
            hiWinnerTile(boardWinner.boardNo, firstWinner, winner, true));
        firstWinner = false;
      }
      hiWinners.children.addAll(children);
    }

    if (boardWinner.lowWinners.length > 0) {
      children.add(Text(lowWinnersText));
      //children.add(SizedBox(height: 5.dp));
      bool firstWinner = true;
      for (final winner in boardWinner.lowWinners.values) {
        children.addAll(
            hiWinnerTile(boardWinner.boardNo, firstWinner, winner, false));
        firstWinner = false;
      }
      hiWinners.children.addAll(children);
    }
    List<Widget> allWidgets = [];
    allWidgets.addAll(hiWinners.children);
    allWidgets.add(SizedBox(
      height: 5.dp,
    ));
    allWidgets.addAll(lowWinners.children);
    final winners = Column(children: allWidgets);

    return winners;
  }

  Widget potTitle(AppTheme theme) {
    String potStr = "Main Pot";
    if (potNo != 0) {
      potStr = 'Side Pot $potNo';
    }
    final pot = handResult.result.potWinners[potNo];

    return Container(
        // decoration: AppDecorators.tileDecoration(theme),
        // padding: EdgeInsets.only(bottom: 16.pw, top: 8.pw, left: 4.pw),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerRight,
        child: Text(
          "$potStr",
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerRight,
        child: Text(
          pot.amount.toString(),
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
      ),
    ]));
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

      int subCards = 0;
      GameStages stageAtWon = handResult.wonAt();

      if (stageAtWon == GameStages.PREFLOP) {
        subCards = 0;
      } else if (stageAtWon == GameStages.FLOP) {
        subCards = 3;
      } else if (stageAtWon == GameStages.TURN) {
        subCards = 4;
      } else if (stageAtWon == GameStages.RIVER) {
        subCards = 5;
      } else if (stageAtWon == GameStages.SHOWDOWN) {
        subCards = 5;
      }

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
              String potStr = "Pot:";
              if (index == 0 && handResult.result.potWinners.length > 1) {
                potStr = "Main Pot:";
              }
              return PotWinnersView(
                  handResult, handResult.result.potWinners[index].potNo);
            },
          ),
        ),
      );
    }
  }
}

/*

Container(
                decoration: AppDecorators.tileDecoration(theme),
                padding: EdgeInsets.only(bottom: 16, top: 8, left: 4),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$potStr " + handResult.result.potWinners[index].amount.toString(),
                        style: AppDecorators.getHeadLine4Style(theme: theme),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        winnersTitle,
                        style: AppDecorators.getSubtitle3Style(theme: theme),
                      ),
                    ),
                    Divider(
                      color: theme.fillInColor,
                      endIndent: 200,
                      indent: 8,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, bottom: 16),
                      // alignment: Alignment.centerRight,
                      child: Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: potWinnersList[index].hiWinners.length,
                          shrinkWrap: true,
                          itemBuilder: (context, winnerIndex) {
                            return Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      getPlayerNameBySeatNo(
                                          handLogModel: handLogModel,
                                          seatNo: potWinnersList[index]
                                              .hiWinners[winnerIndex]
                                              .seatNo),
                                      style: AppDecorators.getSubtitle1Style(
                                              theme: theme)
                                          .copyWith(
                                              fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  chatWidget ?? false
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StackCardView01(
                                              totalCards: handLogModel
                                                  .getPlayerBySeatNo(
                                                      potWinnersList[index]
                                                          .hiWinners[
                                                              winnerIndex]
                                                          .seatNo)
                                                  .cards,
                                              cardsToHighlight:
                                                  potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .playerCards,
                                              show: handResult.wonAt() == GameStages.SHOWDOWN,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 4, top: 8),
                                              child: Text(
                                                "Community Cards",
                                                style: AppDecorators
                                                    .getSubtitle3Style(
                                                        theme: theme),
                                              ),
                                            ),
                                            StackCardView01(
                                              totalCards: subCards >= 5
                                                  ? handLogModel.hand.boardCards
                                                  : handLogModel.hand.boardCards
                                                      .sublist(0, subCards),
                                              needToShowEmptyCards: true,
                                              cardsToHighlight: subCards == 6
                                                  ? potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .winningCards
                                                  : handLogModel
                                                      .hand.boardCards,
                                              show: true,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StackCardView01(
                                              totalCards: handLogModel
                                                  .getPlayerBySeatNo(
                                                      potWinnersList[index]
                                                          .hiWinners[
                                                              winnerIndex]
                                                          .seatNo)
                                                  .cards,
                                              cardsToHighlight:
                                                  potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .playerCards,
                                              show: handLogModel
                                                      .hand.handLog.wonAt ==
                                                  GameStages.SHOWDOWN,
                                            ),
                                            StackCardView01(
                                              totalCards: subCards >= 5
                                                  ? handLogModel.hand.boardCards
                                                  : handLogModel.hand.boardCards
                                                      .sublist(0, subCards),
                                              needToShowEmptyCards: true,
                                              cardsToHighlight: subCards == 6
                                                  ? potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .winningCards
                                                  : handLogModel
                                                      .hand.boardCards,
                                              show: true,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: potWinnersList[index].lowWinners.length > 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lo-Winners",
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: theme.fillInColor,
                              endIndent: 50,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      potWinnersList[index].lowWinners.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, winnerIndex) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              getPlayerNameBySeatNo(
                                                handLogModel: handLogModel,
                                                seatNo: potWinnersList[index]
                                                    .lowWinners[winnerIndex]
                                                    .seatNo,
                                              ),
                                              style: AppDecorators
                                                  .getHeadLine4Style(
                                                      theme: theme),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          chatWidget ?? false
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    StackCardView01(
                                                      totalCards: handLogModel
                                                          .getPlayerBySeatNo(
                                                              potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .seatNo)
                                                          .cards,
                                                      cardsToHighlight:
                                                          potWinnersList[index]
                                                              .lowWinners[
                                                                  winnerIndex]
                                                              .playerCards,
                                                      show: handLogModel.hand
                                                              .handLog.wonAt ==
                                                          GameStages.SHOWDOWN,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 4, top: 8),
                                                      child: Text(
                                                        "Community Cards",
                                                        style: AppDecorators
                                                            .getSubtitle3Style(
                                                                theme: theme),
                                                      ),
                                                    ),

                                                    StackCardView01(
                                                      totalCards: subCards >= 5
                                                          ? handLogModel
                                                              .hand.boardCards
                                                          : handLogModel
                                                              .hand.boardCards
                                                              .sublist(
                                                                  0, subCards),
                                                      needToShowEmptyCards:
                                                          true,
                                                      cardsToHighlight:
                                                          subCards == 6
                                                              ? potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .winningCards
                                                              : handLogModel
                                                                  .hand
                                                                  .boardCards,
                                                      show: true,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // CardsView(
                                                    // cards: _handLogModel
                                                    //     .hand
                                                    //     .players[potWinnersList[
                                                    //             index]
                                                    //         .lowWinners[winnerIndex]
                                                    //         .seatNo
                                                    //         .toString()]
                                                    //     .cards,
                                                    //   show: _handLogModel
                                                    //           .hand.handLog.wonAt ==
                                                    //       GameStages.SHOWDOWN,
                                                    // ),
                                                    StackCardView01(
                                                      totalCards: handLogModel
                                                          .getPlayerBySeatNo(
                                                              potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .seatNo)
                                                          .cards,
                                                      cardsToHighlight:
                                                          potWinnersList[index]
                                                              .lowWinners[
                                                                  winnerIndex]
                                                              .playerCards,
                                                      show: handLogModel.hand
                                                              .handLog.wonAt ==
                                                          GameStages.SHOWDOWN,
                                                    ),
                                                    StackCardView01(
                                                      totalCards: subCards >= 5
                                                          ? handLogModel
                                                              .hand.boardCards
                                                          : handLogModel
                                                              .hand.boardCards
                                                              .sublist(
                                                                  0, subCards),
                                                      needToShowEmptyCards:
                                                          true,
                                                      cardsToHighlight:
                                                          subCards == 6
                                                              ? potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .winningCards
                                                              : handLogModel
                                                                  .hand
                                                                  .boardCards,
                                                      show: true,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      */
