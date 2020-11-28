class PlayerInSeatModel {
  String name;
  int seatNo;
  String playerUuid;
  int buyIn;
  int stack;

  PlayerInSeatModel.fromJson(var data) {
    this.name = data['name'];
    this.seatNo = data['seatNo'];
    this.playerUuid = data['playerUuid'];
    this.buyIn = data['buyIn'];
    this.stack = data['stack'];
  }
}
