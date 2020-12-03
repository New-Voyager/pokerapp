class AppConstants {
  static const int buyInTimeOutSeconds = 100;

  static const Duration clubMessagePollDuration =
      const Duration(milliseconds: 500);

  static const String giphyApiKey = 'IoanUNVNMRCaTnTpYzB2UDxUdatagMkQ';

  static const String blackSpade = '♠';
  static const String redHeart = '♥';
  static const String blackClub = '♣';
  static const String redDiamond = '♦';

  /* table statuses */
  static const String TABLE_STATUS_WAITING_TO_BE_STARTED =
      'WAITING_TO_BE_STARTED';
  static const String TABLE_STATUS_NOT_ENOUGH_PLAYERS = 'NOT_ENOUGH_PLAYERS';
  static const String TABLE_STATUS_GAME_RUNNING = 'TABLE_STATUS_GAME_RUNNING';

  /* extra identifiers */
  static const String WAIT_FOR_BUYIN = 'WAIT_FOR_BUYIN';
  static const String PLAYING = 'PLAYING';

  /* message types */
  static const String PLAYER_UPDATE = 'PLAYER_UPDATE';
  static const String GAME_STATUS = 'GAME_STATUS';
  static const String NEW_HAND = 'NEW_HAND';
  static const String DEAL = 'DEAL';
  static const String NEXT_ACTION = 'NEXT_ACTION';
  static const String YOUR_ACTION = 'YOUR_ACTION';
  static const String QUERY_CURRENT_HAND = 'QUERY_CURRENT_HAND';
}
