import 'package:intl/intl.dart';

class AppConstants {
  AppConstants._();

  static const List<String> maskedList = [
    "money",
    "cashapp",
    "venmo",
    "dollar",
    "bank"
  ];

  static const List<String> GIF_CATEGORIES_CLUB = const [
    "Sad",
    "Cry",
    "Angry",
    "Savage"
  ];

  static const List<String> GIF_CATEGORIES = const [
    'all-in',
    'donkey',
    'funny',
    'joy',
    'laugh',
    'excited',
    'bluff',
    'suck',
    'happy',
    'dance',
    'angry',
    'mad',
  ];

  static DateFormat CHAT_DATE_TIME_FORMAT = DateFormat("hh:mm a");

  static const PROD_MODE = false;

  static const String API_SERVER_URL = 'API_SERVER_URL';

  static const String DEVICE_ID = 'DEVICE_ID';

  static const String DEVICE_SECRET = 'DEVICE_SECRET';

  // DO URLs
  static const String DO_API_URL = 'https://api.pokerapp.club/graphql';

  static const int buyInTimeOutSeconds = 100;

  static const int maxDiamondNumber = 20;

  static const int maxTimeBankSecs = 60;

  static const Duration diamondUpdateDuration = const Duration(minutes: 15);

  static const Duration timebankUpdateDuration = const Duration(minutes: 15);

  static const Duration cardShufflingTotalWaitDuration = const Duration(
    milliseconds: 300,
  );

  static const Duration bombPotTotalWaitDuration = const Duration(
    milliseconds: 2000,
  );

  static const Duration cardShufflingWaitDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration cardShufflingAnimationDuration = const Duration(
    milliseconds: 150,
  );

  static const Duration cardDistributionWaitBetweenPlayersDuration =
      const Duration(
    milliseconds: 80,
  );

  static const Duration cardDistributionAnimationDuration = const Duration(
    milliseconds: 350,
  );

  static const Duration buildWaitDuration = const Duration(
    milliseconds: 100,
  );

  static const Duration chipMovingAnimationDuration = const Duration(
    milliseconds: 120,
  );

  static const Duration communityCardAnimationDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration communityCardFlipAnimationDuration = const Duration(
    milliseconds: 200,
  );

