import 'package:intl/intl.dart';

class AppConstants {
  AppConstants._();

  static const List<String> GIF_CATEGORIES = const [
    'All-in',
    'Donkey',
    'Fish',
    'HAHA',
  ];

  static DateFormat CHAT_DATE_TIME_FORMAT = DateFormat("hh:mm a");

  static const PROD_MODE = false;

  static const String API_SERVER_URL = 'API_SERVER_URL';

  // DO URLs
  static const String DO_API_URL = 'https://api.pokerapp.club/graphql';

  static const int buyInTimeOutSeconds = 100;

  static const Duration cardShufflingWaitDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration cardShufflingAnimationDuration = const Duration(
    milliseconds: 150,
  );

  static const Duration cardDistributionAnimationDuration = const Duration(
    milliseconds: 150,
  );

  static const Duration buildWaitDuration = const Duration(
    milliseconds: 100,
  );

  static const Duration chipMovingAnimationDuration = const Duration(
    milliseconds: 400,
  );

  static const Duration communityCardAnimationDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration communityCardFlipAnimationDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration fastAnimationDuration = const Duration(
    milliseconds: 300,
  );

  static const Duration animationDuration = const Duration(
    milliseconds: 500,
  );

  static const Duration seatChangeAnimationDuration = const Duration(
    milliseconds: 500,
  );

  static const Duration popUpAnimationDuration = const Duration(
    milliseconds: 300,
  );

  static const Duration replayPauseDuration = const Duration(
    milliseconds: 1500,
  );

  static const Duration clubMessagePollDuration = const Duration(
    milliseconds: 1000,
  );

  static const Duration userPopUpMessageHoldDuration = const Duration(
    seconds: 2,
  );

  static const Duration notificationDuration = const Duration(
    seconds: 5,
  );

  static const String blackSpade = '♠';
  static const String redHeart = '♥';
  static const String blackClub = '♣';
  static const String redDiamond = '♦';
  static const String redHeart2 = '❤';

  /* TABLE UPDATE types */
  static const String SeatChangeInProgress = 'SeatChangeInProgress';
  static const String TableUpdateOpenSeat = "OpenSeat";
  static const String TableWaitlistSeating = "WaitlistSeating";
  static const String TableSeatChangeProcess = "SeatChangeInProgress";
  static const String TableHostSeatChangeProcessStart =
      "HostSeatChangeInProcessStart";
  static const String TableHostSeatChangeProcessEnd =
      "HostSeatChangeInProcessEnd";
  static const String TableHostSeatChangeMove = "HostSeatChangeMove";
  static const String TableUpdatePlayerSeats = "UpdatePlayerSeats";

  /* RUN IT TWICE constants */
  static const String RUN_IT_TWICE_PROMPT = 'RUN_IT_TWICE_PROMPT';
  static const String RUN_IT_TWICE_YES = 'RUN_IT_TWICE_YES';
  static const String RUN_IT_TWICE_NO = 'RUN_IT_TWICE_NO';

  /* NEW UPDATE player statuses */
  static const String NEW_PLAYER = 'NEW_PLAYER';
  static const String RELOAD_CHIPS = 'RELOAD_CHIPS';
  static const String SWITCH_SEAT = 'SWITCH_SEAT';
  static const String TAKE_BREAK = 'TAKE_BREAK';
  static const String SIT_BACK = 'SIT_BACK';
  static const String LEFT = 'LEFT';
  static const String LEFT_THE_GAME = 'LEFT_THE_GAME';
  static const String EMPTY_STACK = 'EMPTY_STACK';
  static const String NOT_PLAYING = 'NOT_PLAYING';
  static const String WAIT_FOR_BUYIN = 'WAIT_FOR_BUYIN';
  static const String PLAYING = 'PLAYING';
  static const String BUYIN_TIMEDOUT = 'BUYIN_TIMEDOUT';
  static const String WAIT_FOR_BUYIN_APPROVAL = 'WAIT_FOR_BUYIN_APPROVAL';
  static const String NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL =
      'NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL';
  static const String NEW_BUYIN = 'NEW_BUYIN';
  static const String BUYIN_DENIED = 'BUYIN_DENIED';
  static const String NEWUPDATE_NOT_PLAYING = 'NEWUPDATE_NOT_PLAYING';

  static const String IN_BREAK = 'IN_BREAK';

  /* table statuses */
  static const String WAITING_TO_BE_STARTED = 'WAITING_TO_BE_STARTED';
  static const String TABLE_STATUS_NOT_ENOUGH_PLAYERS = 'NOT_ENOUGH_PLAYERS';
  static const String TABLE_STATUS_GAME_RUNNING = 'TABLE_STATUS_GAME_RUNNING';
  static const String GAME_ACTIVE = 'ACTIVE';
  static const String GAME_RUNNING = 'GAME_RUNNING';
  static const String GAME_ENDED = 'ENDED';
  static const String GAME_PAUSED = 'PAUSED';
  static const String CLEAR = 'CLEAR';

  static const String FOLD = 'FOLD';
  static const String CHECK = 'CHECK';
  static const String RAISE = 'RAISE';
  static const String BET = 'BET';
  static const String CALL = 'CALL';
  static const String ALLIN = 'ALLIN';

  /* message types */
  static const String PLAYER_UPDATE = 'PLAYER_UPDATE';
  static const String TABLE_UPDATE = 'TABLE_UPDATE';
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
  static const String MSG_ACK = 'MSG_ACK';
  static const String RUN_IT_TWICE = 'RUN_IT_TWICE';

  static const String PREFLOP = 'PREFLOP';
  static const String FLOP = 'FLOP';
  static const String TURN = 'TURN';
  static const String RIVER = 'RIVER';

  static const String ANNOUNCEMENT = 'ANNOUNCEMENT';
  static const String DEALER_CHOICE = 'DEALER_CHOICE';

  /* new message types */
  static const String PLAYER_SEAT_CHANGE_BEGIN = 'PLAYER_SEAT_CHANGE_BEGIN';
  static const String PLAYER_SEAT_CHANGE_PROMPT = 'PLAYER_SEAT_CHANGE_PROMPT';
  static const String PLAYER_SEAT_MOVE = 'PLAYER_SEAT_MOVE';
  static const String PLAYER_SEAT_CHANGE_DONE = 'PLAYER_SEAT_CHANGE_DONE';
}
