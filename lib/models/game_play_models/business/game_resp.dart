class BuyInResponse {
  bool missedBlind;
  String status;
  bool approved;
  int expireSeconds;
  double availableCredits;
  bool insufficientCredits;
  bool appliedNextHand;
  bool applied;

  BuyInResponse();

  factory BuyInResponse.fromJson(dynamic json) {
    BuyInResponse resp = BuyInResponse();
    resp.missedBlind = json['missedBlind'] ?? false;
    resp.status = json['status'] ?? '';
    resp.approved = json['approved'] ?? false;
    resp.expireSeconds = 0;
    if (json['expireSeconds'] != null) {
      resp.expireSeconds = int.parse(json['expireSeconds']);
    }
    resp.insufficientCredits = json['insufficientCredits'] ?? false;
    resp.availableCredits = 0;
    if (json['availableCredits'] != null) {
      resp.availableCredits = double.parse(json['availableCredits'].toString());
    }
    if (json['appliedNextHand'] != null) {
      resp.appliedNextHand = json['appliedNextHand'];
    }
    if (json['applied'] != null) {
      resp.applied = json['applied'];
    }

    return resp;
  }
}
