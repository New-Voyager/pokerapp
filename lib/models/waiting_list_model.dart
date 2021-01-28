class WaitingListModel {
  String playerUuid;
  String name;
  String waitingFrom;

  WaitingListModel({this.playerUuid, this.name, this.waitingFrom});

  WaitingListModel.fromJson(Map<String, dynamic> json) {
    playerUuid = json['playerUuid'];
    name = json['name'];
    waitingFrom = json['waitingFrom'];
  }
}
