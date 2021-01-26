class SeatChangeModel {
  String name;
  String status;
  int seatNo;
  String seatChangeRequestedAt;
  int sessionTime;

  SeatChangeModel(
      {this.name,
      this.status,
      this.seatNo,
      this.seatChangeRequestedAt,
      this.sessionTime});

  SeatChangeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    seatNo = json['seatNo'];
    seatChangeRequestedAt = json['seatChangeRequestedAt'];
    sessionTime = json['sessionTime'];
  }
}
