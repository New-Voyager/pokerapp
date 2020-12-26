class ClubGameModel {
  final String gameTitle;
  final int buyInMin;
  final int buyInMax;
  final int waitList;
  final int seatsAvailable;
  final double smallBlind;
  final double bigBlind;

  ClubGameModel(this.gameTitle, this.buyInMin, this.buyInMax, this.waitList,
      this.seatsAvailable, this.smallBlind, this.bigBlind);
}
