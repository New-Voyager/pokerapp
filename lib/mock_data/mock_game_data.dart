import 'dart:math';

class MockGameData {
  String clubName;
  String gameType;
  String buyIn;
  String gameID;
  String openSeats;
  String gameEndedAt;
  String gameStartedAt;
  String profit;
  int clubLogo;
  String sessionTime;

  MockGameData({
    this.clubName,
    this.gameType,
    this.buyIn,
    this.gameID,
    this.openSeats,
    this.gameEndedAt,
    this.gameStartedAt,
    this.profit,
    this.clubLogo,
    this.sessionTime,
  });

  static List<MockGameData> get(int numberOfGames) {
    return List.generate(
      numberOfGames,
      (_) => MockGameData(
        clubName: 'Manchester Bus Station',
        gameType: 'PLO 1/2',
        buyIn: (Random().nextInt(8) * 50).toString(),
        gameID: '12920292029',
        openSeats: Random().nextInt(3).toString(),
        gameEndedAt: '07/07/20, 1:20 PM',
        gameStartedAt: '07/07/20, 1:20 PM',
        sessionTime: '${Random().nextInt(20)}:${Random().nextInt(60)}',
        profit: (Random().nextInt(4) * 50).toString(),
        clubLogo: Random().nextInt(3),
      ),
    );
  }
}
