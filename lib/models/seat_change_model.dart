class SeatChangeModel {
  String name;
  String status;
  int seatNo;
  String seatChangeRequestedAt;
  int sessionTime;
  String playerUuid;
  SeatChangeModel(
      {this.name,
      this.status,
      this.seatNo,
      this.seatChangeRequestedAt,
      this.playerUuid,
      this.sessionTime});

  SeatChangeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    seatNo = json['seatNo'];
    seatChangeRequestedAt = json['seatChangeRequestedAt'];
    sessionTime = json['sessionTime'];
    playerUuid = json['playerUuid'];
  }
}
