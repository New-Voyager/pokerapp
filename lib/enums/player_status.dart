enum PlayerStatus {
  PLAYER_UNKNOWN_STATUS,
  NOT_PLAYING,
  PLAYING,
  IN_QUEUE,
  IN_BREAK,
  STANDING_UP,
  LEFT,
  KICKED_OUT,
  BLOCKED,
  LOST_CONNECTION,
  WAIT_FOR_BUYIN,
  LEAVING_GAME,
  TAKING_BREAK,
  JOINING,
  WAITLIST_SEATING,
  PENDING_UPDATES,
  WAIT_FOR_BUYIN_APPROVAL,
  NEED_TO_POST_BLIND,
}

PlayerStatus playerStatusFromStr(String status) {
  final playerStatus = 'PlayerStatus.' + status;
  final index = PlayerStatus.values
      .map((e) => e.toString())
      .toList()
      .indexOf(playerStatus);
  if (index == -1) {
    return PlayerStatus.NOT_PLAYING;
  } else {
    return PlayerStatus.values[index];
  }
}
