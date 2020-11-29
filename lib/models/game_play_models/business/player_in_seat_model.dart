class PlayerInSeatModel {
  bool isMe;
  String name;
  int seatNo;
  String playerUuid;
  int buyIn;
  int stack;

  PlayerInSeatModel.fromJson(var data) {
    this.isMe = false; // by default keep this value false
    this.name = data['name'];
    this.seatNo = data['seatNo'];
    this.playerUuid = data['playerUuid'];
    this.buyIn = data['buyIn'];
    this.stack = data['stack'];
  }
}
