import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class FooterResultView extends StatefulWidget {
  final FooterResult footerResult;

  FooterResultView({
    @required this.footerResult,
  });

  @override
  _FooterResultViewState createState() => _FooterResultViewState();
}

/* building the footer result view, which shows the winners
 * along with their highlighted cards with the community cards */

class _FooterResultViewState extends State<FooterResultView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int currentIndex = 0;

  Widget getCardRowView({
    List<CardObject> cards,
    List<int> cardsToHighlight,
    bool allCardsToHighlight = false,
  }) =>
      Transform.scale(
        scale: 0.80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cards.map((c) {
            if (allCardsToHighlight)
              c.highlight = true;
            else {
              if (cardsToHighlight != null) {
                int rawCardNumber =
                    CardHelper.getRawCardNumber('${c.label}${c.suit}');
                if (cardsToHighlight.contains(rawCardNumber))
                  c.highlight = true;
              }
            }

            c.otherHighlightColor = true;
            c.smaller = true;
            return c.widget;
          }).toList(),
        ),
      );

  String getNameFromSeatNo(int seatNo, {BuildContext context}) {
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );
    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);
    return players.players[idx].name;
  }

  List<CardObject> getCardsFromSeatNo(int seatNo, {BuildContext context}) {
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);
    return players.players[idx].cards
        .map<CardObject>((c) => CardHelper.getCard(c))
        .toList();
  }

  Widget _buildFooterResultCommunitySection(List<int> cardsToHighlight) {
    List<CardObject> _communityCards = Provider.of<TableState>(
      context,
      listen: false,
    ).cards;

    List<CardObject> cards = List<CardObject>();
    _communityCards.forEach((c) {
      CardObject card = CardHelper.getCard(
        CardHelper.getRawCardNumber('${c.label}${c.suit}'),
      );

      cards.add(card);
    });

    return Row(
      children: [
        /* community text */
        Expanded(
          child: Text(
            'Community',
            style: AppStyles.footerResultTextStyle1,
          ),
        ),

        /* community cards */
        Expanded(
          flex: 3,
          child: getCardRowView(
            cards: cards,
            cardsToHighlight: cardsToHighlight,
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameAndCards({
    String winnerName,
    List<CardObject> winnerCards,
    List<int> cardsToHighlight,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* winner name */
          Text(
            winnerName.toUpperCase(),
            style: AppStyles.footerResultTextStyle3,
          ),

          /* winner card */
          getCardRowView(
            cards: winnerCards,
            cardsToHighlight: cardsToHighlight,
          ),
        ],
      );

  Widget _buildWinningCardsAndRankStr({
    String rankStr,
    List<CardObject> winningCards,
  }) =>
      Column(
        children: [
          /* winning cards */
          getCardRowView(
            cards: winningCards,
            allCardsToHighlight: true,
          ),

          /* rank Str */
          Text(
            rankStr,
            style: AppStyles.footerResultTextStyle4,
          ),
        ],
      );

  Widget _buildFooterResultWinnersSection(
    List<HiWinnersModel> winners,
  ) =>
      TabBarView(
        controller: _tabController,
        physics: BouncingScrollPhysics(),
        children: winners.map(
          (HiWinnersModel winner) {
            /* name */
            String winnerName = getNameFromSeatNo(
              winner.seatNo,
              context: context,
            );

            /* cards */
            List<CardObject> winnerCards = getCardsFromSeatNo(
              winner.seatNo,
              context: context,
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* winner name and card/s */
                _buildUserNameAndCards(
                  winnerCards: winnerCards,
                  winnerName: winnerName,
                  cardsToHighlight: winner.playerCards,
                ),

                /* winning cards and rankStr */
                _buildWinningCardsAndRankStr(
                  winningCards: winner.winningCards
                      .map<CardObject>(
                        (c) => CardHelper.getCard(c),
                      )
                      .toList(),
                  rankStr: winner.rankStr,
                ),
              ],
            );
          },
        ).toList(),
      );

  Widget _buildFooterResult() {
    List<HiWinnersModel> winners = widget.footerResult.potWinners;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
      ),
      child: Column(
        children: [
          /* community cards */
          _buildFooterResultCommunitySection(
            winners[currentIndex].winningCards,
          ),

          /* winner text */
          Text(
            'Winner${winners.length > 1 ? 's' : ''}',
            style: AppStyles.footerResultTextStyle2,
          ),

          /* displaying the winner, winner cards, rankStr */
          Flexible(
            child: _buildFooterResultWinnersSection(
              winners,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: widget.footerResult.potWinners.length,
      vsync: this,
    );

    _tabController.addListener(
      () => setState(
        () => currentIndex = _tabController.index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildFooterResult();
}
