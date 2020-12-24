class CreateGameInput {
  String title;
  String gameType;
  int smallBlind;
  int bigBlind;
  bool utgStraddleAllowed;
  int straddleBet;
  int minPlayers;
  int maxPlayers;
  int gameLength;
  bool buyInApproval;
  int rakePercentage;
  int rakeCap;
  int buyInMin;
  int buyInMax;
  int actionTime;

  CreateGameInput(
      {this.title,
      this.gameType,
      this.smallBlind,
      this.bigBlind,
      this.utgStraddleAllowed,
      this.straddleBet,
      this.minPlayers,
      this.maxPlayers,
      this.gameLength,
      this.buyInApproval,
      this.rakePercentage,
      this.rakeCap,
      this.buyInMin,
      this.buyInMax,
      this.actionTime});

  CreateGameInput.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    gameType = json['gameType'];
    smallBlind = json['smallBlind'];
    bigBlind = json['bigBlind'];
    utgStraddleAllowed = json['utgStraddleAllowed'];
    straddleBet = json['straddleBet'];
    minPlayers = json['minPlayers'];
    maxPlayers = json['maxPlayers'];
    gameLength = json['gameLength'];
    buyInApproval = json['buyInApproval'];
    rakePercentage = json['rakePercentage'];
    rakeCap = json['rakeCap'];
    buyInMin = json['buyInMin'];
    buyInMax = json['buyInMax'];
    actionTime = json['actionTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['gameType'] = this.gameType;
    data['smallBlind'] = this.smallBlind;
    data['bigBlind'] = this.bigBlind;
    data['utgStraddleAllowed'] = this.utgStraddleAllowed;
    data['straddleBet'] = this.straddleBet;
    data['minPlayers'] = this.minPlayers;
    data['maxPlayers'] = this.maxPlayers;
    data['gameLength'] = this.gameLength;
    data['buyInApproval'] = this.buyInApproval;
    data['rakePercentage'] = this.rakePercentage;
    data['rakeCap'] = this.rakeCap;
    data['buyInMin'] = this.buyInMin;
    data['buyInMax'] = this.buyInMax;
    data['actionTime'] = this.actionTime;
    return data;
  }
}
