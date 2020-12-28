class AppConstants {
  AppConstants._();

  static const String NATS_URL = 'NATS_URL';
  static const String API_SERVER_URL = 'API_SERVER_URL';

  static const int buyInTimeOutSeconds = 100;

  static const Duration buildWaitDuration = const Duration(
    milliseconds: 100,
  );

  static const Duration communityCardPushDuration = const Duration(
    milliseconds: 300,
  );

  static const Duration fastAnimationDuration = const Duration(
    milliseconds: 300,
  );

  static const Duration animationDuration = const Duration(
    milliseconds: 600,
  );

  static const Duration popUpAnimationDuration = const Duration(
    milliseconds: 300,
  );

  static const Duration clubMessagePollDuration = const Duration(
    milliseconds: 500,
  );

  static const Duration userPopUpMessageHoldDuration = const Duration(
    seconds: 2,
  );

  static const String giphyApiKey = 'IoanUNVNMRCaTnTpYzB2UDxUdatagMkQ';

  static const String blackSpade = '♠';
  static const String redHeart = '♥';
  static const String blackClub = '♣';
  static const String redDiamond = '♦';

  /* table statuses */
  static const String WAITING_TO_BE_STARTED = 'WAITING_TO_BE_STARTED';
  static const String TABLE_STATUS_NOT_ENOUGH_PLAYERS = 'NOT_ENOUGH_PLAYERS';
  static const String TABLE_STATUS_GAME_RUNNING = 'TABLE_STATUS_GAME_RUNNING';
  static const String GAME_RUNNING = 'GAME_RUNNING';

  /* extra identifiers */
  static const String WAIT_FOR_BUYIN = 'WAIT_FOR_BUYIN';
  static const String PLAYING = 'PLAYING';

  static const String FOLD = 'FOLD';
  static const String RAISE = 'RAISE';
  static const String BET = 'BET';

  /* message types */
  static const String PLAYER_UPDATE = 'PLAYER_UPDATE';
  static const String GAME_STATUS = 'GAME_STATUS';
  static const String NEW_HAND = 'NEW_HAND';
  static const String DEAL = 'DEAL';
  static const String NEXT_ACTION = 'NEXT_ACTION';
  static const String PLAYER_ACTED = 'PLAYER_ACTED';
  static const String YOUR_ACTION = 'YOUR_ACTION';
  static const String QUERY_CURRENT_HAND = 'QUERY_CURRENT_HAND';
  static const String RESULT = 'RESULT';

  static const String PREFLOP = 'PREFLOP';
  static const String FLOP = 'FLOP';
  static const String TURN = 'TURN';
  static const String RIVER = 'RIVER';
}
