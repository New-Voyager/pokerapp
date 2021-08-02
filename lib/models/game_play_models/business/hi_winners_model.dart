import 'package:pokerapp/proto/hand.pb.dart';

class HiWinnersModel {
  int seatNo;
  int amount;
  List<int> winningCards;
  String rankStr;
  List<int> playerCards;
  List<int> boardCards;

  HiWinnersModel.fromJson(var data) {
    this.seatNo = data['seatNo'];
    this.amount = data['amount'];
    this.winningCards =
        data['winningCards'].map<int>((e) => int.parse(e.toString())).toList();
    this.rankStr = data['rankStr'];
    this.playerCards =
        data['playerCards'].map<int>((e) => int.parse(e.toString())).toList();
    this.boardCards =
        data['boardCards'].map<int>((e) => int.parse(e.toString())).toList();
  }

  HiWinnersModel.fromHandWinner(HandWinner data) {
    this.seatNo = data.seatNo;
    this.amount = data.amount.toInt();
    this.winningCards = data.winningCards;
    this.rankStr = data.rankStr;
    this.playerCards = data.playerCards;
    this.boardCards = data.boardCards;
  }
}
