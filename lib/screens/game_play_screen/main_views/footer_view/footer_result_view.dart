import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/hand_result.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

/* building the footer result view, which shows the winners
 * along with their highlighted cards with the community cards */

class FooterResultView extends StatelessWidget {
  final HandResultState result;

  FooterResultView({
    @required this.result,
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
              int rawCardNumber = c.cardNum;

              if (cardsToHighlight.contains(rawCardNumber)) c.highlight = true;
            }

            c.otherHighlightColor = true;
            c.cardType = CardType.HandLogOrHandHistoryCard;
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
    final players = Provider.of<GameState>(context).getPlayers(context);
    final player = players.fromSeat(seatNo);
    return player.name;
  }

  List<CardObject> getCardsFromSeatNo(int seatNo, {BuildContext context}) {
    final players = Provider.of<GameState>(context).getPlayers(context);
    final player = players.fromSeat(seatNo);
    return player.cardObjects;
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
    List<HiWinnersModel> winners = result.potWinners;

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