  static const Duration fastestAnimationDuration = const Duration(
    milliseconds: 150,
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

  static const Duration messagePollDuration = const Duration(
    milliseconds: 1000,
  );

  static const Duration userPopUpMessageHoldDuration = const Duration(
    seconds: 2,
  );

  static const Duration notificationDuration = const Duration(
    seconds: 5,
  );

  static const Duration highHandFireworkAnimationDuration = const Duration(
    milliseconds: 3020, // THIS IS CALCULATED FROM THE GIF ITSELF
  );

  static const String blackSpade = '♠';
  static const String redHeart = '♥';
  static const String blackClub = '♣';
  static const String redDiamond = '♦';
  static const String redHeart2 = '❤';

  /* TABLE UPDATE types */
  static const String SeatChangeInProgress = 'SeatChangeInProgress';
  static const String TableUpdateOpenSeat = "OpenSeat";
  static const String TableUpdateReserveSeat = "ReserveSeat";
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

  static const String STRADDLE = 'STRADDLE';

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
  static const String RELOAD_DENIED = 'RELOAD_DENIED';

  static const String IN_BREAK = 'IN_BREAK';
  static const String IN_QUEUE = 'IN_QUEUE';

  /* table statuses */
  static const String WAITING_TO_BE_STARTED = 'WAITING_TO_BE_STARTED';
  static const String TABLE_STATUS_NOT_ENOUGH_PLAYERS = 'NOT_ENOUGH_PLAYERS';
  static const String TABLE_STATUS_GAME_RUNNING = 'TABLE_STATUS_GAME_RUNNING';
  static const String TABLE_STATUS_GAME_RUNNING_1 = 'GAME_RUNNING';
  static const String TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS =
      'HOST_SEATCHANGE_IN_PROGRESS';

  static const String GAME_CONFIGURED = 'CONFIGURED';
  static const String GAME_ACTIVE = 'ACTIVE';
  static const String GAME_RUNNING = 'GAME_RUNNING';
  static const String GAME_ENDED = 'ENDED';
  static const String GAME_PAUSED = 'PAUSED';

  static const String FOLD = 'FOLD';
  static const String CHECK = 'CHECK';
  static const String RAISE = 'RAISE';
  static const String BET = 'BET';
  static const String CALL = 'CALL';
  static const String ALLIN = 'ALLIN';
  static const String SB = 'SB';
  static const String BB = 'BB';
  static const String BOMP_BOT_PET = 'BOMB POT';

  // types of winners - high and low winners
  static const String HIGH_WINNERS = 'High';
  static const String LOW_WINNERS = 'Low';

  /* message types */
  static const String PLAYER_UPDATE = 'PLAYER_UPDATE';
  static const String GAME_SETTINGS_CHANGED = 'GAME_SETTINGS_CHANGED';
  static const String STACK_RELOADED = 'STACK_RELOADED';
  static const String NEW_HIGHHAND_WINNER = 'NEW_HIGHHAND_WINNER';
  static const String TABLE_UPDATE = 'TABLE_UPDATE';
  static const String HIGH_HAND = 'HIGH_HAND';
  static const String GAME_STATUS = 'GAME_STATUS';
  static const String GAME_ENDING = 'GAME_ENDING';
  static const String WAITLIST_SEATING = 'WAITLIST_SEATING';
  static const String NEW_HAND = 'NEW_HAND';
  static const String DEAL_STARTED = 'DEAL_STARTED';
  static const String BOMB_POT = 'BOMBPOT';
  static const String DEAL = 'DEAL';
  static const String NEXT_ACTION = 'NEXT_ACTION';
  static const String PLAYER_ACTED = 'PLAYER_ACTED';
  static const String YOUR_ACTION = 'YOUR_ACTION';
  static const String QUERY_CURRENT_HAND = 'QUERY_CURRENT_HAND';
  static const String RESULT = 'RESULT';
  static const String RESULT2 = 'RESULT2';
  static const String MSG_ACK = 'MSG_ACK';
  static const String RUN_IT_TWICE = 'RUN_IT_TWICE';
  static const String PLAYER_CONNECTIVITY_LOST = 'PLAYER_CONNECTIVITY_LOST';
  static const String PLAYER_CONNECTIVITY_RESTORED =
      'PLAYER_CONNECTIVITY_RESTORED';
  static const String EXTEND_ACTION_TIMER = 'EXTEND_ACTION_TIMER';
  static const String DEALER_CHOICE_PROMPT = 'DEALER_CHOICE_PROMPT';
  static const String DEALER_CHOICE_GAME = 'DEALER_CHOICE_GAME';

  static const String PREFLOP = 'PREFLOP';
  static const String FLOP = 'FLOP';
  static const String TURN = 'TURN';
  static const String RIVER = 'RIVER';
  static const String SHOW_DOWN = 'SHOW_DOWN';

  static const String ANNOUNCEMENT = 'ANNOUNCEMENT';
  static const String DEALER_CHOICE = 'DEALER_CHOICE';

  /* new message types */
  static const String PLAYER_SEAT_CHANGE_BEGIN = 'PLAYER_SEAT_CHANGE_BEGIN';
  static const String PLAYER_SEAT_CHANGE_PROMPT = 'PLAYER_SEAT_CHANGE_PROMPT';
  static const String PLAYER_SEAT_MOVE = 'PLAYER_SEAT_MOVE';
  static const String PLAYER_SEAT_CHANGE_DONE = 'PLAYER_SEAT_CHANGE_DONE';
}
