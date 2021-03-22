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

/* building the footer result view, which shows the winners
 * along with their highlighted cards with the community cards */

class FooterResultView extends StatelessWidget {
  final FooterResult footerResult;

  FooterResultView({
    @required this.footerResult,
  });

  Widget getCardRowView({
    List<CardObject> cards,
    List<int> cardsToHighlight,
  }) =>
      Transform.scale(
        scale: 0.80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: cards.map((c) {
            if (cardsToHighlight != null) {
              int rawCardNumber =
                  CardHelper.getRawCardNumber('${c.label}${c.suit}');

              if (cardsToHighlight.contains(rawCardNumber)) c.highlight = true;
            }

            c.otherHighlightColor = true;
            c.smaller = false;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: c.widget,
            );
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

  // Widget _buildFooterResultCommunitySection(
  //     List<int> cardsToHighlight, BuildContext context) {
  //   List<CardObject> _communityCards = Provider.of<TableState>(
  //     context,
  //     listen: false,
  //   ).cards;

  //   List<CardObject> cards = List<CardObject>();
  //   _communityCards.forEach((c) {
  //     CardObject card = CardHelper.getCard(
  //       CardHelper.getRawCardNumber('${c.label}${c.suit}'),
  //     );

  //     cards.add(card);
  //   });

  //   return Row(
  //     children: [
  //       /* community text */
  //       Expanded(
  //         child: Text(
  //           'Community',
  //           style: AppStyles.footerResultTextStyle1,
  //         ),
  //       ),

  //       /* community cards */
  //       Expanded(
  //         flex: 3,
  //         child: getCardRowView(
  //           cards: cards,
  //           cardsToHighlight: cardsToHighlight,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* winning cards */
          getCardRowView(
            cards: winningCards,
          ),

          /* rank Str */
          Text(
            rankStr,
            style: AppStyles.footerResultTextStyle4,
          ),
        ],
      );

  Widget _buildFooterResultWinnersSection(
    HiWinnersModel winner,
    BuildContext context,
  ) {
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
      children: [
        /* winner name and card/s */
        Expanded(
          child: FittedBox(
            child: _buildUserNameAndCards(
              winnerCards: winnerCards,
              winnerName: winnerName,
              cardsToHighlight: winner.playerCards,
            ),
          ),
        ),

        /* winning cards and rankStr */
        Expanded(
          child: FittedBox(
            child: _buildWinningCardsAndRankStr(
              winningCards: winner.winningCards
                  .map<CardObject>(
                    (c) => CardHelper.getCard(c),
                  )
                  .toList(),
              rankStr: winner.rankStr,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterResult(BuildContext context) {
    List<HiWinnersModel> winners = footerResult.potWinners;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* community cards */
          // _buildFooterResultCommunitySection(
          //   winners.first.winningCards,
          //   context,
          // ),

          /* winner text */
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Winner${winners.length > 1 ? 's' : ''}',
              style: AppStyles.footerResultTextStyle2,
            ),
          ),

          /* displaying the winner, winner cards, rankStr */
          Flexible(
            child: _buildFooterResultWinnersSection(
              winners.first,
              context,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _buildFooterResult(context);
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
