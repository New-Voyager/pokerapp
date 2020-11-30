import 'package:pokerapp/models/game_play_models/business/player_in_seat_model.dart';

class GameInfoModel {
  int buyInMax;
  int buyInMin;
  int maxPlayers;
  String title;
  String gameType; // fixme: is it okay to use GameType or String?
  String tableStatus;
  String status;
  int smallBlind;
  int bigBlind;
  List<int> availableSeats;
  List<PlayerInSeatModel> playersInSeats;
  String gameToken;
  String playerGameStatus;

  // nats channels
  String gameToPlayerChannel;
  String playerToHandChannel;
  String handToAllChannel;
  String handToPlayerChannel;

  GameInfoModel.fromJson(var data) {
    this.buyInMax = data['buyInMax'];
    this.maxPlayers = data['maxPlayers'];
    this.title = data['title'];
    this.gameType = data['gameType'];
    this.buyInMin = data['buyInMin'];
    this.smallBlind = data['smallBlind'];
    this.bigBlind = data['bigBlind'];
    this.status = data['status'];
    this.tableStatus = data['tableStatus'];
    this.availableSeats = data['seatInfo']['availableSeats']
        .map<int>((e) => int.parse(e.toString()))
        .toList();
    this.playersInSeats = data['seatInfo']['playersInSeats']
        .map<PlayerInSeatModel>((e) => PlayerInSeatModel.fromJson(e))
        .toList();
    this.gameToken = data['gameToken'];
    this.playerGameStatus = data['playerGameStatus'];

    // Nats Server channels
    this.gameToPlayerChannel = data['gameToPlayerChannel'];
    this.playerToHandChannel = data['playerToHandChannel'];
    this.handToAllChannel = data['handToAllChannel'];
    this.handToPlayerChannel = data['handToPlayerChannel'];
  }

  // graph ql queries
  static String query(String gameCode) => """query gameInfo {
    gameInfo(gameCode:"$gameCode") {
      buyInMax
      maxPlayers
      title
      gameType
      buyInMin
      smallBlind
      bigBlind
      status
      tableStatus
      seatInfo {
        availableSeats
        playersInSeats {
          name
          seatNo
          playerUuid
          stack
          buyIn
        }
      }
      gameToken
      playerGameStatus
      gameToPlayerChannel
      playerToHandChannel
      handToAllChannel
      handToPlayerChannel
    }
  } """;
}
