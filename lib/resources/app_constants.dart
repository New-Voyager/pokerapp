class AppConstants {
  AppConstants._();

  static const String API_SERVER_URL = 'API_SERVER_URL';

  // DO URLs
  static const String DO_API_URL = 'https://api.pokerapp.club/graphql';

  static const int buyInTimeOutSeconds = 100;

  static const Duration cardShufflingWaitDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration cardShufflingAnimationDuration = const Duration(
    milliseconds: 250,
  );

  static const Duration cardDistributionAnimationDuration = const Duration(
    milliseconds: 250,
  );

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
    milliseconds: 500,
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

  static const Duration notificationDuration = const Duration(
    seconds: 5,
  );

  static const String giphyApiKey = 'IoanUNVNMRCaTnTpYzB2UDxUdatagMkQ';

  static const String blackSpade = '♠';
  static const String redHeart = '♥';
  static const String blackClub = '♣';
  static const String redDiamond = '♦';

  /* NEW UPDATE player statuses */
  static const String NEW_PLAYER = 'NEW_PLAYER';
  static const String RELOAD_CHIPS = 'RELOAD_CHIPS';
  static const String SWITCH_SEAT = 'SWITCH_SEAT';
  static const String TAKE_BREAK = 'TAKE_BREAK';
  static const String SIT_BACK = 'SIT_BACK';
  static const String LEFT_THE_GAME = 'LEFT_THE_GAME';
  static const String EMPTY_STACK = 'EMPTY_STACK';

  /* table statuses */
  static const String WAITING_TO_BE_STARTED = 'WAITING_TO_BE_STARTED';
  static const String TABLE_STATUS_NOT_ENOUGH_PLAYERS = 'NOT_ENOUGH_PLAYERS';
  static const String TABLE_STATUS_GAME_RUNNING = 'TABLE_STATUS_GAME_RUNNING';
  static const String GAME_RUNNING = 'GAME_RUNNING';
  static const String GAME_ENDED = 'ENDED';

  /* extra identifiers */
  static const String WAIT_FOR_BUYIN = 'WAIT_FOR_BUYIN';
  static const String PLAYING = 'PLAYING';

  static const String FOLD = 'FOLD';
  static const String CHECK = 'CHECK';
  static const String RAISE = 'RAISE';
  static const String BET = 'BET';
  static const String CALL = 'CALL';

  /* message types */
  static const String PLAYER_UPDATE = 'PLAYER_UPDATE';
  static const String HIGH_HAND = 'HIGH_HAND';
  static const String GAME_STATUS = 'GAME_STATUS';
  static const String NEW_HAND = 'NEW_HAND';
  static const String DEAL_STARTED = 'DEAL_STARTED';
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
