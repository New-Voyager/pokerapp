import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/high_hand_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class ResultService {
  ResultService._();

  /* seat-no, value mapping */
  static Map<int, int> _getUpdatedStack(var data) {
    Map<int, int> stacks = Map<int, int>();

    var players = data['handResult']['players'];
    players.forEach(
        (key, p) => stacks[int.parse(key.toString())] = p['balance']['after']);

    return stacks;
  }

  /* seat-no, list of cards mapping */
  static Map<int, List<int>> _getCards(var data) {
    var players = data['handResult']['players'];

    Map<int, List<int>> seatNoCardsMap = Map<int, List<int>>();
    players.forEach((seatNo, d) =>
        seatNoCardsMap[int.parse(seatNo.toString())] =
            d['cards']?.map<int>((e) => int.parse(e.toString()))?.toList());

    return seatNoCardsMap;
  }

  /* get back the board cards that needs to be highlighted */
  static List<int> _getBoardCards(var data) {
    var boardCards = data['handResult']['handLog']['potWinners']['0']
        ['hiWinners'][0]['boardCards'];

    return boardCards.map<int>((c) => int.parse(c.toString())).toList();
  }

  /* get back the player cards that needs to be highlighted */
  static Map<String, dynamic> _getPlayerData(var data) {
    var hiWinner =
        data['handResult']['handLog']['potWinners']['0']['hiWinners'][0];

    int seatNo = hiWinner['seatNo'];
    var playerCards = hiWinner['playerCards'];

    return {
      'seatNo': seatNo,
      'playerCards':
          playerCards.map<int>((c) => int.parse(c.toString())).toList(),
    };
  }

  static void handle({
    BuildContext context,
    var data,
  }) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final Players players = gameState.getPlayers(context);
    final tableState = gameState.getTableState(context);
    final resultState = gameState.getResultState(context);

    if (data['handResult']['highHand'] != null) {
      HighHandService.handle(
        context: context,
        data: data['handResult']['highHand'],
        showNotification: false,
      );
    }
    gameState.resetSeatActions();
    players.clearForShowdown();
    // debugPrint(jsonEncode(data));
    // get hand winners data and update results
    final winnersData = data['handResult']['handLog']['potWinners'];
    final winners = resultState.updateWinners(winnersData);

    /* showdown time, show other players cards */
    players.updateUserCardsSilent(_getCards(data));

    // get the winner seat No and highlight the winner
    winners.forEach((winner) {
      // highlight the winner seat No
      players.highlightWinnerSilent(winner.seatNo);
    });

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    /* highlight cards of players and community cards for winner */
    tableState.highlightCardsSilent(_getBoardCards(data));
    tableState.notifyAll();

    Map<String, dynamic> playerData = _getPlayerData(data);

    players.highlightCardsSilent(
      seatNo: playerData['seatNo'],
      cards: playerData['playerCards'],
    );

    /* update stack of every player after showing the reverse pot chip animation */
    for (HiWinnersModel winner in winners) {
      final seat = gameState.getSeat(context, winner.seatNo);
      seat.player.action.amount = winner.amount.toDouble();
      seat.player.action.winner = true;
    }
    gameState.animateSeatActions();
    players.notifyAll();

    // wait for the animation to finish, then update the stack
    Future.delayed(AppConstants.animationDuration).then(
      (_) {
        players.updateStackBulkSilent(_getUpdatedStack(data));
        players.notifyAll();
      },
    );

    final MarkedCards markedCards = gameState.getMarkedCards(context);

    /* collect the cards needs to be revealed */
    List<CardObject> _cardsToBeRevealed = markedCards.getCards();
    List<int> cardNumbers = _cardsToBeRevealed
        .map<int>((card) => CardHelper.getCardNumber(card))
        .toList();

    /* clear all the marked cards */
    markedCards.clear();

    // todo: put the delay in the const class after finalizing the delay constant
    /* finally send the cardNumbers to the gameChatChannel after 1500 ms */
    Future.delayed(const Duration(milliseconds: 1500)).then(
      (_) => gameState.getGameMessagingService(context).sendCards(
            cardNumbers,
            players.me?.seatNo,
          ),
    );
  }
}
